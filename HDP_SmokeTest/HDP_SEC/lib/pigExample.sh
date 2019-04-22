#!/bin/bash

source /home/murshida/KitePharma_SmokeTest/HDP_SEC/conf/SmokeConfig.config

echo $PIG_PATH_IN
echo $PIG_PATH_OUT

if   hdfs dfs -test -e $PIG_PATH_OUT ; then
hdfs dfs -rm -r  $PIG_PATH_OUT
fi
pig -f pigScript.pig -param input=$PIG_PATH_IN -param output=$PIG_PATH_OUT >>$LOG_PATH

