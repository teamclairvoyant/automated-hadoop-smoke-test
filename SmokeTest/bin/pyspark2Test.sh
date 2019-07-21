#!/usr/bin/env bash
source ./conf/SmokeConfig.config

echo "PYSPARK_IN_CLUS: $PYSPARK_IN_CLUS"
echo "PYSPARK_OUT_CLUS: $PYSPARK_OUT_CLUS"

hdfs dfs -mkdir -p "$PYSPARK_IN_CLUS"
hdfs dfs -rm -r "$PYSPARK_OUT_CLUS"

echo "this is the end. the only end. my friend." >> pyspark2_test.txt
rc=$?; if [[ $rc != 0 ]]; then echo "Can not produce input data! exiting"; echo " - pySpark2	- Failed [Can not produce input data]" >> ./log/SummaryReport.txt; exit $rc; fi

hdfs dfs -put -f pyspark2_test.txt "$PYSPARK_IN_CLUS"
rc=$?; if [[ $rc != 0 ]]; then echo "Can not copy input data! exiting"; echo " - pySpark2	- Failed [Can not copy input data]" >> ./log/SummaryReport.txt; exit $rc; fi

echo "--- piEstimation ---"
spark2-submit ./lib/piEstimation_pyspark2.py
rc=$?; if [[ $rc != 0 ]]; then echo "Pi Estimation test failed! exiting"; echo " - pySpark2	- Failed [Pi Estimation test failed]" >> ./log/SummaryReport.txt; exit $rc; fi

echo "--- wordcount ---"
spark2-submit ./lib/wordcount_pyspark2.py "$PYSPARK_IN_CLUS" "$PYSPARK_OUT_CLUS"
rc=$?; if [[ $rc != 0 ]]; then echo "Word count test failed! exiting"; echo " - pySpark2	- Failed [Word count test failed]" >> ./log/SummaryReport.txt; exit $rc; fi

echo "**************************************"
echo "* pySpark2 test completed Successfully! *"
echo "**************************************"

echo " - pySpark2	- Passed" >> ./log/SummaryReport.txt