#!/bin/bash

source ./conf/SmokeConfig.config

echo $PIG_PATH_IN
echo $PIG_PATH_OUT

hdfs dfs -put -f ./lib/data.csv $PIG_PATH_IN


if   hdfs dfs -test -e $PIG_PATH_OUT ; then
su -c "hdfs dfs -rm -r  $PIG_PATH_OUT" hdfs
fi
pig -f ./lib/pigScript.pig -param input=$PIG_PATH_IN -param output=$PIG_PATH_OUT 

echo "******************************************************************************************************************************************"

