#!/bin/bash
# shellcheck disable=SC1091
source ./conf/SmokeConfig.config

echo "" >./log/SummaryReport.txt

echo "*********************************"
echo "Hadoop Automated Smoke Test Suite"
echo "*********************************"

if $KERBEROS_SECURITY; then
	kinit -R
	kinit_succeeded=$?
	if [[ $kinit_succeeded != 0 ]]; then
		echo "Could not renew the ticket granting token (TGT). Please make sure you have obtained a TGT from kerberos. Exiting!"
		exit 1
	else
		echo "Successfully renewed ticket granting token (TGT)."
	fi
	echo "*********************************************************************************"
fi

if $ZOOKEEPER; then
	echo "Smoke test for ZooKeeper"
	bash bin/zkTest.sh
	echo "*********************************************************************************"
fi

if $HDFS; then
	echo "Smoke test for HDFS"
	bash bin/hdfsTest.sh
	echo "*********************************************************************************"
fi

if $MAPREDUCE; then
	echo "Smoke test for MAPREDUCE"
	bash bin/mrTest.sh
	echo "*********************************************************************************"
fi

if $HIVE; then
	echo "Smoke test for HIVE"
	bash bin/hiveTest.sh
	echo "*********************************************************************************"
fi

if $HBASE; then
	echo "Smoke test for HBASE"
	bash bin/hbaseTest.sh
	echo "*********************************************************************************"
fi

if $IMPALA; then
	echo "Smoke test for IMPALA"
	bash bin/impalaTest.sh
	echo "*********************************************************************************"
fi

if $SPARK; then
	echo "Smoke test for SPARK"
	bash bin/sparkTest.sh
	echo "*********************************************************************************"
fi

if $SPARK2; then
	echo "Smoke test for SPARK"
	bash bin/spark2Test.sh
	echo "*********************************************************************************"
fi

if $PYSPARK; then
	echo "Smoke test for PYSPARK"
	bash bin/pysparkTest.sh
	echo "*********************************************************************************"
fi

if $PYSPARK2; then
	echo "Smoke test for PYSPARK2"
	bash bin/pyspark2Test.sh
	echo "*********************************************************************************"
fi

if $PIG; then
	echo "Smoke test for PIG"
	bash bin/pigTest.sh
	echo "*********************************************************************************"
fi

if $SOLR; then
	echo "Smoke test for SOLR"
	bash bin/solrTest.sh
	echo "*********************************************************************************"
fi

if $KAFKA; then
	echo "Smoke test for KAFKA"
	bash bin/kafkaTest.sh
	echo "*********************************************************************************"
fi

if $KUDU; then
	echo "Smoke test for KUDU"
	bash bin/kuduTest.sh
	echo "*********************************************************************************"
fi

if $KUDU_SPARK; then
	echo "Smoke test for KUDU_SPARK"
	bash bin/kuduSpark2Test.sh
	echo "*********************************************************************************"
fi

if $NIFI; then
	echo "Smoke test for NIFI"
	bash bin/nifiTest.sh
	echo "*********************************************************************************"
fi

if $OZONE; then
	echo "Smoke test for OZONE"
	bash bin/ozoneTest.sh
	echo "*********************************************************************************"
fi

bash bin/CleanUp.sh
