source ./conf/SmokeConfig.config

echo "this is the end. the only end. my friend." >$SPARK_IN_LOC 

hdfs dfs -put $SPARK_IN_LOC $SPARK_IN_CLUS

echo "--- piEstimation ---"
spark-shell -i  ./lib/piEstimation.scala

echo "--- wordcount ---"
spark-shell -i ./lib/wordcount.scala --conf spark.driver.args="$SPARK_IN_CLUS $SPARK_OUT_CLUS"

echo "******************************************************************************************************************************************"