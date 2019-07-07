#!/bin/bash

source ./conf/SmokeConfig.config

echo "">./log/SummaryReport.txt

if $SECURITY ; then
	kinit -kt $KRB_KEYTAB $KRB_PRINCIPAL
fi

if $HDFS ; then
	echo "Smoke test for HDFS"
	bash bin/hdfsTest.sh
fi

if $MAPREDUCE ; then
	echo "Smoke test for MAPREDUCE"
	bash bin/mrTest.sh
fi

if $HIVE ; then
	echo "Smoke test for HIVE"
	bash bin/hiveTest.sh

fi

if $HBASE ; then
	echo "Smoke test for HBASE"
	bash bin/hbaseTest.sh
fi

if $PIG ; then
	echo "Smoke test for PIG"
	bash bin/pigTest.sh
fi

if $IMPALA ; then
	echo "Smoke test for IMPALA"
	bash bin/impalaTest.sh
fi

if $SPARK2 ; then
	echo "Smoke test for SPARK"
	bash bin/spark2Test.sh
fi

if $SPARK ; then
	echo "Smoke test for SPARK"
	bash bin/sparkTest.sh
fi

if $SOLR ; then
	echo "Smoke test for SOLR"
	bash bin/solrTest.sh
fi

if $KAFKA ; then
	echo "Smoke test for KAFKA"
	bash bin/kafkaTest.sh
fi

if $KUDU ; then
	echo "Smoke test for KUDU"
	bash bin/kuduTest.sh
fi


if $KUDU_SPARK ; then
	echo "Smoke test for KUDU_SPARK"
	bash bin/kuduSparkTest.sh
fi

if $NIFI ; then
	echo "Smoke test for NIFI"
	bash bin/nifiTest.sh
fi

echo "Get rid of all the test bits."
bash bin/CleanItUp.sh
