#!/bin/bash
HIVESERVER2=hortonworks.master
beeline -n `whoami` -u "jdbc:hive2://${HIVESERVER2}:10000" -e "DROP TABLE test;"
