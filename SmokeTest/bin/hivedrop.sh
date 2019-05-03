#!/bin/bash
source ./conf/SmokeConfig.config

HIVESERVER2=$HIVESERVER2

REALM=${REALM}

BKOPTS=$BKOPTS

beeline -n `whoami` -u "jdbc:hive2://${HIVESERVER2}:10000/${BKOPTS}" -e "DROP TABLE test;"
