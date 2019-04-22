#!/bin/bash
source /mnt/SmokeTest/SmokeConfig.config
#source  /mnt/SmokeTest/SmokeConfig1.config


echo "hdfs"
su -c "hdfs dfs -rm -r  $HDFS_PATH" hdfs

rm -f $TEMP_PATH

echo "******************************************************************************************************************************************" >>$LOG_PATH
echo "hive"

su -c "bash hivedrop.sh" hive

rm -f $HIVE_DATA_PATH

echo "******************************************************************************************************************************************" >>$LOG_PATH
echo "hbase"


hbase shell -n  hbase_rm.sh
#rm -f /tmp/hbase.$$ /tmp/hbase-rm.$$

echo "******************************************************************************************************************************************" >>$LOG_PATH
echo "spark"
su -c "hdfs dfs -rm -R $SPARK_OUT_CLUS" hdfs
#rm -f /tmp/spark.$$
#hdfs dfs -rm -R /tmp/sparkout2.$$ /tmp/sparkin2.$$
#rm -f /tmp/spark2.$$

echo "******************************************************************************************************************************************" >>$LOG_PATH
echo "pig"

su -c "hdfs dfs -rm -R $PIG_PATH_OUT" hdfs
#rm -f /tmp/pig.$$
#solrctl collection --delete test_collection
#solrctl instancedir --delete test_config
#kinit solr
#hdfs dfs -rm -R -skipTrash /solr/test_collection
#rm -rf /tmp/test_config.$$
#impala-shell -i $IMPALAD $IKOPTS $ITOPTS -q 'DROP TABLE kudu_test;'
echo "******************************************************************************************************************************************" >>$LOG_PATH
echo "kafka"
$KAFKA_HOME/kafka-topics.sh --zookeeper ${ZOOKEEPER} --delete --topic test
#kdestroy
