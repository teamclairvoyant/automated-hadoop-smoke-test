#!/bin/bash



source /mnt/SmokeTest/SmokeConfig.config

exec &> >(tee -a "$LOG_PATH")

echo "Smoke test for HDFS" >> $LOG_PATH


bash /mnt/SmokeTest/hdfsTest.sh >> $LOG_PATH


echo "******************************************************************************************************************************************" >>$LOG_PATH
echo "Smoke test for HIVE" >> $LOG_PATH




su -c "bash /mnt/SmokeTest/hiveTest.sh" hive >> $LOG_PATH


echo "******************************************************************************************************************************************" >>$LOG_PATH
echo "Smoke test for HBASE" >> $LOG_PATH


 su -c "hbase shell /mnt/SmokeTest/hbase.sh" hbase >> $LOG_PATH


echo "******************************************************************************************************************************************" >>$LOG_PATH
echo "Smoke Test for Yarn" >> $LOG_PATH

su -c "hdfs dfs -rm -r $MAP_REDUCE_OUT" hdfs >> $LOG_PATH
 
su -c "yarn jar $SCRIPT_HOME/MapReduce-1.0.jar com.fs.WordCount $MAP_REDUCE_IN/WordCountFile.txt $MAP_REDUCE_OUT" yarn >> $LOG_PATH


echo "******************************************************************************************************************************************" >>$LOG_PATH
echo "Smoke test for KAFKA" >> $LOG_PATH


bash kafkaTest.sh 

echo "******************************************************************************************************************************************" >>$LOG_PATH
echo "Smoke test for SPARK" >> $LOG_PATH



echo "this is the end. the only end. my friend." >$SPARK_IN_CLUS
su -c "hdfs dfs -put $SPARK_IN_LOC $SPARK_IN_CLUS" hdfs

su -c "/bin/spark-shell -i  piEstimation.scala " spark >> $LOG_PATH


su -c "spark-shell -i wordcount.scala --conf spark.driver.args=\"$SPARK_IN_CLUS $SPARK_OUT_CLUS\"" spark >> $LOG_PATH


#echo "Smoke test for solar" >> $LOG_PATH

#su -c "bash solrSmokeTest.sh" spark >> $LOG_PATH
echo "******************************************************************************************************************************************" >>$LOG_PATH
bash CleanItUp.sh
