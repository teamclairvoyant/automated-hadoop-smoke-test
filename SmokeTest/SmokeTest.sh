#!/bin/bash
source ./conf/SmokeConfig.config

echo $LOG_PATH
exec &> >(tee -a $LOG_PATH)



if [ $CLUSTER == "hdp" ]; then

  	if $SECURITY ; then

 		if $HDFS ; then	

  			 
  			echo "Smoke test for HDFS IN SEC HDP"
			kinit -kt $KRB_KEYTAB_HDFS $KRB_PRINCIPAL_HDFS
 			bash ./lib/HdfsTest.sh
  			echo "Smoke test for HDFS completed"
 		fi

 		if $MAPREDUCE ; then

 			 
 			echo "Smoke test for MAPREDUCE IN SEC HDP"
			kinit -kt $KRB_KEYTAB_YARN $KRB_PRINCIPAL_YARN
    		bash ./lib/MapReduce.sh
			echo "Smoke test for MAPREDUCE completed"
 		fi

 		if $HIVE ; then
			 
			echo "Smoke test for HIVE IN SEC HDP"
			echo "hive kerberized" 
			kinit -kt $KRB_KEYTAB_HIVE $KRB_PRINCIPAL_HIVE
			bash ./lib/HiveTest.sh 
			echo "Smoke test for HIVE completed"
 		fi

 		if $HBASE ; then
 			 
			echo "Smoke test for HBASE IN SEC HDP"
			kinit -kt $KRB_KEYTAB_HBASE $KRB_PRINCIPAL_HBASE
			hbase shell -n ./lib/hbase.txt 
			echo "Smoke test for HBASE completed"
 		fi

 		if $KAFKA ; then
 			 
			echo "Smoke test for KAFKA IN SEC HDP" 
			kinit -kt $KRB_KEYTAB_KAFKA $KRB_PRINCIPAL_KAFKA
			bash ./lib/KafkaTest.sh

			cd $SCRIPT_HOME
 		fi

 		if $PIG ; then
 			
			echo "Smoke test for PIG IN SEC HDP" 
			kinit -kt $KRB_KEYTAB_HIVE $KRB_PRINCIPAL_HIVE
			#pig
			bash ./lib/pigExample.sh

 		fi
 
 		if $SPARK2 ; then
 			 
 			echo "Smoke test for SPARK IN SEC HDP"
 			kinit -kt $KRB_KEYTAB_SPARK $KRB_PRINCIPAL_SPARK
			bash ./lib/SparkScript.sh

 		fi

 		if $SPARK ; then

         	echo "Smoke test for SPARK IN SEC HDP"
         	kinit -kt $KRB_KEYTAB_SPARK $KRB_PRINCIPAL_SPARK
        	bash ./lib/SparkScript.sh

         fi


		 
		echo "Get rid of all the test bits."
		
		bash ./lib/CleanItUp.sh

   
   	else


 		if $HDFS ; then
 			echo "Smoke test for HDFS IN NON SEC HDP" 
			bash ./lib/hdfsTest.sh 
			 
 		fi
 		if $HIVE ; then
 			echo "Smoke test for HIVE IN NON SEC HDP" 
			su -c "bash ./lib/hiveTest.sh" hive 
 			 
 		fi
 		if $HBASE ; then
			echo "Smoke test for HBASE IN NON SEC HDP" 
			su -c "hbase shell ./lib/hbase.txt" hbase 
			 
 		fi
 		if $MAPREDUCE ; then
			echo "Smoke Test for Yarn IN NON SEC HDP" 
			bash ./lib/Mapreduce.sh
			 
 		fi
 		if $PIG ; then
			echo "Smoke test for PIG IN NON SEC HDP" 
			bash ./lib/pigExample.sh 
			 
 		fi
 		if $KAFKA2 ; then
			echo "Smoke test for KAFKA IN NON SEC HDP" 
			bash ./lib/kafkaTest.sh 
			 
 		fi
 		if $SPARK2 ; then
			echo "Smoke test for SPARK IN NON SEC HDP" 
			bash ./lib/SparkScript.sh
			
 		fi
        if $SPARK ; then

         	echo "Smoke test for SPARK IN SEC HDP"
        	bash ./lib/SparkScript.sh
        fi

		#echo "Smoke test for solar IN NON SEC HDP" 

		#su -c "bash solrSmokeTest.sh" spark 

		echo "Get rid of all the test bits."
		bash ./lib/CleanItUp.sh

 	fi
