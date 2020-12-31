#!/bin/bash
source ./conf/SmokeConfig.config

echo "##########"
echo "IMPALA_SSL_ENABLED: $IMPALA_SSL_ENABLED"
echo "IMPALA_KERBEROS_ENABLED: $IMPALA_KERBEROS_ENABLED"
echo "IMPALA_LDAP_ENABLED: $IMPALA_LDAP_ENABLED"
echo "IMPALA_TABLE_NAME: $IMPALA_TABLE_NAME"

IMPALA_CONNECT_STRING="--impalad=${IMPALA_DAEMON} --database=${IMPALA_DATABASE_NAME}"
if [ "$IMPALA_SSL_ENABLED" == true ]; then
	IMPALA_CONNECT_STRING="${IMPALA_CONNECT_STRING} ${ITOPTS}"
fi
if [ "$IMPALA_KERBEROS_ENABLED" == true ]; then
	IMPALA_CONNECT_STRING="${IMPALA_CONNECT_STRING} ${IKOPTS}"
fi
if [ "$IMPALA_LDAP_ENABLED" == true ]; then
	IMPALA_CONNECT_STRING="${IMPALA_CONNECT_STRING} ${ILOPTS}"
fi
echo "IMPALA_CONNECT_STRING: ${IMPALA_CONNECT_STRING}"
echo "##########"

impala-shell $IMPALA_CONNECT_STRING -q "SET SYNC_DDL=true; CREATE TABLE ${IMPALA_TABLE_NAME} (x INT, y STRING);"
rc=$?
if [[ $rc != 0 ]]; then
  echo "Create query failed! exiting"
  echo " - Impala       - Failed [Create query failed]" >> ./log/SummaryReport.txt
  exit $rc
fi

impala-shell $IMPALA_CONNECT_STRING -q "INSERT INTO ${IMPALA_TABLE_NAME} VALUES (1, 'one'), (2, 'two'), (3, 'three');"
rc=$?
if [[ $rc != 0 ]]; then
  echo "Insert query failed! exiting"
  echo " - Impala       - Failed [Insert query failed]" >> ./log/SummaryReport.txt
  exit $rc
fi

impala-shell $IMPALA_CONNECT_STRING -q "REFRESH ${IMPALA_TABLE_NAME}; SELECT * FROM ${IMPALA_TABLE_NAME};" --delimited --output_delimiter=, --output_file=impala_select_test.txt
rc=$?
if [[ $rc != 0 ]]; then
  echo "Select query failed! exiting"
  echo " - Impala       - Failed [Select query failed]" >> ./log/SummaryReport.txt
  exit $rc
fi

cat <<EOF >impala_check.txt
1,one
2,two
3,three
EOF

diff -u impala_select_test.txt impala_check.txt
status=$?

if [[ $status = 0 ]]; then
	echo "Files are the same"
	echo "***************************"
	echo "* Impala test successful! *"
	echo "***************************"
	echo " - Impala       - Passed" >> ./log/SummaryReport.txt
else
	echo "Files are different"
	echo "***********************"
	echo "* Impala test failed! *"
	echo "***********************"
	echo " - Impala       - Failed [Data in impala and Data inserted are different]" >> ./log/SummaryReport.txt
fi

