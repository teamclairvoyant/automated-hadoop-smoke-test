#!/bin/bash
source ./conf/SmokeConfig.config

echo "##########"
echo "IMPALA_SSL_ENABLED: $IMPALA_SSL_ENABLED"
echo "IMPALA_KERBEROS_ENABLED: $IMPALA_KERBEROS_ENABLED"
echo "IMPALA_LDAP_ENABLED: $IMPALA_LDAP_ENABLED"
echo "KUDU_TABLE_NAME: $KUDU_TABLE_NAME"

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

# shellcheck disable=SC2086
impala-shell $IMPALA_CONNECT_STRING -q "SET SYNC_DDL=true; CREATE TABLE ${KUDU_TABLE_NAME} (id BIGINT, name STRING, PRIMARY KEY(id)) PARTITION BY HASH PARTITIONS 3 STORED AS KUDU;"
rc=$?
if [[ $rc != 0 ]]; then
  echo "Create query failed! exiting"
  echo " - Kudu         - Failed [Create query failed]" >> ./log/SummaryReport.txt
  exit $rc
fi

# If dealing with a load balancer, you will not get the same backend host as
# the one where the table was created, so tell all of the other Impalads to
# check for the new table.
# shellcheck disable=SC2086
impala-shell $IMPALA_CONNECT_STRING -q "INVALIDATE METADATA ${KUDU_TABLE_NAME};"
rc=$?
if [[ $rc != 0 ]]; then
  echo "Invalidation failed! exiting"
  echo " - Kudu         - Failed [Invalidation failed]" >> ./log/SummaryReport.txt
  exit $rc
fi
sleep 10

# shellcheck disable=SC2086
impala-shell $IMPALA_CONNECT_STRING -q "INSERT INTO TABLE ${KUDU_TABLE_NAME} VALUES (1, 'wasim'), (2, 'ninad'), (3, 'mohsin');"
rc=$?
if [[ $rc != 0 ]]; then
  echo "Insert query failed! exiting"
  echo " - Kudu         - Failed [Insert query failed]" >> ./log/SummaryReport.txt
  exit $rc
fi

# shellcheck disable=SC2086
impala-shell $IMPALA_CONNECT_STRING -q "REFRESH ${KUDU_TABLE_NAME}; SELECT * FROM ${KUDU_TABLE_NAME};" --delimited --output_delimiter=, --output_file=kudu_select_test.txt
rc=$?
if [[ $rc != 0 ]]; then
  echo "Select query failed! exiting"
  echo " - Kudu         - Failed [Select query failed]" >> ./log/SummaryReport.txt
  exit $rc
fi

sort -o kudu_select_test.txt kudu_select_test.txt
cat <<EOF >kudu_check.txt
1,wasim
2,ninad
3,mohsin
EOF

diff -u kudu_select_test.txt kudu_check.txt
status=$?

if [[ $status = 0 ]]; then
	echo "Files are the same"
	echo "*************************"
	echo "* Kudu test successful! *"
	echo "*************************"
	echo " - Kudu         - Passed" >> ./log/SummaryReport.txt
else
	echo "Files are different"
	echo "*********************"
	echo "* Kudu test failed! *"
	echo "*********************"
	echo " - Kudu         - Failed [Data in impala and Data inserted are different]" >> ./log/SummaryReport.txt
fi

