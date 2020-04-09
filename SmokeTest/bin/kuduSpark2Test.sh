#!/bin/bash
source ./conf/SmokeConfig.config

echo "KUDU_MASTER: $KUDU_MASTER"
echo "KUDU_SPARK2_JAR: $KUDU_SPARK2_JAR"
echo "KUDU_SPARK2_TABLE_NAME: $KUDU_SPARK2_TABLE_NAME"

spark2-shell -I ./lib/kudu-spark2.scala --master yarn --jars $KUDU_SPARK2_JAR --conf spark.driver.args="$KUDU_MASTER $KUDU_SPARK2_TABLE_NAME"
rc=$?; if [[ $rc != 0 ]]; then echo "Kudu Spark2 Test failed! Exiting!";  echo " - Kudu-Spark2  - Failed [Check log file]" >> ./log/SummaryReport.txt; exit $rc; fi

echo "***************************************"
echo "*  Kudu-Spark2 test completed Successfully!  *"
echo "***************************************"

echo " - Kudu-Spark2  - Passed" >> ./log/SummaryReport.txt
