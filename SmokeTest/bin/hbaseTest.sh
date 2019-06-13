#!/usr/bin/env bash
# hbase shell ./lib/hbase.txt


printf "create 'test', 'cf'" | hbase shell 2>&1 | grep -q "Hbase::Table - test" 2>/dev/null
rc=$?; if [[ $rc != 0 ]]; then echo "Create command failed! exiting"; echo " - HBase	- Failed [Create command failed]" >> ./log/SummaryReport.txt; exit $rc; fi
echo "Hbase test table created !"

printf "list 'test'" | hbase shell 2>&1
printf "list 'test'" | hbase shell 2>&1 | grep -q "[\"test\"]" 2>/dev/null
rc=$?; if [[ $rc != 0 ]]; then echo "List command failed! exiting"; echo " - HBase	- Failed [List command failed]" >> ./log/SummaryReport.txt; exit $rc; fi

printf "put 'test', 'row1', 'cf:a', 'value1'" | hbase shell 2>&1 |grep -q "0 row(s) in" 2>/dev/null
rc=$?; if [[ $rc != 0 ]]; then echo "Put command failed! exiting"; echo " - HBase	- Failed [Put command failed]" >> ./log/SummaryReport.txt; exit $rc; fi

printf "scan 'test'" | hbase shell 2>&1
printf "scan 'test'" | hbase shell 2>&1 |grep -q "1 row(s) in" 2>/dev/null
rc=$?; if [[ $rc != 0 ]]; then echo "Scan command failed! exiting"; echo " - HBase	- Failed [Scan command failed]" >> ./log/SummaryReport.txt; exit $rc; fi




echo "**************************************"
echo "* HBase test completed Successfully! *"
echo "**************************************"

echo " - HBase	- Passed" >> ./log/SummaryReport.txt