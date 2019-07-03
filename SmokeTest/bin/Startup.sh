#!/bin/bash

echo "">../log/SummaryReport.txt

if $SECURITY ; then
	kinit -kt $KRB_KEYTAB $KRB_PRINCIPAL
fi

if $HDFS ; then
	echo "Smoke test for HDFS"
	bash hdfsTest.sh

fi

if $MAPREDUCE ; then
	echo "Smoke test for MAPREDUCE"
	bash mrTest.sh

fi

if $HIVE ; then
	echo "Smoke test for HIVE"
	bash hiveTest.sh

fi

if $HBASE ; then
	echo "Smoke test for HBASE"
	bash hbaseTest.sh

fi

if $PIG ; then
	echo "Smoke test for PIG"
	bash pigTest.sh
fi

if $IMPALA ; then
	echo "Smoke test for IMPALA"
	bash impalaTest.sh
fi

if $SPARK2 ; then
	echo "Smoke test for SPARK"
	bash spark2Test.sh
fi

if $SPARK ; then
	echo "Smoke test for SPARK"
	bash sparkTest.sh

fi

if $SOLR ; then
	echo "Smoke test for SOLR"
	bash solrTest.sh

fi

if $KAFKA ; then
	echo "Smoke test for KAFKA"
	bash kafkaTest.sh

fi

if $KUDU ; then
	echo "Smoke test for KUDU"
	bash kuduTest.sh

fi


if $KUDU_SPARK ; then
	echo "Smoke test for KUDU_SPARK"
	bash kuduSparkTest.sh

fi

if $NIFI ; then
	echo "Smoke test for NIFI"
	bash nifiTest.sh

fi


echo "Get rid of all the test bits."
bash CleanItUp.sh
