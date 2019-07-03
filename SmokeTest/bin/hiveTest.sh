#!/bin/bash
source ./conf/SmokeConfig.config

echo "HIVESERVER2: $HIVESERVER2"
echo "HIVE_DATA_PATH: $HIVE_DATA_PATH"
echo "HIVE_TABLE_LOC: $HIVE_TABLE_LOC"
echo "HIVE_OUT: $HIVE_OUT"

BEELINE_CONNECTIONS_STRING="jdbc:hive2://${HIVESERVER2}/"

if $SECURITY_HIVE; then
	echo "Hive is secured"
	echo "KRB_KEYTAB_HIVE: $KRB_KEYTAB_HIVE"
	echo "KRB_PRINCIPAL_HIVE: $KRB_PRINCIPAL_HIVE"

	kinit -kt $KRB_KEYTAB_HIVE $KRB_PRINCIPAL_HIVE
	BEELINE_CONNECTIONS_STRING="${BEELINE_CONNECTIONS_STRING};principal=${KRB_PRINCIPAL_HIVE}${BTOPTS}"
fi

echo "Hive is not secured"
beeline -n $(whoami) -u "${BEELINE_CONNECTIONS_STRING}" -e "CREATE TABLE test(id INT, name STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY '	' STORED AS TEXTFILE;"
rc=$?
if [[ $rc != 0 ]]; then
	echo "Create query failed! exiting"
	echo " - Hive	- Failed [Create query failed]" >>./log/SummaryReport.txt
	exit $rc
fi

echo "1	justin" >$HIVE_DATA_PATH
rc=$?
if [[ $rc != 0 ]]; then
	echo "Input data generation failed! exiting"
	echo " - Hive		- Failed [Input data generation failed]" >>./log/SummaryReport.txt
	exit $rc
fi

echo "2	michael" >>$HIVE_DATA_PATH
rc=$?
if [[ $rc != 0 ]]; then
	echo "Input data generation failed! exiting"
	echo " - Hive		- Failed [Input data generation failed]" >>./log/SummaryReport.txt
	exit $rc
fi

hdfs dfs -put $HIVE_DATA_PATH $HIVE_TABLE_LOC
rc=$?
if [[ $rc != 0 ]]; then
	echo "Input data transfer failed! exiting"
	echo " - Hive		- Failed [Input data transfer failed]" >>./log/SummaryReport.txt
	exit $rc
fi

hdfs dfs -mkdir -p $HIVE_OUT

echo $HIVE_OUT/${HIVE_DATA_PATH##/*/} $HIVE_DATA_PATH
beeline --showHeader=false --outputformat=tsv2 -n $(whoami) -u "${BEELINE_CONNECTIONS_STRING}" -e "SELECT * FROM test WHERE id=1;" >$HIVE_OUT
rc=$?
if [[ $rc != 0 ]]; then
	echo "Select query failed! exiting"
	echo " - Hive		- Failed [Select query failed]" >>./log/SummaryReport.txt
	exit $rc
fi

if grep -f $HIVE_OUT $HIVE_DATA_PATH; then
	echo "same data as in the output location"
	echo "**************************************"
	echo "* Hive test completed Successfully ! *"
	echo "**************************************"
	echo " - Hive		- Passed" >>./log/SummaryReport.txt
else
	echo "Not same data as in the output location"
	echo "**************************************"
	echo "* Hive test not  completed Successfully ! *"
	echo "**************************************"
	echo " - Hive		- Failed[Not same data as in the output location]" >>./log/SummaryReport.txt
fi
