#!/bin/bash
source ./conf/SmokeConfig.config

if $SECURITY ; then

	if $HDFS ; then

		kinit -kt $KRB_KEYTAB_HDFS $KRB_PRINCIPAL_HDFS
		hdfs dfs -rm $HDFS_PATH
		rm -f $TEMP_PATH
		echo "******************************************************************************************************************************************"
	fi

	if $MAPREDUCE ; then

		kinit -kt $KRB_KEYTAB_HDFS $KRB_PRINCIPAL_HDFS
		hdfs dfs -rm -r $MAP_REDUCE_OUT
		echo "******************************************************************************************************************************************"
	fi

	if $HIVE ; then

		kinit -kt $KRB_KEYTAB_HIVE $KRB_PRINCIPAL_HIVE
		bash hivedrop.sh
		echo "******************************************************************************************************************************************"
	fi

	if $HBASE ; then

		kinit -kt $KRB_KEYTAB_HBASE $KRB_PRINCIPAL_HBASE
		hbase shell -n  $SCRIPT_HOME/lib/hbase_rm.txt
		#rm -f /tmp/hbase.$$ /tmp/hbase-rm.$$
		echo "******************************************************************************************************************************************"
	fi

	if $SPARK2 ; then

		kinit -kt $KRB_KEYTAB_HDFS $KRB_PRINCIPAL_HDFS
		hdfs dfs -rm -R $SPARK_OUT_CLUS
		hdfs dfs -rm -R $SPARK_IN_CLUS
		echo "******************************************************************************************************************************************"
	fi

	if $SPARK ; then

		kinit -kt $KRB_KEYTAB_HDFS $KRB_PRINCIPAL_HDFS
		hdfs dfs -rm -R $SPARK_OUT_CLUS
		hdfs dfs -rm -R $SPARK_IN_CLUS
		echo "******************************************************************************************************************************************"
	fi

	if $PIG ; then

		kinit -kt $KRB_KEYTAB_HDFS $KRB_PRINCIPAL_HDFS
		hdfs dfs -rm -R $PIG_PATH_OUT
		hdfs dfs -rm -R $SPARK_OUT_CLUS
		echo "******************************************************************************************************************************************"
	fi

	if $KAFKA ; then

		kinit -kt $KRB_KEYTAB_KAFKA $KRB_PRINCIPAL_KAFKA
		$KAFKA_HOME/kafka-topics.sh --zookeeper ${ZOOKEEPER} --delete --topic test
	fi

	kdestroy

else

	if $HDFS ; then

		echo " removing bits - hdfs"
		su -c "hdfs dfs -rm -r  $HDFS_PATH" hdfs
		rm -f $TEMP_PATH
		echo "******************************************************************************************************************************************"
	fi

	if $HIVE ; then

		echo "removing bits - hive"
		bash ./lib/hivedrop.sh
		rm -f $HIVE_DATA_PATH
		echo "******************************************************************************************************************************************"
	fi

	if $HBASE ; then

		echo "removing bits - hbase"
		hbase shell -n  ./lib/hbase_rm.txt
		#rm -f /tmp/hbase.$$ /tmp/hbase-rm.$$
		echo "******************************************************************************************************************************************"
	fi

	if $SPARK2 ; then

		echo "removing bits - spark"
		hdfs dfs -rm -R $SPARK_OUT_CLUS
		echo "******************************************************************************************************************************************"
	fi

	if $SPARK ; then

		echo "removing bits - spark"
		hdfs dfs -rm -R $SPARK_OUT_CLUS
		echo "******************************************************************************************************************************************"
	fi

	if $PIG ; then

		echo "removing bits - pig"
		su -c "hdfs dfs -rm -R $PIG_PATH_OUT" hdfs
		echo "******************************************************************************************************************************************"
	fi

	if $KAFKA ; then

		echo "removing bits - kafka"
		$KAFKA_HOME/kafka-topics.sh --zookeeper ${ZOOKEEPER} --delete --topic test
	fi
fi