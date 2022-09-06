#!/bin/bash
source ./conf/SmokeConfig.config

echo "HIVESERVER2: $HIVESERVER2"
echo "HIVE_TABLE_NAME: $HIVE_TABLE_NAME"

BEELINE_CONNECTIONS_STRING="jdbc:hive2://${HIVESERVER2}/"
if $KERBEROS_SECURITY; then
	echo "Hive is secured"
	REALM=$(awk '/^ *default_realm/{print $3}' /etc/krb5.conf)
	PRINCIPAL="$BEELINE_USER"/_HOST@${REALM}
	echo "BEELINE_USER: $BEELINE_USER"
	echo "REALM: $REALM"
	echo "PRINCIPAL: $PRINCIPAL"

	BEELINE_CONNECTIONS_STRING="${BEELINE_CONNECTIONS_STRING};principal=${PRINCIPAL}"
fi
if $HIVE_SSL_ENABLED; then
	echo "Hive: SSL enabled."
	echo "BTOPTS: $BTOPTS"
	BEELINE_CONNECTIONS_STRING="${BEELINE_CONNECTIONS_STRING}${BTOPTS}"
fi
if [ -f /etc/hive/conf/beeline-site.xml ]; then
	BEELINE_CONNECTIONS_STRING=$(xmllint --xpath 'string(/configuration/property[name="beeline.hs2.jdbc.url.hive_on_tez"]/value)' /etc/hive/conf/beeline-site.xml)
fi
echo "BEELINE_CONNECTIONS_STRING: ${BEELINE_CONNECTIONS_STRING}"

beeline -n "$(whoami)" -u "${BEELINE_CONNECTIONS_STRING}" -e "DROP TABLE ${HIVE_TABLE_NAME};"

rm  -f hive_select_test.txt
rm  -f hive_check.txt
