#!/usr/bin/env bash
source ./conf/SmokeConfig.config

echo "IMPALA_DAEMON: $IMPALA_DAEMON"
echo "IMPALA_TABLE_NAME: $IMPALA_TABLE_NAME"
echo "IMPALA_SSL_ENABLED: $IMPALA_SSL_ENABLED"

IMPALA_CONNECT_STRING="${IMPALA_DAEMON}"
if $IMPALA_SSL_ENABLED; then
	echo "IKOPTS: ${IKOPTS}"
	echo "ITOPTS: ${ITOPTS}"
	IMPALA_CONNECT_STRING="${IMPALA_CONNECT_STRING} ${IKOPTS} ${ITOPTS}"
fi
echo "IMPALA_CONNECT_STRING: ${IMPALA_CONNECT_STRING}"

#impala-shell -i $IMPALA_CONNECT_STRING -q "invalidate metadata;"
#rc=$?; if [[ $rc != 0 ]]; then echo "Invalidation failed! exiting"; echo " - Impala       - Failed [Invalidation failed]" >> ./log/SummaryReport.txt; exit $rc; fi

impala-shell -i $IMPALA_CONNECT_STRING -d default -q "SET SYNC_DDL=true; CREATE TABLE ${IMPALA_TABLE_NAME} (x INT, y STRING);"
rc=$?; if [[ $rc != 0 ]]; then echo "Create query failed! exiting"; echo " - Impala       - Failed [Create query failed]" >> ./log/SummaryReport.txt; exit $rc; fi

impala-shell -i $IMPALA_CONNECT_STRING -d default -q "INSERT INTO ${IMPALA_TABLE_NAME} VALUES (1, 'one'), (2, 'two'), (3, 'three');"
rc=$?; if [[ $rc != 0 ]]; then echo "Insert query failed! exiting"; echo " - Impala       - Failed [Insert query failed]" >> ./log/SummaryReport.txt; exit $rc; fi

impala-shell -i $IMPALA_CONNECT_STRING -d default -q "SELECT * FROM ${IMPALA_TABLE_NAME};" --delimited --output_delimiter=, --refresh_after_connect --output_file=impala_select_test.txt
rc=$?; if [[ $rc != 0 ]]; then echo "Select query failed! exiting"; echo " - Impala       - Failed [Select query failed]" >> ./log/SummaryReport.txt; exit $rc; fi

cat <<EOF >impala_check.txt
1,one
2,two
3,three
EOF

diff -u impala_select_test.txt impala_check.txt
status=$?

if [[ $status = 0 ]]; then
	echo "Files are the same"
	echo "***************************************"
	echo "* Impala test completed Successfully! *"
	echo "***************************************"
	echo " - Impala       - Passed" >> ./log/SummaryReport.txt
else
	echo "Files are different"
	echo "***************************************"
	echo "* Impala test not  completed Successfully! *"
	echo "***************************************"
	echo " - Impala       - Failed [Data in impala and Data inserted are different]" >> ./log/SummaryReport.txt
fi
