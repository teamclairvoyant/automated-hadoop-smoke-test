#!/usr/bin/env bash
source ./conf/SmokeConfig.config

echo "--- piEstimation ---"
spark2-submit ./lib/piEstimation.py
rc=$?; if [[ $rc != 0 ]]; then echo "Pi Estimation test failed! exiting"; echo " - pySpark2	- Failed [Pi Estimation test failed]" >> ./log/SummaryReport.txt; exit $rc; fi

echo "**************************************"
echo "* pySpark2 test completed Successfully! *"
echo "**************************************"

echo " - pySpark2	- Passed" >> ./log/SummaryReport.txt