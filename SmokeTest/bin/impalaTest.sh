#!/usr/bin/env bash
source ./conf/SmokeConfig.config



impala-shell -i  $IMPALADAEMON -q "CREATE TABLE test_impala (x INT, y STRING);"
impala-shell -i  $IMPALADAEMON -q "INSERT INTO test_impala VALUES (1, 'one'), (2, 'two'), (3, 'three');"

impala-shell -i  $IMPALADAEMON -q "invalidate metadata;"
rc=$?; if [[ $rc != 0 ]]; then echo "Invalidation failed! exiting"; echo " - Impala	- Failed [Invalidation failed]" >> ./log/SummaryReport.txt; exit $rc; fi

impala-shell -i  $IMPALADAEMON -q "select * FROM test_impala;" | tail -n +3 | sed -r 's/[-|+]+/ /g' | awk '{$1=$1};1' > $IMPALA_VAL
rc=$?; if [[ $rc != 0 ]]; then echo "Select query failed! exiting"; echo " - Impala	- Failed [Select query failed]" >> ./log/SummaryReport.txt; exit $rc; fi



echo "1 one" >$IMPALA_INP
echo "2 two" >>$IMPALA_INP
echo "3 three" >>$IMPALA_INP

cat $IMPALA_INP
cat $IMPALA_VAL


diff -B $IMPALA_INP $IMPALA_VAL
status=$?


if [[ $status = 0 ]]; then
	echo "Files are the same"
	echo "***************************************"
	echo "* Impala test completed Successfully! *"
	echo "***************************************"
	echo " - Impala	- Passed" >> ./log/SummaryReport.txt
else
	echo "Files are different"
	echo "***************************************"
	echo "* Impala test not  completed Successfully! *"
	echo "***************************************"
	echo " - Impala	- Failed[datas in impala and date inserted are different]" >> ./log/SummaryReport.txt
fi




