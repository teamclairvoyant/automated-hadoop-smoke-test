#!/bin/bash
source ./conf/SmokeConfig.config

echo "HIVESERVER2: $HIVESERVER2"
echo "HIVE_TABLE_NAME: $HIVE_TABLE_NAME"

BEELINE_CONNECTIONS_STRING="jdbc:hive2://${HIVESERVER2}/"

if $KERBEROS_SECURITY; then
	echo "Hive is secured"
	BEELINE_USER="hive"
	echo "BEELINE_USER: $BEELINE_USER"
	REALM=$(awk '/^ *default_realm/{print $3}' /etc/krb5.conf)
	echo "REALM: $REALM"
	PRINCIPAL="$BEELINE_USER"/_HOST@${REALM}
	echo "PRINCIPAL: $PRINCIPAL"

	BEELINE_CONNECTIONS_STRING="${BEELINE_CONNECTIONS_STRING};principal=${PRINCIPAL}"
fi

if $HIVE_SSL_ENABLED; then
	echo "Hive: SSL enabled."
	echo "BTOPTS: $BTOPTS"
	BEELINE_CONNECTIONS_STRING="${BEELINE_CONNECTIONS_STRING}${BTOPTS}"
fi

beeline -n "$(whoami)" -u "${BEELINE_CONNECTIONS_STRING}" -e "DROP TABLE ${HIVE_TABLE_NAME};"
