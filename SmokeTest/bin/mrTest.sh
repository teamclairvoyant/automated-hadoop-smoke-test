#!/bin/bash
source ./conf/SmokeConfig.config

echo "MAP_REDUCE_IN: $MAP_REDUCE_IN"
echo "MAP_REDUCE_OUT: $MAP_REDUCE_OUT"
echo "MAP_REDUCE_JAR: $MAP_REDUCE_JAR"


hdfs dfs -rm -r -f "$MAP_REDUCE_IN"
hdfs dfs -rm -r -f "$MAP_REDUCE_OUT"

hdfs dfs -mkdir -p "$MAP_REDUCE_IN"
hdfs dfs -mkdir -p "$MAP_REDUCE_OUT"

hdfs dfs -put -f ./lib/WordCountFile.txt "$MAP_REDUCE_IN"/
rc=$?; if [[ $rc != 0 ]]; then echo "Input data tranfser failed! exiting"; echo " - MapReduce    - Failed [Input data tranfser failed]" >> ./log/SummaryReport.txt; exit $rc; fi

hdfs dfs -rm -r "$MAP_REDUCE_OUT"

yarn jar "$MAP_REDUCE_JAR" wordcount "$MAP_REDUCE_IN"/WordCountFile.txt "$MAP_REDUCE_OUT"
rc=$?; if [[ $rc != 0 ]]; then echo "Mapreduce Job failed! exiting"; echo " - MapReduce    - Failed [Wordcount test failed]" >> ./log/SummaryReport.txt; exit $rc; fi

echo "******************************************"
echo "* MapReduce test completed Successfully! *"
echo "******************************************"

echo " - MapReduce    - Passed" >> ./log/SummaryReport.txt
