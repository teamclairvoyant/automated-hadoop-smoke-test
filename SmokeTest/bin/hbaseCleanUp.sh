#!/bin/bash
source ./conf/SmokeConfig.config

echo "HBASE_TABLE_NAME: $HBASE_TABLE_NAME"

printf "disable '%s'\ndrop '%s'\n" "$HBASE_TABLE_NAME" "$HBASE_TABLE_NAME" | hbase shell -n 2>&1
rc=$?
if [[ $rc != 0 ]]; then
  echo "Disable/Drop command failed! exiting"
  #echo " - HBase        - Failed [Disable/Drop command failed]" >> "$LOG_PATH"/SummaryReport.txt
  exit $rc
fi

##printf "disable '%s'" "$HBASE_TABLE_NAME" | hbase shell -n 2>&1 | grep -q "ERROR: Table ${HBASE_TABLE_NAME}" 2>/dev/null
#printf "disable '%s'" "$HBASE_TABLE_NAME" | hbase shell -n
#rc=$?
#if [[ $rc != 0 ]]; then
#  echo "Disable command failed! exiting"
#  echo " - HBase        - Failed [Disable command failed]" >> "$LOG_PATH"/SummaryReport.txt
#  exit $rc
#fi
#
##printf "drop '%s'" "$HBASE_TABLE_NAME" | hbase shell -n 2>&1 | grep -q "ERROR: Table ${HBASE_TABLE_NAME}" 2>/dev/null
#printf "drop '%s'" "$HBASE_TABLE_NAME" | hbase shell -n
#rc=$?
#if [[ $rc != 0 ]]; then
#  echo "Drop command failed! exiting"
#  echo " - HBase        - Failed [Drop command failed]" >> "$LOG_PATH"/SummaryReport.txt
#  exit $rc
#fi

echo "HBase ${HBASE_TABLE_NAME} table removed!"

