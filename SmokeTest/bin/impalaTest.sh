#!/usr/bin/env bash
source ./conf/SmokeConfig.config



if $HIVE ; then

    bash ./bin/hivedrop.sh
    bash ./bin/hiveImpalaTest.sh



    impala-shell -i  $IMPALADAEMON -q "invalidate metadata;"
    rc=$?; if [[ $rc != 0 ]]; then echo "Invalidation failed! exiting"; echo " - Impala	- Failed [Invalidation failed]" >> ./log/SummaryReport.txt; exit $rc; fi

    impala-shell -i  $IMPALADAEMON -q "select * FROM test;" | tail -n +3 | sed -r 's/[-|+]+/ /g' | awk '{$1=$1};1' > $IMPALA_VAL
    rc=$?; if [[ $rc != 0 ]]; then echo "Select query failed! exiting"; echo " - Impala	- Failed [Select query failed]" >> ./log/SummaryReport.txt; exit $rc; fi



    export HIVE_SKIP_SPARK_ASSEMBLY=true;
    hive -S -e "select * FROM test;" | sed -r 's/\t/ /g' > $IMPALA_HIVE
    diff -B $IMPALA_HIVE $IMPALA_VAL
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

	    echo " - Impala	- Failed[datas in impala and hive are different]" >> ./log/SummaryReport.txt
    fi

else

	echo "***************************************"
	echo "* Impala test not  completed Successfully! *"
	echo "***************************************"

fi


