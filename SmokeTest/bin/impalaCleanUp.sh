#!/usr/bin/env bash
source ./conf/SmokeConfig.config

echo "IMPALA_DAEMON: $IMPALA_DAEMON"
echo "IMPALA_TABLE_NAME: $IMPALA_TABLE_NAME"
echo "IMPALA_SSL_ENABLED: $IMPALA_SSL_ENABLED"

IMPALA_CONNECT_STRING="${IMPALA_DAEMON}"
if $IMPALA_SSL_ENABLED; then
	echo "IKOPTS: ${IKOPTS}"
	echo "ITOPTS: ${ITOPTS}"
	IMPALA_CONNECT_STRING="${IMPALA_CONNECT_STRING} ${IKOPTS} ${ITOPTS}"
fi
echo "IMPALA_CONNECT_STRING: ${IMPALA_CONNECT_STRING}"

impala-shell -i $IMPALA_CONNECT_STRING -q "drop table $IMPALA_TABLE_NAME;"

rm  -f impala_select_test.txt
rm  -f impala_check.txt
