#!/bin/bash
source ./conf/SmokeConfig.config

if  hdfs dfs -test -e $HDFS_PATH  ; then
    echo "[$HDFS_PATH] exists on HDFS" 
	
    hdfs dfs -ls $HDFS_PATH 
else 
   echo "$HDFS_PATH path not exists !!" 
    if   hdfs dfs -test -e $TEMP_PATH ; then
   
        rm $TEMP_PATH
		hdfs dfs -ls / 
		echo "[$TEMP_PATH] exists on HDFS" 
		hdfs dfs -ls / 
		hdfs dfs -put $LOC_PATH $HDFS_PATH 
		hdfs dfs -get $HDFS_PATH $TEMP_PATH 
		cat $TEMP_PATH 
	else
		
		echo "no path exists"	
		hdfs dfs -ls / 
		hdfs dfs -put $LOC_PATH $HDFS_PATH 
		hdfs dfs -get $HDFS_PATH $TEMP_PATH 
		cat $TEMP_PATH 
	fi
fi

echo "******************************************************************************************************************************************"