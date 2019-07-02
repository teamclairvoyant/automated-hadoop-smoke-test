#!/bin/bash
source ./conf/SmokeConfig.config

if $SECURITY_HIVE; then
	echo "Hive is secured"
	kinit -kt $KRB_KEYTAB_HIVE $KRB_PRINCIPAL_HIVE

	beeline -n $(whoami) -u "jdbc:hive2://${HIVESERVER2}/;principal=${KRB_PRINCIPAL_HIVE}${BTOPTS}" -e "CREATE TABLE test(id INT, name STRING) ROW FORMAT DELIMITED FIELDSTERMINATED BY ' ' STORED AS TEXTFILE;"
	rc=$?
	if [[ $rc != 0 ]]; then
		echo "Create query failed! exiting"
		echo " - Hive	- Failed [Create query failed]" >>./log/${timestamp}SummaryReport.txt
		exit $rc
	fi
	echo "1 justin" >$HIVE_DATA_PATH
	rc=$?
	if [[ $rc != 0 ]]; then
		echo "Input data generation failed! exiting"
		echo " - Hive		- Failed [Input data generation failed]" >>./log/${timestamp}SummaryReport.txt
		exit $rc
	fi
	echo "2 michael" >>$HIVE_DATA_PATH
	rc=$?
	if [[ $rc != 0 ]]; then
		echo "Input data generation failed! exiting"
		echo " - Hive		- Failed [Input data generation failed]" >>./log/${timestamp}SummaryReport.txt
		exit $rc
	fi
	hdfs dfs -put $HIVE_DATA_PATH $HIVE_TABLE_LOC
	rc=$?
	if [[ $rc != 0 ]]; then
		echo "Input data transfer failed! exiting"
		echo " - Hive		- Failed [Input data transfer failed]" >>./log/${timestamp}SummaryReport.txt
		exit $rc
	fi
	beeline -n $(whoami) -u "jdbc:hive2://${HIVESERVER2}/;principal=${KRB_PRINCIPAL_HIVE}${BTOPTS}" -e"SELECT * FROM test WHERE id=1;"
	rc=$?
	if [[ $rc != 0 ]]; then
		echo "Select query failed! exiting"
		echo " - Hive		- Failed [Select query failed]" >>./log/${timestamp}SummaryReport.txt
		exit $rc
	fi

else

	echo "Hive is not secured"
	beeline -n $(whoami) -u "jdbc:hive2://${HIVESERVER2}" -e "CREATE TABLE test(id INT, name STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY '	' STORED AS TEXTFILE;"
	rc=$?
	if [[ $rc != 0 ]]; then
		echo "Create query failed! exiting"
		echo " - Hive	- Failed [Create query failed]" >>./log/${timestamp}SummaryReport.txt
		exit $rc
	fi

	echo "1	justin" >$HIVE_DATA_PATH
	rc=$?
	if [[ $rc != 0 ]]; then
		echo "Input data generation failed! exiting"
		echo " - Hive		- Failed [Input data generation failed]" >>./log/${timestamp}SummaryReport.txt
		exit $rc
	fi
	echo "2	michael" >>$HIVE_DATA_PATH
	rc=$?
	if [[ $rc != 0 ]]; then
		echo "Input data generation failed! exiting"
		echo " - Hive		- Failed [Input data generation failed]" >>./log/${timestamp}SummaryReport.txt
		exit $rc
	fi

	hdfs dfs -put $HIVE_DATA_PATH $HIVE_TABLE_LOC
	rc=$?
	if [[ $rc != 0 ]]; then
		echo "Input data transfer failed! exiting"
		echo " - Hive		- Failed [Input data transfer failed]" >>./log/${timestamp}SummaryReport.txt
		exit $rc
	fi

	hdfs dfs -mkdir -p $HIVE_OUT

	echo $HIVE_OUT/${HIVE_DATA_PATH##/*/} $HIVE_DATA_PATH
	beeline --showHeader=false --outputformat=tsv2 -n $(whoami) -u "jdbc:hive2://${HIVESERVER2}" -e "SELECT * FROM test WHERE id=1;" >$HIVE_OUT
	rc=$?
	if [[ $rc != 0 ]]; then
		echo "Select query failed! exiting"
		echo " - Hive		- Failed [Select query failed]" >>./log/${timestamp}SummaryReport.txt
		exit $rc
	fi

fi

if grep -f $HIVE_OUT $HIVE_DATA_PATH; then
	echo "same data as in the output location"
	echo "**************************************"
	echo "* Hive test completed Successfully ! *"
	echo "**************************************"
	echo " - Hive		- Passed" >>./log/${timestamp}SummaryReport.txt
else
	echo "Not same data as in the output location"
	echo "**************************************"
	echo "* Hive test not  completed Successfully ! *"
	echo "**************************************"
	echo " - Hive		- Failed[Not same data as in the output location]" >>./log/${timestamp}SummaryReport.txt
fi
