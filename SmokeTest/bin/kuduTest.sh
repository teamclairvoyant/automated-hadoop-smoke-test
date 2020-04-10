#!/usr/bin/env bash
source ./conf/SmokeConfig.config

echo "KUDU_IMPALA_DAEMON: $KUDU_IMPALA_DAEMON"
echo "KUDU_TABLE_NAME: $KUDU_TABLE_NAME"
echo "KUDU_SSL_ENABLED: $KUDU_SSL_ENABLED"

KUDU_IMPALA_CONNECT_STRING="${KUDU_IMPALA_DAEMON}"
if $KUDU_SSL_ENABLED; then
	echo "KUDU_IKOPTS: ${KUDU_IKOPTS}"
	echo "KUDU_ITOPTS: ${KUDU_ITOPTS}"
	KUDU_IMPALA_CONNECT_STRING="${KUDU_IMPALA_CONNECT_STRING} ${KUDU_IKOPTS} ${KUDU_ITOPTS}"
fi
echo "KUDU_IMPALA_CONNECT_STRING: ${KUDU_IMPALA_CONNECT_STRING}"

impala-shell -i $KUDU_IMPALA_CONNECT_STRING -d default -q "SET SYNC_DDL=true; CREATE TABLE ${KUDU_TABLE_NAME} (id BIGINT, name STRING, PRIMARY KEY(id)) PARTITION BY HASH PARTITIONS 3 STORED AS KUDU;"
rc=$?; if [[ $rc != 0 ]]; then echo "Create query failed! exiting"; echo " - Kudu         - Failed [Create query failed]" >> ./log/SummaryReport.txt; exit $rc; fi

impala-shell -i $KUDU_IMPALA_CONNECT_STRING -d default -q "INSERT INTO TABLE ${KUDU_TABLE_NAME} VALUES (1, 'wasim'), (2, 'ninad'), (3, 'mohsin');"
rc=$?; if [[ $rc != 0 ]]; then echo "Insert into query failed! exiting"; echo " - Kudu         - Failed [Insert into query failed]" >> ./log/SummaryReport.txt; exit $rc; fi

impala-shell -i $KUDU_IMPALA_CONNECT_STRING -d default -q "SELECT * FROM ${KUDU_TABLE_NAME} WHERE id=1;"
rc=$?; if [[ $rc != 0 ]]; then echo "Select query failed! exiting"; echo " - Kudu         - Failed [Select query failed]" >> ./log/SummaryReport.txt; exit $rc; fi

echo "***************************************"
echo "*  Kudu test completed Successfully!  *"
echo "***************************************"

echo " - Kudu         - Passed" >> ./log/SummaryReport.txt
