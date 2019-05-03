#!/bin/bash
source ./conf/SmokeConfig.config

timestamp=`date '+%Y%m%d%H%M%S'`

touch $LOG_PATH/${timestamp}logs.log

echo "">./log/SummaryReport.txt


exec &> >(tee -a $LOG_PATH/${timestamp}logs.log)

if $SECURITY ; then

    kinit -kt $KRB_KEYTAB $KRB_PRINCIPAL

fi

	echo "|-- $CLUSTER"

 		if $HDFS ; then


  			echo "Smoke test for HDFS IN $CLUSTER"
 			bash ./bin/hdfsTest.sh
  			echo "Smoke test for HDFS completed"
 		fi

 		if $MAPREDUCE ; then


 			echo "Smoke test for MAPREDUCE IN $CLUSTER"
    			bash ./bin/yarnTest.sh
			echo "Smoke test for MAPREDUCE completed"
 		fi

 		if $HIVE ; then

			echo "Smoke test for HIVE IN $CLUSTER"
			bash ./bin/hiveTest.sh
			echo "Smoke test for HIVE completed"
 		fi

 		if $HBASE ; then

			echo "Smoke test for HBASE IN $CLUSTER"
			bash ./bin/hbaseTest.sh
			echo "Smoke test for HBASE completed"
 		fi

 		if $KAFKA ; then

			echo "Smoke test for KAFKA IN $CLUSTER"
			bash ./bin/kafkaTest.sh
			cd $SCRIPT_HOME
			echo "Smoke test for HBASE completed"

 		fi

 		if $PIG ; then

			echo "Smoke test for PIG IN $CLUSTER"
			#pig
			bash ./bin/pigTest.sh
			echo "Smoke test for HBASE completed"


 		fi

		if $IMPALA ; then

			echo "Smoke test for IMPALA IN $CLUSTER"
			bash ./bin/impalaTest.sh
			echo "Smoke test for IMPALA completed"

		fi


 		if $SPARK2 ; then

 			echo "Smoke test for SPARK IN $CLUSTER"
			bash ./bin/spark2Test.sh

 		fi

 		if $SPARK ; then

         		echo "Smoke test for SPARK IN $CLUSTER"
        		bash ./bin/sparkTest.sh

                fi

		if $SOLR ; then

         		echo "Smoke test for SOLR IN $CLUSTER"
        		bash ./bin/solrTest.sh

                fi


echo "Get rid of all the test bits."
bash ./bin/CleanItUp.sh


cat ./log/SummaryReport.txt
mv ./log/SummaryReport.txt ./log/${timestamp}SummaryReport.txt
