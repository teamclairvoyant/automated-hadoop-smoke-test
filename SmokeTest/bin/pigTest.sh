#!/bin/bash

source ./conf/SmokeConfig.config

echo "PIG_PATH_IN: $PIG_PATH_IN"
echo "PIG_PATH_OUT: $PIG_PATH_OUT"

hdfs dfs -mkdir -p "$PIG_PATH_IN"
hdfs dfs -mkdir -p "$PIG_PATH_OUT"

hdfs dfs -put -f ./lib/data.csv "$PIG_PATH_IN"
rc=$?; if [[ $rc != 0 ]]; then echo "Input data transfer failed! exiting"; echo " - Pig          - Failed [Input data transfer failed]" >> ./log/SummaryReport.txt; exit $rc; fi


if   hdfs dfs -test -e "$PIG_PATH_OUT" ; then
	hdfs dfs -rm -r  "$PIG_PATH_OUT"
	rc=$?; if [[ $rc != 0 ]]; then echo "Cannot remove existing HDFS output directory! exiting"; echo " - Pig          - Failed [Cannot remove existing HDFS output directory]" >> ./log/SummaryReport.txt; exit $rc; fi
fi

pig -f ./lib/pigScript.pig -param input="$PIG_PATH_IN" -param output="$PIG_PATH_OUT"
rc=$?; if [[ $rc != 0 ]]; then echo "Pig script failed! exiting"; echo " - Pig          - Failed [Pig script failed]" >> ./log/SummaryReport.txt; exit $rc; fi

echo "************************************"
echo "* Pig test completed Successfully! *"
echo "************************************"

echo " - Pig          - Passed " >> ./log/SummaryReport.txt
