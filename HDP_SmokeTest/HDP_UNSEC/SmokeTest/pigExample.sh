#!/bin/bash

source /mnt/SmokeTest/SmokeConfig.config

echo $PIG_PATH_IN
echo $PIG_PATH_OUT

if   hdfs dfs -test -e $PIG_PATH_OUT ; then
su -c "hdfs dfs -rm -r  $PIG_PATH_OUT" hdfs
fi
pig -f pigScript.pig -param input=$PIG_PATH_IN -param output=$PIG_PATH_OUT >>$LOG_PATH

