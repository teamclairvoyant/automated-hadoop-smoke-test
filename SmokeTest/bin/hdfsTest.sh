#!/bin/bash
source ./conf/SmokeConfig.config


hdfs dfs -ls /
rc=$?; if [[ $rc != 0 ]]; then echo "Error in showing files in HDFS! exiting"; echo " - HDFS	- Failed [Error in showing files in HDFS]" >> ./log/SummaryReport.txt; exit $rc; fi

hdfs dfs -put $LOC_PATH $HDFS_PATH
rc=$?; if [[ $rc != 0 ]]; then echo "Error in copying file to HDFS! exiting"; echo " - HDFS	- Failed [Error in copying file to HDFS]" >> ./log/SummaryReport.txt; exit $rc; fi

hdfs dfs -get $HDFS_PATH $TEMP_PATH
rc=$?; if [[ $rc != 0 ]]; then echo "Error in copying file from HDFS! exiting"; echo " - HDFS	- Failed [Error in copying file from HDFS]" >> ./log/SummaryReport.txt; exit $rc; fi

cat $TEMP_PATH
rc=$?; if [[ $rc != 0 ]]; then echo "Error in showing copied file from HDFS! exiting"; echo " - HDFS	- Failed [Error in showing copied file from HDFS]" >> ./log/SummaryReport.txt; exit $rc; fi

echo "**************************************"
echo "* HDFS test completed Successfully ! *"
echo "**************************************"


echo "- HDFS	- Passsed" >> ./log/SummaryReport.txt