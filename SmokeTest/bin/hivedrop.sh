#!/bin/bash
source ./conf/SmokeConfig.config

echo "HIVESERVER2: $HIVESERVER2"
echo "HIVE_TABLE_LOC: $HIVE_TABLE_LOC"

BEELINE_CONNECTIONS_STRING="jdbc:hive2://${HIVESERVER2}/"

rm -r -f $HIVE_TABLE_LOC
if $SECURITY_HIVE; then
	echo "KRB_KEYTAB_HIVE: $KRB_KEYTAB_HIVE"
	echo "KRB_PRINCIPAL_HIVE: $KRB_PRINCIPAL_HIVE"

	kinit -kt $KRB_KEYTAB_HIVE $KRB_PRINCIPAL_HIVE
	beeline -n $(whoami) -u "${BEELINE_CONNECTIONS_STRING};principal=${KRB_PRINCIPAL_HIVE}${BTOPTS}" -e "DROP TABLE test;"
else
	beeline -n $(whoami) -u "${BEELINE_CONNECTIONS_STRING}" -e "DROP TABLE test;"
fi
