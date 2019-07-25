#!/bin/bash

source ./conf/SmokeConfig.config

echo "" >./log/SummaryReport.txt

if $KERBEROS_SECURITY; then
	kinit -R
	kinit_succeeded=$?
	if [[ $kinit_succeeded != 0 ]]; then
		echo "Could not renew the ticket granting token (TGT). Please make sure you have obtained a TGT from kerberos. Exiting!"
		exit 1
	fi
	else
		echo "Successfully renewed ticket granting token (TGT)."
fi

if $HDFS; then
	echo "Smoke test for HDFS"
	bash bin/hdfsTest.sh
fi

if $MAPREDUCE; then
	echo "Smoke test for MAPREDUCE"
	bash bin/mrTest.sh
fi

if $HIVE; then
	echo "Smoke test for HIVE"
	bash bin/hiveTest.sh

fi

if $HBASE; then
	echo "Smoke test for HBASE"
	bash bin/hbaseTest.sh
fi

if $IMPALA; then
	echo "Smoke test for IMPALA"
	bash bin/impalaTest.sh
fi

if $SPARK; then
	echo "Smoke test for SPARK"
	bash bin/sparkTest.sh
fi

if $SPARK2; then
	echo "Smoke test for SPARK"
	bash bin/spark2Test.sh
fi

if $PYSPARK; then
	echo "Smoke test for PYSPARK"
	bash bin/pysparkTest.sh
fi

if $PYSPARK2; then
	echo "Smoke test for PYSPARK2"
	bash bin/pyspark2Test.sh
fi

if $PIG; then
	echo "Smoke test for PIG"
	bash bin/pigTest.sh
fi

if $SOLR; then
	echo "Smoke test for SOLR"
	bash bin/solrTest.sh
fi

if $KAFKA; then
	echo "Smoke test for KAFKA"
	bash bin/kafkaTest.sh
fi

if $KUDU; then
	echo "Smoke test for KUDU"
	bash bin/kuduTest.sh
fi

if $KUDU_SPARK; then
	echo "Smoke test for KUDU_SPARK"
	bash bin/kuduSpark2Test.sh
fi

if $NIFI; then
	echo "Smoke test for NIFI"
	bash bin/nifiTest.sh
fi

echo "Get rid of all the test bits."
bash bin/CleanItUp.sh
