#!/bin/bash
source ./conf/SmokeConfig.config

echo "TEMP_HDFS_DIRECTORY: $TEMP_HDFS_DIRECTORY"

rm -f SmokeTest.xml
hdfs dfs -rm -r -f -skipTrash "$TEMP_HDFS_DIRECTORY"

