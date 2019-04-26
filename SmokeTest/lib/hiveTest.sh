#!/bin/bash
source ./conf/SmokeConfig.config

HIVESERVER2=$HIVESERVER2

REALM=${REALM}

BKOPTS=$BKOPTS


beeline -n `whoami` -u "jdbc:hive2://${HIVESERVER2}:10000/${BKOPTS}" -e "CREATE TABLE test(id INT, name STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY ' ' STORED AS TEXTFILE;"

echo "1 justin" > $HIVE_DATA_PATH
echo "2 michael" >> $HIVE_DATA_PATH
hdfs dfs -put $HIVE_DATA_PATH  $HIVE_WAREHOUSE

beeline -n `whoami` -u "jdbc:hive2://${HIVESERVER2}:10000/${BKOPTS}" -e "SELECT * FROM test WHERE id=1;" 

echo "******************************************************************************************************************************************"
