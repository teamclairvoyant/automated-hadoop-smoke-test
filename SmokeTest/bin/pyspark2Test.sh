#!/bin/bash
source ./conf/SmokeConfig.config

echo "PYSPARK_IN_CLUS: $PYSPARK_IN_CLUS"
echo "PYSPARK_OUT_CLUS: $PYSPARK_OUT_CLUS"

hdfs dfs -mkdir -p "$PYSPARK_IN_CLUS"
if hadoop fs -test -d "$SPARK_OUT_CLUS"; then hdfs dfs -rm -r "$SPARK_OUT_CLUS"; fi

echo "this is the end. the only end. my friend." >> pyspark2_test.txt
rc=$?; if [[ $rc != 0 ]]; then echo "Cannot produce input data! exiting"; echo " - pySpark2     - Failed [Cannot produce input data]" >> "$LOG_PATH"/SummaryReport.txt; exit $rc; fi

hdfs dfs -put -f pyspark2_test.txt "$PYSPARK_IN_CLUS"
rc=$?; if [[ $rc != 0 ]]; then echo "Cannot copy input data! exiting"; echo " - pySpark2     - Failed [Cannot copy input data]" >> "$LOG_PATH"/SummaryReport.txt; exit $rc; fi

echo "--- piEstimation ---"
spark2-submit ./lib/piEstimation_pyspark2.py
rc=$?; if [[ $rc != 0 ]]; then echo "Pi Estimation test failed! exiting"; echo " - pySpark2     - Failed [Pi Estimation test failed]" >> "$LOG_PATH"/SummaryReport.txt; exit $rc; fi

echo "--- wordcount ---"
spark2-submit ./lib/wordcount_pyspark2.py "$PYSPARK_IN_CLUS" "$PYSPARK_OUT_CLUS"
rc=$?; if [[ $rc != 0 ]]; then echo "Word count test failed! exiting"; echo " - pySpark2     - Failed [Word count test failed]" >> "$LOG_PATH"/SummaryReport.txt; exit $rc; fi

echo "*****************************************"
echo "* pySpark2 test completed Successfully! *"
echo "*****************************************"

echo " - pySpark2     - Passed" >> "$LOG_PATH"/SummaryReport.txt
