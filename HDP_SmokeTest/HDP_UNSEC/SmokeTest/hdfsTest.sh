#!/bin/bash
source /mnt/SmokeTest/SmokeConfig.config

if  hdfs dfs -test -e $HDFS_PATH  ; then
    echo "[$HDFS_PATH] exists on HDFS" >> $LOG_PATH
	
    hdfs dfs -ls $HDFS_PATH >> $LOG_PATH
else 
   echo "$HDFS_PATH path not exists !!" >> $LOG_PATH
    if   hdfs dfs -test -e $TEMP_PATH ; then
   
        rm $TEMP_PATH
		hdfs dfs -ls / >> $LOG_PATH
		echo "[$TEMP_PATH] exists on HDFS" >> $LOG_PATH
		hdfs dfs -ls / >> $LOG_PATH
		hdfs dfs -put $LOC_PATH $HDFS_PATH >> $LOG_PATH
		hdfs dfs -get $HDFS_PATH $TEMP_PATH >> $LOG_PATH
		cat $TEMP_PATH >> $LOG_PATH
	else
		
		echo "no path exists"	
		hdfs dfs -ls / >> $LOG_PATH
		hdfs dfs -put $LOC_PATH $HDFS_PATH >> $LOG_PATH
		hdfs dfs -get $HDFS_PATH $TEMP_PATH >> $LOG_PATH
		cat $TEMP_PATH >> $LOG_PATH
	fi
fi