#!/bin/bash
source ./conf/SmokeConfig.config

echo "SPARK_IN_CLUS: $SPARK_IN_CLUS"
echo "SPARK_OUT_CLUS: $SPARK_OUT_CLUS"

hdfs dfs -mkdir -p "$SPARK_IN_CLUS"
if hadoop fs -test -d "$SPARK_OUT_CLUS"; then hdfs dfs -rm -r "$SPARK_OUT_CLUS"; fi

echo "this is the end. the only end. my friend." >> spark_test.txt
rc=$?; if [[ $rc != 0 ]]; then echo "Cannot produce input data! exiting"; echo " - Spark        - Failed [Cannot produce input data]" >> "$LOG_PATH"/SummaryReport.txt; exit $rc; fi

hdfs dfs -put -f spark_test.txt "$SPARK_IN_CLUS"
rc=$?; if [[ $rc != 0 ]]; then echo "Cannot copy input data! exiting"; echo " - Spark        - Failed [Cannot copy input data]" >> "$LOG_PATH"/SummaryReport.txt; exit $rc; fi

echo "--- piEstimation ---"
spark-shell -i  ./lib/piEstimation_spark.scala
rc=$?; if [[ $rc != 0 ]]; then echo "Pi Estimation test failed! exiting"; echo " - Spark        - Failed [Pi Estimation test failed]" >> "$LOG_PATH"/SummaryReport.txt; exit $rc; fi

echo "--- wordcount ---"
spark-shell -i ./lib/wordcount_spark.scala --conf spark.driver.args="$SPARK_IN_CLUS $SPARK_OUT_CLUS"
rc=$?; if [[ $rc != 0 ]]; then echo "Word count test failed! exiting"; echo " - Spark        - Failed [Word count test failed]" >> "$LOG_PATH"/SummaryReport.txt; exit $rc; fi

echo "**************************************"
echo "* Spark test completed Successfully! *"
echo "**************************************"

echo " - Spark        - Passed" >> "$LOG_PATH"/SummaryReport.txt
