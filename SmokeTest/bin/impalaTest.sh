#!/usr/bin/env bash
source ./conf/SmokeConfig.config

echo "IMPALADAEMON: $IMPALADAEMON"
echo "IMPALA_TABLE_NAME: $IMPALA_TABLE_NAME"
echo "IMPALA_SSL_ENABLED: $IMPALA_SSL_ENABLED"

IMPALA_CONNECT_STRING="${IMPALADAEMON}"

if $IMPALA_SSL_ENABLED; then
	echo "IKOPTS: $IKOPTS"
	echo "ITOPTS: $ITOPTS"
	IMPALA_CONNECT_STRING="${IMPALA_CONNECT_STRING} ${IKOPTS} ${ITOPTS}"
fi

impala-shell -i  "$IMPALA_CONNECT_STRING" -q "invalidate metadata;"
rc=$?; if [[ $rc != 0 ]]; then echo "Invalidation failed! exiting"; echo " - Impala	- Failed [Invalidation failed]" >> ./log/SummaryReport.txt; exit $rc; fi

impala-shell -i  "$IMPALA_CONNECT_STRING" -q "CREATE TABLE ${IMPALA_TABLE_NAME} (x INT, y STRING);"
impala-shell -i  "$IMPALA_CONNECT_STRING" -q "INSERT INTO ${IMPALA_TABLE_NAME} VALUES (1, 'one'), (2, 'two'), (3, 'three');"

impala-shell -i  "$IMPALA_CONNECT_STRING" -q "select * FROM ${IMPALA_TABLE_NAME};" | tail -n +3 | sed -r 's/[-|+]+/ /g' | awk '{$1=$1};1' > impala_select_test.txt
rc=$?; if [[ $rc != 0 ]]; then echo "Select query failed! exiting"; echo " - Impala	- Failed [Select query failed]" >> ./log/SummaryReport.txt; exit $rc; fi

echo "1 one" > impala_check.txt
echo "2 two" >> impala_check.txt
echo "3 three" >> impala_check.txt

diff -B impala_select_test.txt impala_check.txt
status=$?

if [[ $status = 0 ]]; then
	echo "Files are the same"
	echo "***************************************"
	echo "* Impala test completed Successfully! *"
	echo "***************************************"
	echo " - Impala	- Passed" >> ./log/SummaryReport.txt
else
	echo "Files are different"
	echo "***************************************"
	echo "* Impala test not  completed Successfully! *"
	echo "***************************************"
	echo " - Impala	- Failed[datas in impala and date inserted are different]" >> ./log/SummaryReport.txt
fi




