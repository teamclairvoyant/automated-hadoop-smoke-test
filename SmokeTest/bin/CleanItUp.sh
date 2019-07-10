#!/bin/bash
source ./conf/SmokeConfig.config

if $SECURITY ; then
	kinit -kt $KRB_KEYTAB $KRB_PRINCIPAL
fi

if $HDFS ; then
	hdfs dfs -rm -r $HDFS_PATH
	rm -f -r $TEMP_PATH
	echo "******************************************************************************************************************************************"
fi

if $MAPREDUCE ; then
	hdfs dfs -rm -r $MAP_REDUCE_IN/WordCountFile.txt
	hdfs dfs -rm -r $MAP_REDUCE_OUT
	echo "******************************************************************************************************************************************"
fi

if $HIVE ; then
	bash bin/hiveDrop.sh
	rm  -f hive_select_test.txt
	echo "******************************************************************************************************************************************"
fi

if $HBASE ; then
	hbase shell -n  ./lib/hbase_rm.txt
	echo "******************************************************************************************************************************************"
fi

if $SPARK ; then
	hdfs dfs -rm -r $SPARK_OUT_CLUS
	hdfs dfs -rm -r $SPARK_IN_CLUS
	rm -f $SPARK_IN_LOC
	echo "******************************************************************************************************************************************"
fi

if $SPARK2 ; then
	hdfs dfs -rm -r $SPARK_OUT_CLUS
	hdfs dfs -rm -r $SPARK_IN_CLUS
	rm -f $SPARK_IN_LOC
	echo "******************************************************************************************************************************************"
fi

if $PIG ; then
	hdfs dfs -rm -r $PIG_PATH_OUT
	hdfs dfs -rm -r $SPARK_OUT_CLUS
	echo "******************************************************************************************************************************************"
fi

if $KAFKA ; then
	kafka-topics --zookeeper ${ZOOKEEPER} --delete --topic ${TOPIC_NAME}
	rm -r -f $KAFKA_INP_LOC
	rm -r -f $KAFKA_OUP_LOC
	echo "******************************************************************************************************************************************"
fi

if $SOLR ; then
	bash bin/solr_rm.sh
	echo "******************************************************************************************************************************************"
fi


if $IMPALA ; then
	impala-shell -i  $IMPALADAEMON -q "drop table ${IMPALA_TABLE_NAME};"
	rm  -f impala_select_test.txt
	rm  -f impala_check.txt
	echo "******************************************************************************************************************************************"
fi

if $KUDU ; then
	impala-shell -i $IMPALADAEMON -q 'DROP TABLE kudu_test;'
	echo "******************************************************************************************************************************************"
fi

if $KUDU_SPARK ; then
	echo "******************************************************************************************************************************************"
fi

if $NIFI ; then
	rm -f $NIFI_TEMPLATE_TEMP_LOCATION
	hdfs dfs -rm -r -f -skipTrash $TEMP_HDFS_DIRECTORY
	echo "******************************************************************************************************************************************"
fi


if $SECURITY ; then
	kdestroy
fi

hdfs dfs -rm -r -f /tmp/SmokeTest
