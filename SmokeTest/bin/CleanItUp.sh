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

	hdfs dfs -rm -r $MAP_REDUCE_OUT
	echo "******************************************************************************************************************************************"
fi

if $HIVE ; then

	bash ./bin/hivedrop.sh
	rm -r -f $HIVE_OUT
	echo "******************************************************************************************************************************************"
fi

if $HBASE ; then

	hbase shell -n  ./lib/hbase_rm.txt
	echo "******************************************************************************************************************************************"
fi

if $SPARK2 ; then

	hdfs dfs -rm -r $SPARK_OUT_CLUS
	hdfs dfs -rm -r $SPARK_IN_CLUS
	rm -f $SPARK_IN_LOC
	echo "******************************************************************************************************************************************"
fi

if $SPARK ; then

	hdfs dfs -rm -r $SPARK_OUT_CLUS
	hdfs dfs -rm -r $SPARK_IN_CLUS
	rm -f $SPARK_IN_LOC
	echo "******************************************************************************************************************************************"
fi

if $PIG ; then

	hdfs dfs -rm -R $PIG_PATH_OUT
	hdfs dfs -rm -R $SPARK_OUT_CLUS
	echo "******************************************************************************************************************************************"
fi

if $KAFKA ; then

	$KAFKA_HOME/kafka-topics --zookeeper ${ZOOKEEPER} --delete --topic ${TOPIC_NAME}
	rm -r -f $KAFKA_INP_LOC
	rm -r -f $KAFKA_OUP_LOC
	echo "******************************************************************************************************************************************"
fi

if $SOLR ; then

	bash ./bin/solr_rm.sh
	echo "******************************************************************************************************************************************"

fi

if $KUDU ; then

	impala-shell -i $IMPALADAEMON -q 'DROP TABLE kudu_test;'
	echo "******************************************************************************************************************************************"

fi
if $IMPALA ; then

	impala-shell -i  $IMPALADAEMON -q "drop table test_impala;"
	rm -r -f $IMPALA_INP
	rm -r -f $IMPALA_VAL
	echo "******************************************************************************************************************************************"

fi

if $SECURITY ; then
	kdestroy
fi

rm -rf /tmp/SmokeTest