else
  	if $SECURITY ; then

		if $HDFS ; then
			echo "Smoke test for HDFS SEC CDH" 
			kinit -kt $KRB_KEYTAB_HDFS $KRB_PRINCIPAL_HDFS
			bash ./lib/hdfsTest.sh 
		fi
 		if $HIVE ; then
			
			echo "Smoke test for HIVE IN SEC CDH"
			kinit -kt $KRB_KEYTAB_HIVE $KRB_PRINCIPAL_HIVE
			bash ./lib/hiveTest.sh
		fi
 		if $HBASE ; then
			 

			echo "Smoke test for HBASE IN SEC CDH"
			kinit -kt $KRB_KEYTAB_HBASE $KRB_PRINCIPAL_HBASE
			bash ./lib/hbaseTest.sh
		fi
 		if $MAPREDUCE ; then
			
			echo "Smoke Test for Yarn IN SEC CDH" 
			kinit -kt $KRB_KEYTAB_YARN $KRB_PRINCIPAL_YARN
			bash ./lib/yarnTest.sh
		fi
 		if $PIG ; then
			
			echo "Smoke test for Pig IN SEC CDH"
			kinit -kt $KRB_KEYTAB_HDFS $KRB_PRINCIPAL_HDFS
			bash ./lib/pigTest.sh
		fi
		if $IMAPALA ; then
			
			echo "Smoke test for IMAPALA IN SEC CDH"
			kinit -kt $KRB_KEYTAB_IMAPALA $KRB_PRINCIPAL_IMAPALA
			bash ./lib/impalaTest.sh
		fi
 		if $KAFKA2 ; then
			
	
			echo "Smoke test for KAFKA IN SEC CDH"
			#bash ./lib/kafkaTest.sh 
		fi
 		if $SPARK2 ; then
			
			echo "Smoke test for SPARK IN SEC CDH"
			kinit -kt $KRB_KEYTAB_SPARK $KRB_PRINCIPAL_SPARK
			bash ./lib/sparkTest.sh
		fi
				
			#echo "Smoke test for solar IN SEC CDH" 
			#su -c "bash solrSmokeTest.sh" spark 	
			
		echo "Get rid of all the test bits."
		bash ./lib/CleanItUp.sh

  	else
  		if $HDFS ; then
			echo "Smoke test for HDFS NON SEC CDH" 
			bash ./lib/hdfsTest.sh 
		fi
		if $HIVE ; then
			
			echo "Smoke test for HIVE NON SEC CDH"
			bash ./lib/hiveTest.sh
    	fi
 		if $HBASE ; then
			 
			echo "Smoke test for HBASE NON SEC CDH"
			bash ./lib/hbaseTest.sh
		fi
 		if $MAPREDUCE ; then
			
			echo "Smoke Test for Yarn NON SEC CDH" 
			bash ./lib/yarnTest.sh
		fi
 		if $PIG ; then
			
			echo "Smoke test for Pig NON SEC CDH"
			bash ./lib/pigTest.sh
		fi
		if $IMAPALA ; then
			
			echo "Smoke test for IMAPALA NON SEC CDH"
			bash ./lib/impalaTest.sh
		fi
 		#if $KAFKA2 ; then
 			
			#echo "Smoke test for KAFKA NON SEC CDH"
			#bash ./lib/kafkaTest.sh 
		#fi
 		if $SPARK2 ; then
			
	
			echo "Smoke test for SPARK NON SEC CDH"
			bash ./lib/sparkTest.sh
		fi
		
			#echo "Smoke test for solar NON SEC CDH" 
			#su -c "bash solrSmokeTest.sh" spark 

			
		echo "Get rid of all the test bits."
		bash ./lib/CleanItUp.sh
 	fi
fi


