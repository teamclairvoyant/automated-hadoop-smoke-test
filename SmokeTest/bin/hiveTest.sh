#!/bin/bash
source ./conf/SmokeConfig.config

echo "HIVESERVER2: $HIVESERVER2"
echo "HIVE_TABLE_LOC: $HIVE_TABLE_LOC"
echo "HIVE_TABLE_NAME: $HIVE_TABLE_NAME"

BEELINE_CONNECTIONS_STRING="jdbc:hive2://${HIVESERVER2}/"

if $SECURITY; then
	echo "Hive is secured."
	BEELINE_USER="hive"
	echo "BEELINE_USER: $BEELINE_USER"
	REALM=$(awk '/^ *default_realm/{print $3}' /etc/krb5.conf)
	echo "REALM: $REALM"
	PRINCIPAL="$BEELINE_USER"/_HOST@${REALM}
	echo "PRINCIPAL: $PRINCIPAL"
	
	BEELINE_CONNECTIONS_STRING="${BEELINE_CONNECTIONS_STRING};principal=${PRINCIPAL}"

else
	echo "Hive is not secured."
fi


beeline -n $(whoami) -u "${BEELINE_CONNECTIONS_STRING}" -e "CREATE TABLE ${HIVE_TABLE_NAME}(id INT, name STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY '	' STORED AS TEXTFILE;"
rc=$?
if [[ $rc != 0 ]]; then
	echo "Create query failed! exiting"
	echo " - Hive	- Failed [Create query failed]" >>./log/SummaryReport.txt
	exit $rc
fi

echo "1	justin" >>hive_check.txt
echo "2	michael" >>hive_check.txt

hdfs dfs -put hive_check.txt "$HIVE_TABLE_LOC"
rc=$?
if [[ $rc != 0 ]]; then
	echo "Input data transfer failed! exiting"
	echo " - Hive		- Failed [Input data transfer failed]" >>./log/SummaryReport.txt
	exit $rc
fi

beeline --showHeader=false --outputformat=tsv2 -n "$(whoami)" -u "${BEELINE_CONNECTIONS_STRING}" -e "SELECT * FROM ${HIVE_TABLE_NAME} WHERE id=1;" >hive_select_test.txt
rc=$?
if [[ $rc != 0 ]]; then
	echo "Select query failed! exiting"
	echo " - Hive		- Failed [Select query failed]" >>./log/SummaryReport.txt
	exit $rc
fi

if grep -f hive_select_test.txt hive_check.txt; then
	echo "same data as in the output location"
	echo "**************************************"
	echo "* Hive test completed Successfully ! *"
	echo "**************************************"
	echo " - Hive		- Passed" >>./log/SummaryReport.txt
else
	echo "Not same data as in the output location"
	echo "**************************************"
	echo "* Hive test not completed Successfully ! *"
	echo "**************************************"
	echo " - Hive		- Failed[Not same data as in the output location]" >>./log/SummaryReport.txt
fi
