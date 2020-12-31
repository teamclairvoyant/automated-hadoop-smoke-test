#!/bin/bash
source ./conf/SmokeConfig.config

echo "HBASE_TABLE_NAME: $HBASE_TABLE_NAME"

printf "disable '%s'\ndrop '%s'\n" "$HBASE_TABLE_NAME" "$HBASE_TABLE_NAME" | hbase shell 2>&1

