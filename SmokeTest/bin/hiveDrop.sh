#!/bin/bash
source ./conf/SmokeConfig.config

echo "HIVESERVER2: $HIVESERVER2"
echo "HIVE_TABLE_LOC: $HIVE_TABLE_LOC"
echo "HIVE_TABLE_NAME: $HIVE_TABLE_NAME"

BEELINE_CONNECTIONS_STRING="jdbc:hive2://${HIVESERVER2}/"

rm -r -f "$HIVE_TABLE_LOC"

if $SECURITY; then
	echo "Hive is secured"
	BEELINE_USER="hive"
	echo "BEELINE_USER: $BEELINE_USER"
	REALM=$(awk '/^ *default_realm/{print $3}' /etc/krb5.conf)
	echo "REALM: $REALM"
	PRINCIPAL="$BEELINE_USER"/_HOST@${REALM}
	echo "PRINCIPAL: $PRINCIPAL"

	BEELINE_CONNECTIONS_STRING="${BEELINE_CONNECTIONS_STRING};principal=${PRINCIPAL}"
else
	beeline -n "$(whoami)" -u "${BEELINE_CONNECTIONS_STRING}" -e "DROP TABLE ${HIVE_TABLE_NAME};"
fi
