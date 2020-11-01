#!/bin/bash
source ./conf/SmokeConfig.config

echo "HBASE_TABLE_NAME: $HBASE_TABLE_NAME"

printf "disable '%s'\ndropp '%s'\n" "$HBASE_TABLE_NAME" "$HBASE_TABLE_NAME" | hbase shell 2>&1

