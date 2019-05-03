#!/usr/bin/env bash

impala-shell -i  quickstart.cloudera  -q "invalidate metadata;"
rc=$?; if [[ $rc != 0 ]]; then echo "error! exiting"; echo " - Impala	- Failed [Invalidation failed]" >> ./log/SummaryReport.txt; exit $rc; fi

impala-shell -i  quickstart.cloudera  -q "select * FROM test;"
rc=$?; if [[ $rc != 0 ]]; then echo "error! exiting"; echo " - Impala	- Failed [Select query failed]" >> ./log/SummaryReport.txt; exit $rc; fi

echo "***************************************"
echo "* Impala test completed Successfully! *"
echo "***************************************" 

echo "- Impala	- Passed" >> ./log/SummaryReport.txt