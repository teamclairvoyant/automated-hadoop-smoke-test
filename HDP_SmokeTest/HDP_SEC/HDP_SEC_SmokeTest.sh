#!/bin/bash
source /home/murshida/KitePharma_SmokeTest/HDP_SEC/conf/SmokeConfig.config

echo $LOG_PATH
exec &> >(tee -a $LOG_PATH)

echo "******************************************************************************************************************************************" >>$LOG_PATH

echo "Smoke test for HDFS started"
kinit -kt $KRB_KEYTAB_HDFS $KRB_PRINCIPAL_HDFS

bash $SCRIPT_HOME/lib/HdfsTest.sh >> $LOG_PATH

echo "Smoke test for HDFS completed"
echo "******************************************************************************************************************************************" >>$LOG_PATH
echo "Smoke test for MAPREDUCE started"

hdfs dfs -rm -r $MAP_REDUCE_OUT

kinit -kt $KRB_KEYTAB_YARN $KRB_PRINCIPAL_YARN

yarn jar $SCRIPT_HOME/lib/MapReduce-1.0.jar com.fs.WordCount $MAP_REDUCE_IN/WordCountFile.txt $MAP_REDUCE_OUT


echo "Smoke test for MAPREDUCE completed"
echo "******************************************************************************************************************************************" >>$LOG_PATH
echo "Smoke test for HIVE started"

echo "hive kerberized" >> $LOG_PATH
kinit -kt $KRB_KEYTAB_HIVE $KRB_PRINCIPAL_HIVE

bash $SCRIPT_HOME/lib/HiveTest.sh >> $LOG_PATH

echo "Smoke test for HIVE completed"
echo "******************************************************************************************************************************************" >>$LOG_PATH
echo "Smoke test for HBASE started"


kinit -kt $KRB_KEYTAB_HBASE $KRB_PRINCIPAL_HBASE
hbase shell -n $SCRIPT_HOME/lib/hbase.txt >> $LOG_PATH

echo "Smoke test for HBASE completed"
echo "******************************************************************************************************************************************" >>$LOG_PATH
echo "Smoke test for KAFKA started" 
kinit -kt $KRB_KEYTAB_KAFKA $KRB_PRINCIPAL_KAFKA
bash $SCRIPT_HOME/lib/KafkaTest.sh 
echo "Smoke test for KAFKA completed"

cd $SCRIPT_HOME

echo "******************************************************************************************************************************************" >>$LOG_PATH

echo "Smoke test for PIG started" 
kinit -kt $KRB_KEYTAB_HIVE $KRB_PRINCIPAL_HIVE
#pig


bash $SCRIPT_HOME/lib/pigExample.sh >>$LOG_PATH
 echo "Smoke test for PIG completed" 
 echo "******************************************************************************************************************************************" >>$LOG_PATH
 echo "Smoke test for SPARK started"
 kinit -kt $KRB_KEYTAB_HIVE $KRB_PRINCIPAL_HIVE

#pi estimation
 /bin/spark-shell -i  $SCRIPT_HOME/lib/piEstimation.scala >>$LOG_PATH
 #wordcount
kinit -kt $KRB_KEYTAB_HDFS $KRB_PRINCIPAL_HDFS

  echo "this is the end. the only end. my friend." >$SPARK_IN_LOC
  hdfs dfs -put $SPARK_IN_LOC $SPARK_IN_CLUS

kinit -kt $KRB_KEYTAB_HIVE $KRB_PRINCIPAL_HIVE
spark-shell -i $SCRIPT_HOME/lib/wordcount.scala --conf spark.driver.args="$SPARK_IN_CLUS $SPARK_OUT_CLUS"



echo "Smoke test for SPARK completed"
echo "******************************************************************************************************************************************" >>$LOG_PATH
echo "Get rid of all the test bits."
pwd
echo $SCRIPT_HOME
cd $SCRIPT_HOME
bash $SCRIPT_HOME/lib/CleanItUp.sh


