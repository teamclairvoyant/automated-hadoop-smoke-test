#!/bin/bash
source ./conf/SmokeConfig.config

HIVESERVER2=$HIVESERVER2
REALM=${REALM}
BKOPTS=$BKOPTS
BTOPTS=$BTOPTS

if $SECURITY_HIVE ; then
	echo "Hive is secured"
	kinit -kt $KRB_KEYTAB_HIVE $KRB_PRINCIPAL_HIVE

	beeline -n `whoami` -u "jdbc:hive2://${HIVESERVER2}:10000/${BKOPTS}${BTOPTS}" -e "CREATE TABLE test(id INT, name STRING) ROW FORMAT DELIMITED FIELDSTERMINATED BY ' ' STORED AS TEXTFILE;"
	rc=$?; if [[ $rc != 0 ]]; then echo "Create query failed! exiting for creating hive table for impala"; echo " - Hive for Impala	- Failed [Create query failed]" >> ./log/SummaryReport.txt; exit $rc; fi

	echo "1 justin" > $HIVE_DATA_PATH
	rc=$?; if [[ $rc != 0 ]]; then echo "Input data generation failed for impala! exiting"; echo " - Hive for Impala		- Failed [Input data generation failed]" >> ./log/SummaryReport.txt; exit $rc; fi
	echo "2 michael" >> $HIVE_DATA_PATH
	rc=$?; if [[ $rc != 0 ]]; then echo "Input data generation failed! exiting for impala"; echo " - Hive for Impala		- Failed [Input data generation failed]" >> ./log/SummaryReport.txt; exit $rc; fi

	hdfs dfs -put $HIVE_DATA_PATH  $HIVE_TABLE_LOC
	rc=$?; if [[ $rc != 0 ]]; then echo "Input data transfer failed for impala! exiting"; echo " - Hive	for Impala	- Failed [Input data transfer failed]" >> ./log/SummaryReport.txt; exit $rc; fi

 	hdfs dfs -mkdir -p $HIVE_OUT
 
	beeline -n `whoami` -u "jdbc:hive2://${HIVESERVER2}:10000/${BKOPTS}${BTOPTS}" -e"SELECT * FROM test WHERE id=1;" > $HIVE_OUT

	rc=$?; if [[ $rc != 0 ]]; then echo "Select query failed! exiting from hive table for Impala"; echo " - Hive for Impala		- Failed [Select query failed]" >> ./log/SummaryReport.txt; exit $rc; fi

	if grep -f $HIVE_OUT $HIVE_DATA_PATH
	then
	echo "same data as in the output location"
	echo "**************************************"
	echo "* Hive test completed Successfully ! *"
	echo "**************************************"

	echo " - Hive for impala		- Passed" >> ./log/SummaryReport.txt
	else
	echo "Not same data as in the output location"
	echo "**************************************"
	echo "* Hive test not  completed Successfully ! *"
	echo "**************************************"

	echo " - Hive for impala		- Failed[Not same data as in the output location]" >> ./log/SummaryReport.txt
	fi
	

else


	echo "Hive is not secured"
	beeline -n `whoami` -u "jdbc:hive2://${HIVESERVER2}:10000" -e "CREATE TABLE test(id INT, name STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY '	' STORED AS TEXTFILE;"
	rc=$?; if [[ $rc != 0 ]]; then echo "Create query failed! exiting"; echo " - Hive	- Failed [Create query failed]" >> ./log/SummaryReport.txt; exit $rc; fi

	echo "1	justin" > $HIVE_DATA_PATH
	rc=$?; if [[ $rc != 0 ]]; then echo "Input data generation failed! exiting"; echo " - Hive		- Failed [Input data generation failed]" >> ./log/SummaryReport.txt; exit $rc; fi
	echo "2	michael" >> $HIVE_DATA_PATH
	rc=$?; if [[ $rc != 0 ]]; then echo "Input data generation failed! exiting"; echo " - Hive		- Failed [Input data generation failed]" >> ./log/SummaryReport.txt; exit $rc; fi

	hdfs dfs -put $HIVE_DATA_PATH  $HIVE_TABLE_LOC
	rc=$?; if [[ $rc != 0 ]]; then echo "Input data transfer failed! exiting"; echo " - Hive		- Failed [Input data transfer failed]" >> ./log/SummaryReport.txt; exit $rc; fi

	hdfs dfs -mkdir -p $HIVE_OUT
 

	beeline --showHeader=false --outputformat=tsv2  -n `whoami` -u "jdbc:hive2://${HIVESERVER2}:10000" -e "SELECT * FROM test WHERE id=1;" > $HIVE_OUT
	rc=$?; if [[ $rc != 0 ]]; then echo "Select query failed! exiting"; echo " - Hive		- Failed [Select query failed]" >> ./log/SummaryReport.txt; exit $rc; fi




	if grep -f $HIVE_OUT $HIVE_DATA_PATH
	then
		echo "same data as in the output location"
		echo "**************************************"
		echo "* Hive test completed Successfully ! *"
		echo "**************************************"
	
		echo " - Hive		- Passed" >> ./log/SummaryReport.txt
	else
		echo "Not same data as in the output location"
		echo "**************************************"
		echo "* Hive test not  completed Successfully ! *"
		echo "**************************************"
	
		echo " - Hive		- Failed[Not same data as in the output location]" >> ./log/SummaryReport.txt
	fi
		

fi