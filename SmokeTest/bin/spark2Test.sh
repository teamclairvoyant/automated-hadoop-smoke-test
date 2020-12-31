#!/bin/bash
source ./conf/SmokeConfig.config

echo "SPARK_IN_CLUS: $SPARK_IN_CLUS"
echo "SPARK_OUT_CLUS: $SPARK_OUT_CLUS"

hdfs dfs -mkdir -p "$SPARK_IN_CLUS"
if $(hadoop fs -test -d $SPARK_OUT_CLUS); then hdfs dfs -rm -r "$SPARK_OUT_CLUS"; fi

echo "this is the end. the only end. my friend." >> spark_test.txt
rc=$?; if [[ $rc != 0 ]]; then echo "Cannot produce input data! exiting"; echo " - Spark2       - Failed [Cannot produce input data]" >> ./log/SummaryReport.txt; exit $rc; fi

hdfs dfs -put -f spark_test.txt "$SPARK_IN_CLUS"
rc=$?; if [[ $rc != 0 ]]; then echo "Cannot copy input data! exiting"; echo " - Spark2       - Failed [Cannot copy input data]" >> ./log/SummaryReport.txt; exit $rc; fi

echo "--- piEstimation ---"
spark2-shell -i  ./lib/piEstimation_spark2.scala
rc=$?; if [[ $rc != 0 ]]; then echo "Pi Estimation test failed! exiting"; echo " - Spark2       - Failed [Pi Estimation test failed]" >> ./log/SummaryReport.txt; exit $rc; fi

echo "--- wordcount ---"
spark2-shell -i ./lib/wordcount_spark2.scala --conf spark.driver.args="$SPARK_IN_CLUS" --conf spark.driver.args2="$SPARK_OUT_CLUS"
rc=$?; if [[ $rc != 0 ]]; then echo "Word count test failed! exiting"; echo " - Spark2       - Failed [Word count test failed]" >> ./log/SummaryReport.txt; exit $rc; fi

echo "***************************************"
echo "* Spark2 test completed Successfully! *"
echo "***************************************"

echo " - Spark2       - Passed" >> ./log/SummaryReport.txt
