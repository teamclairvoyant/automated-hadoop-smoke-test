#!/bin/bash
source ./conf/SmokeConfig.config

HIVESERVER2=$HIVESERVER2
REALM=${REALM}
BKOPTS=$BKOPTS


beeline -n `whoami` -u "jdbc:hive2://${HIVESERVER2}:10000/${BKOPTS}" -e "CREATE TABLE test(id INT, name STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY ' ' STORED AS TEXTFILE;"
rc=$?; if [[ $rc != 0 ]]; then echo "Create query failed! exiting"; echo " - Hive	- Failed [Create query failed]" >> ./log/SummaryReport.txt; exit $rc; fi

echo "1 justin" > $HIVE_DATA_PATH
rc=$?; if [[ $rc != 0 ]]; then echo "Input data generation failed! exiting"; echo " - Hive	- Failed [Input data generation failed]" >> ./log/SummaryReport.txt; exit $rc; fi
echo "2 michael" >> $HIVE_DATA_PATH
rc=$?; if [[ $rc != 0 ]]; then echo "Input data generation failed! exiting"; echo " - Hive	- Failed [Input data generation failed]" >> ./log/SummaryReport.txt; exit $rc; fi

hdfs dfs -put $HIVE_DATA_PATH  $HIVE_WAREHOUSE
rc=$?; if [[ $rc != 0 ]]; then echo "Input data transfer failed! exiting"; echo " - Hive	- Failed [Input data transfer failed]" >> ./log/SummaryReport.txt; exit $rc; fi

beeline -n `whoami` -u "jdbc:hive2://${HIVESERVER2}:10000/${BKOPTS}" -e "SELECT * FROM test WHERE id=1;"
rc=$?; if [[ $rc != 0 ]]; then echo "Select query failed! exiting"; echo " - Hive	- Failed [Select query failed]" >> ./log/SummaryReport.txt; exit $rc; fi

echo "**************************************"
echo "* Hive test completed Successfully ! *"
echo "**************************************"

echo "- Hive	- Passed" >> ./log/SummaryReport.txt
