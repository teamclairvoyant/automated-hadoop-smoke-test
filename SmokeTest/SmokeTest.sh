#!/bin/bash

parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

cd "$parent_path"

source $parent_path/conf/SmokeConfig.config

timestamp=`date '+%Y%m%d%H%M%S'`

mkdir -p $LOG_PATH
touch $LOG_PATH/${timestamp}logs.log

echo "">./log/SummaryReport.txt

#exec >>(tee -a $LOG_PATH/${timestamp}logs.log)
exec > $LOG_PATH/${timestamp}logs.log 2>&1

if $SECURITY ; then
	kinit -kt $KRB_KEYTAB $KRB_PRINCIPAL
fi

echo "|-- $CLUSTER"

if $HDFS ; then
	echo "Smoke test for HDFS in $CLUSTER"
	bash ./bin/hdfsTest.sh

fi

if $MAPREDUCE ; then
	echo "Smoke test for MAPREDUCE in $CLUSTER"
	bash ./bin/yarnTest.sh

fi

if $HIVE ; then
	echo "Smoke test for HIVE in $CLUSTER"
	bash ./bin/hiveTest.sh

fi

if $HBASE ; then
	echo "Smoke test for HBASE in $CLUSTER"
	bash ./bin/hbaseTest.sh

fi

if $PIG ; then
	echo "Smoke test for PIG in $CLUSTER"
	bash ./bin/pigTest.sh
fi

if $IMPALA ; then
	echo "Smoke test for IMPALA in $CLUSTER"
	bash ./bin/impalaTest.sh
fi

if $SPARK2 ; then
	echo "Smoke test for SPARK in $CLUSTER"
	bash ./bin/spark2Test.sh
fi

if $SPARK ; then
	echo "Smoke test for SPARK in $CLUSTER"
	bash ./bin/sparkTest.sh

fi

if $SOLR ; then
	echo "Smoke test for SOLR in $CLUSTER"
	bash ./bin/solrTest.sh

fi

if $KAFKA ; then
	echo "Smoke test for KAFKA in $CLUSTER"
	bash ./bin/kafkaTest.sh

fi

if $KUDU ; then
	echo "Smoke test for KUDU in $CLUSTER"
	bash ./bin/kuduTest.sh

fi


if $KUDU_SPARK ; then
	echo "Smoke test for KUDU_SPARK in $CLUSTER"
	bash ./bin/kuduSparkTest.sh

fi

if $NIFI ; then
	echo "Smoke test for NIFI in $CLUSTER"
	bash ./bin/nifiTest.sh

fi


echo "Get rid of all the test bits."
bash ./bin/CleanItUp.sh


cat ./log/SummaryReport.txt
mv ./log/SummaryReport.txt ./log/${timestamp}SummaryReport.txt
