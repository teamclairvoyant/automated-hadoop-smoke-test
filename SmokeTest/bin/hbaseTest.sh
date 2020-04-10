#!/bin/bash
source ./conf/SmokeConfig.config

echo "HBASE_TABLE_NAME: $HBASE_TABLE_NAME"

printf "create '%s', 'cf'\n" "$HBASE_TABLE_NAME" | hbase shell 2>&1 | grep -q "Hbase::Table - ${HBASE_TABLE_NAME}" 2>/dev/null
rc=$?; if [[ $rc != 0 ]]; then echo "Create command failed! exiting"; echo " - HBase        - Failed [Create command failed]" >> ./log/SummaryReport.txt; exit $rc; fi
echo "Hbase ${HBASE_TABLE_NAME} table created !"

printf "list '%s'\n" "$HBASE_TABLE_NAME" | hbase shell 2>&1
printf "list '%s'\n" "$HBASE_TABLE_NAME" | hbase shell 2>&1 | grep -q "[\"${HBASE_TABLE_NAME}\"]" 2>/dev/null
rc=$?; if [[ $rc != 0 ]]; then echo "List command failed! exiting"; echo " - HBase        - Failed [List command failed]" >> ./log/SummaryReport.txt; exit $rc; fi

printf "put '%s', 'row1', 'cf:a', 'value1'\n" "$HBASE_TABLE_NAME" | hbase shell 2>&1 |grep -q "0 row(s) in" 2>/dev/null
rc=$?; if [[ $rc != 0 ]]; then echo "Put command failed! exiting"; echo " - HBase         - Failed [Put command failed]" >> ./log/SummaryReport.txt; exit $rc; fi

printf "scan '%s'\n" "$HBASE_TABLE_NAME" | hbase shell 2>&1
printf "scan '%s'\n" "$HBASE_TABLE_NAME" | hbase shell 2>&1 |grep -q "1 row(s) in" 2>/dev/null
rc=$?; if [[ $rc != 0 ]]; then echo "Scan command failed! exiting"; echo " - HBase        - Failed [Scan command failed]" >> ./log/SummaryReport.txt; exit $rc; fi




echo "**************************************"
echo "* HBase test completed Successfully! *"
echo "**************************************"

echo " - HBase        - Passed" >> ./log/SummaryReport.txt
