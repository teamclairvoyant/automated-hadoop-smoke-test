#!/bin/bash
source ./conf/SmokeConfig.config

HIVESERVER2=$HIVESERVER2

REALM=${REALM}

BKOPTS=$BKOPTS

rm -r -f  $HIVE_TABLE_LOC
if $SECURITY_HIVE ; then
	kinit -kt $KRB_KEYTAB_HIVE $KRB_PRINCIPAL_HIVE
	beeline -n `whoami` -u "jdbc:hive2://${HIVESERVER2}:10000/${BKOPTS}${BTOPTS}" -e "DROP TABLE test;"
else
	beeline -n `whoami` -u "jdbc:hive2://${HIVESERVER2}:10000/" -e "DROP TABLE test;"
fi
