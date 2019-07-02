#!/usr/bin/env bash
source ./conf/SmokeConfig.config

hdfs dfs -mkdir -p $SPARK_IN_CLUS
hdfs dfs -rm -r $SPARK_OUT_CLUS

echo "this is the end. the only end. my friend." >$SPARK_IN_LOC
rc=$?; if [[ $rc != 0 ]]; then echo "Can not produce input data! exiting"; echo " - Spark2	- Failed [Can not produce input data]" >> ./log/SummaryReport.txt; exit $rc; fi

hdfs dfs -put -f $SPARK_IN_LOC $SPARK_IN_CLUS
rc=$?; if [[ $rc != 0 ]]; then echo "Can not copy input data! exiting"; echo " - Spark2	- Failed [Can not copy input data]" >> ./log/SummaryReport.txt; exit $rc; fi

echo "--- piEstimation ---"
spark2-shell -i  ./lib/piEstimation.scala
rc=$?; if [[ $rc != 0 ]]; then echo "Pi Estimation test failed! exiting"; echo " - Spark2	- Failed [Pi Estimation test failed]" >> ./log/SummaryReport.txt; exit $rc; fi

echo "--- wordcount ---"
spark2-shell -i ./lib/wordcount.scala --conf spark.driver.args="$SPARK_IN_CLUS $SPARK_OUT_CLUS"
rc=$?; if [[ $rc != 0 ]]; then echo "Word count test failed! exiting"; echo " - Spark2	- Failed [Word count test failed]" >> ./log/SummaryReport.txt; exit $rc; fi

echo "***************************************"
echo "* Spark2 test completed Successfully! *"
echo "***************************************"

echo " - Spark2	- Passed" >> ./log/SummaryReport.txt