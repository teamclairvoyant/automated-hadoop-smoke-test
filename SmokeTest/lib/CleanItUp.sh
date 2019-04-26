#!/bin/bash
source ./conf/SmokeConfig.config


echo " removing bits - hdfs"
su -c "hdfs dfs -rm -r  $HDFS_PATH" hdfs

rm -f $TEMP_PATH

echo "******************************************************************************************************************************************"
echo "removing bits - hive"

bash ./lib/hivedrop.sh
rm -f $HIVE_DATA_PATH

echo "******************************************************************************************************************************************" 
echo "removing bits - hbase"


hbase shell -n  ./lib/hbase_rm.txt
#rm -f /tmp/hbase.$$ /tmp/hbase-rm.$$

echo "******************************************************************************************************************************************"
echo "removing bits - spark"
su -c "hdfs dfs -rm -R $SPARK_OUT_CLUS" hdfs
#rm -f /tmp/spark.$$
#hdfs dfs -rm -R /tmp/sparkout2.$$ /tmp/sparkin2.$$
#rm -f /tmp/spark2.$$

echo "******************************************************************************************************************************************" 
echo "removing bits - pig"

su -c "hdfs dfs -rm -R $PIG_PATH_OUT" hdfs

#rm -f /tmp/pig.$$
#solrctl collection --delete test_collection
#solrctl instancedir --delete test_config
#kinit solr
#hdfs dfs -rm -R -skipTrash /solr/test_collection
#rm -rf /tmp/test_config.$$
#impala-shell -i $IMPALAD $IKOPTS $ITOPTS -q 'DROP TABLE kudu_test;'
echo "******************************************************************************************************************************************"
echo "removing bits - kafka"
$KAFKA_HOME/kafka-topics.sh --zookeeper ${ZOOKEEPER} --delete --topic test
#kdestroy
