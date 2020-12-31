#!/bin/bash

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
fi

if $HDFS; then
	echo "Smoke test for HDFS"
	bin/hdfsTest.sh
fi

if $MAPREDUCE; then
	echo "Smoke test for MAPREDUCE"
	bin/mrTest.sh
fi

if $HIVE; then
	echo "Smoke test for HIVE"
	bin/hiveTest.sh
fi

if $HBASE; then
	echo "Smoke test for HBASE"
	bin/hbaseTest.sh
fi

if $IMPALA; then
	echo "Smoke test for IMPALA"
	bin/impalaTest.sh
fi

if $SPARK; then
	echo "Smoke test for SPARK"
	bin/sparkTest.sh
fi

if $SPARK2; then
	echo "Smoke test for SPARK"
	bin/spark2Test.sh
fi

if $PYSPARK; then
	echo "Smoke test for PYSPARK"
	bin/pysparkTest.sh
fi

if $PYSPARK2; then
	echo "Smoke test for PYSPARK2"
	bin/pyspark2Test.sh
fi

if $PIG; then
	echo "Smoke test for PIG"
	bin/pigTest.sh
fi

if $SOLR; then
	echo "Smoke test for SOLR"
	bin/solrTest.sh
fi

if $KAFKA; then
	echo "Smoke test for KAFKA"
	bin/kafkaTest.sh
fi

if $KUDU; then
	echo "Smoke test for KUDU"
	bin/kuduTest.sh
fi

if $KUDU_SPARK; then
	echo "Smoke test for KUDU_SPARK"
	bin/kuduSpark2Test.sh
fi

if $NIFI; then
	echo "Smoke test for NIFI"
	bin/nifiTest.sh
fi

echo "Get rid of all the test bits."
bin/CleanUp.sh
