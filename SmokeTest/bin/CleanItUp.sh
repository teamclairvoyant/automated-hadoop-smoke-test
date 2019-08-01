#!/bin/bash
source ./conf/SmokeConfig.config

if $HDFS ; then
	hdfs dfs -rm -r "$HDFS_PATH"
	rm -f -r "$TEMP_PATH"
	echo "******************************************************************************************************************************************"
fi

if $MAPREDUCE ; then
	hdfs dfs -rm -r "$MAP_REDUCE_IN"/WordCountFile.txt
	hdfs dfs -rm -r "$MAP_REDUCE_OUT"
	echo "******************************************************************************************************************************************"
fi

if $HIVE ; then
	bash bin/hiveDrop.sh
	rm  -f hive_select_test.txt
	rm  -f hive_check.txt
	echo "******************************************************************************************************************************************"
fi

if $HBASE ; then
	hbase shell -n  ./lib/hbase_rm.txt
	echo "******************************************************************************************************************************************"
fi

if $SPARK ; then
	hdfs dfs -rm -r "$SPARK_OUT_CLUS"
	hdfs dfs -rm -r "$SPARK_IN_CLUS"
	rm -f spark_test.txt
	echo "******************************************************************************************************************************************"
fi

if $SPARK2 ; then
	hdfs dfs -rm -r "$SPARK_OUT_CLUS"
	hdfs dfs -rm -r "$SPARK_IN_CLUS"
	rm -f spark_test.txt
	echo "******************************************************************************************************************************************"
fi

if $PYSPARK ; then
	hdfs dfs -rm -r "$PYSPARK_OUT_CLUS"
	hdfs dfs -rm -r "$PYSPARK_IN_CLUS"
	rm -f pyspark_test.txt
	echo "******************************************************************************************************************************************"
fi

if $PYSPARK2 ; then
	hdfs dfs -rm -r "$PYSPARK_OUT_CLUS"
	hdfs dfs -rm -r "$PYSPARK_IN_CLUS"
	rm -f pyspark2_test.txt
	echo "******************************************************************************************************************************************"
fi

if $PIG ; then
	hdfs dfs -rm -r "$PIG_PATH_IN"
	hdfs dfs -rm -r "$PIG_PATH_OUT"
	echo "******************************************************************************************************************************************"
fi

if $KAFKA ; then
	kafka-topics --zookeeper "$ZOOKEEPER" --delete --topic "$TOPIC_NAME"
	rm -r -f "$KAFKA_OUP_LOC"
	echo "******************************************************************************************************************************************"
fi

if $SOLR ; then
	bash bin/solr_rm.sh
	echo "******************************************************************************************************************************************"
fi


if $IMPALA ; then
	impala-shell -i  "$IMPALA_DAEMON" -q "drop table $IMPALA_TABLE_NAME;"
	rm  -f impala_select_test.txt
	rm  -f impala_check.txt
	echo "******************************************************************************************************************************************"
fi

if $KUDU ; then
	impala-shell -i "$KUDU_IMPALA_DAEMON" -q "DROP TABLE kudu_test;"
	echo "******************************************************************************************************************************************"
fi

if $KUDU_SPARK ; then
	echo "******************************************************************************************************************************************"
fi

if $NIFI ; then
	hdfs dfs -rm -r -f -skipTrash "$TEMP_HDFS_DIRECTORY"
	rm -f SmokeTest.xml
	echo "******************************************************************************************************************************************"
fi

hdfs dfs -rm -r -f /tmp/SmokeTest
