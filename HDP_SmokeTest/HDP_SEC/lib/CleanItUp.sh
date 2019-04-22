#!/bin/bash
source /home/murshida/KitePharma_SmokeTest/HDP_SEC/conf/SmokeConfig.config

echo "******************************************************************************************************************************************" >>$LOG_PATH
hdfs dfs -rm $HDFS_PATH
rm -f $TEMP_PATH


echo "******************************************************************************************************************************************" >>$LOG_PATH
kinit -kt $KRB_KEYTAB_HIVE $KRB_PRINCIPAL_HIVE

beeline -u "jdbc:hive2://${HIVESERVER2}:10000/${BKOPTS}${BTOPTS}" -e "DROP
TABLE test;"
rm -f $HIVE_DATA_PATH

echo "******************************************************************************************************************************************" >>$LOG_PATH
kinit -kt $KRB_KEYTAB_HBASE $KRB_PRINCIPAL_HBASE

hbase shell -n  hbase_rm.txt
#rm -f /tmp/hbase.$$ /tmp/hbase-rm.$$

echo "******************************************************************************************************************************************" >>$LOG_PATH
kinit -kt $KRB_KEYTAB_HDFS $KRB_PRINCIPAL_HDFS

hdfs dfs -rm -R $SPARK_OUT_CLUS
hdfs dfs -rm -R $SPARK_IN_CLUS

rm -f /tmp/spark.$$
hdfs dfs -rm -R /tmp/sparkout2.$$ /tmp/sparkin2.$$
rm -f /tmp/spark2.$$


echo "******************************************************************************************************************************************" >>$LOG_PATH

hdfs dfs -rm -R $PIG_PATH_OUT
hdfs dfs -rm -R $SPARK_OUT_CLUS
#rm -f /tmp/pig.$$
#solrctl collection --delete test_collection
#solrctl instancedir --delete test_config
#kinit solr
#hdfs dfs -rm -R -skipTrash /solr/test_collection
#rm -rf /tmp/test_config.$$
#impala-shell -i $IMPALAD $IKOPTS $ITOPTS -q 'DROP TABLE kudu_test;'
$KAFKA_HOME/kafka-topics.sh --zookeeper ${ZOOKEEPER} --delete --topic test
kdestroy
