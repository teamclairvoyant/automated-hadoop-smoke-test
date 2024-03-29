#!/bin/bash
# shellcheck disable=SC1091
echo "Get rid of all the test bits."
source ./conf/SmokeConfig.config

if $ZOOKEEPER ; then
	bash bin/zkCleanUp.sh
	echo "*********************************************************************************"
fi

if $HDFS ; then
	hdfs dfs -rm -r "$HDFS_PATH"
	rm -f -r "$TEMP_PATH"
	echo "*********************************************************************************"
fi

if $MAPREDUCE ; then
	hdfs dfs -rm -r "$MAP_REDUCE_IN"/WordCountFile.txt
	hdfs dfs -rm -r "$MAP_REDUCE_OUT"
	echo "*********************************************************************************"
fi

if $HIVE ; then
	bash bin/hiveCleanUp.sh
	echo "*********************************************************************************"
fi

if $HBASE ; then
	bash bin/hbaseCleanUp.sh
	echo "*********************************************************************************"
fi

if $SPARK ; then
	hdfs dfs -rm -r "$SPARK_OUT_CLUS"
	hdfs dfs -rm -r "$SPARK_IN_CLUS"
	rm -f spark_test.txt
	echo "*********************************************************************************"
fi

if $SPARK2 ; then
	hdfs dfs -rm -r "$SPARK_OUT_CLUS"
	hdfs dfs -rm -r "$SPARK_IN_CLUS"
	rm -f spark2_test.txt
	echo "*********************************************************************************"
fi

if $PYSPARK ; then
	hdfs dfs -rm -r "$PYSPARK_OUT_CLUS"
	hdfs dfs -rm -r "$PYSPARK_IN_CLUS"
	rm -f pyspark_test.txt
	echo "*********************************************************************************"
fi

if $PYSPARK2 ; then
	hdfs dfs -rm -r "$PYSPARK_OUT_CLUS"
	hdfs dfs -rm -r "$PYSPARK_IN_CLUS"
	rm -f pyspark2_test.txt
	echo "*********************************************************************************"
fi

if $PIG ; then
	hdfs dfs -rm -r "$PIG_PATH_IN"
	hdfs dfs -rm -r "$PIG_PATH_OUT"
	echo "*********************************************************************************"
fi

if $KAFKA ; then
	bash bin/kafkaCleanUp.sh
	echo "*********************************************************************************"
fi

if $SOLR ; then
	bash bin/solrCleanUp.sh
	echo "*********************************************************************************"
fi


if $IMPALA ; then
	bash bin/impalaCleanUp.sh
	echo "*********************************************************************************"
fi

if $KUDU ; then
	bash bin/kuduCleanUp.sh
	echo "*********************************************************************************"
fi

if $KUDU_SPARK ; then
	echo "*********************************************************************************"
fi

if $NIFI ; then
	bash bin/nifiCleanUp.sh
	echo "*********************************************************************************"
fi

if $OZONE ; then
	bash bin/ozoneCleanUp.sh
	echo "*********************************************************************************"
fi

