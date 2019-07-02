#!/usr/bin/env bash
source ./conf/SmokeConfig.config

impala-shell -i $IMPALADAEMON -q 'CREATE TABLE kudu_test(id BIGINT, name STRING, PRIMARY KEY(id)) PARTITION BY HASH PARTITIONS 3 STORED AS KUDU;'
rc=$?; if [[ $rc != 0 ]]; then echo "Create query failed! exiting"; echo " - Kudu 		- Failed [Create query failed]" >> ./log/${timestamp}SummaryReport.txt; exit $rc; fi

impala-shell -i $IMPALADAEMON -q 'INSERT INTO TABLE kudu_test VALUES (1, "wasim"), (2, "ninad"), (3, "mohsin");'
rc=$?; if [[ $rc != 0 ]]; then echo "Insert into query failed! exiting"; echo " - Kudu 		- Failed [Insert into query failed]" >> ./log/${timestamp}SummaryReport.txt; exit $rc; fi

impala-shell -i $IMPALADAEMON -q 'SELECT * FROM kudu_test WHERE id=1;'
rc=$?; if [[ $rc != 0 ]]; then echo "Select query failed! exiting"; echo " - Kudu 		- Failed [Select query failed]" >> ./log/${timestamp}SummaryReport.txt; exit $rc; fi


echo "***************************************"
echo "*  Kudu test completed Successfully!  *"
echo "***************************************"

echo " - Kudu		- Passed" >> ./log/${timestamp}SummaryReport.txt