#!/bin/bash
source ./conf/SmokeConfig.config

echo "HDFS_PATH: $HDFS_PATH"
echo "LOC_PATH: $LOC_PATH"
echo "TEMP_PATH: $TEMP_PATH"

hdfs dfs -ls /
rc=$?; if [[ $rc != 0 ]]; then echo "Error in showing files in HDFS! exiting"; echo " - HDFS         - Failed [Error in showing files in HDFS]" >> "$LOG_PATH"/SummaryReport.txt; exit $rc; fi

hdfs dfs -mkdir -p "$HDFS_PATH"
rc=$?; if [[ $rc != 0 ]]; then echo "Error in showing files in HDFS! exiting"; echo " - HDFS         - Failed [Error in showing files in HDFS]" >> "$LOG_PATH"/SummaryReport.txt; exit $rc; fi

hdfs dfs -put "$LOC_PATH" "$HDFS_PATH"
rc=$?; if [[ $rc != 0 ]]; then echo "Error in copying file to HDFS! exiting"; echo " - HDFS         - Failed [Error in copying file to HDFS]" >> "$LOG_PATH"/SummaryReport.txt; exit $rc; fi

hdfs dfs -get "$HDFS_PATH" "$TEMP_PATH"
rc=$?; if [[ $rc != 0 ]]; then echo "Error in copying file from HDFS! exiting"; echo " - HDFS         - Failed [Error in copying file from HDFS]" >> "$LOG_PATH"/SummaryReport.txt; exit $rc; fi

cat "$TEMP_PATH"/hosts
rc=$?; if [[ $rc != 0 ]]; then echo "Error in showing copied file from HDFS! exiting"; echo " - HDFS         - Failed [Error in showing copied file from HDFS]" >> "$LOG_PATH"/SummaryReport.txt; exit $rc; fi

cmp "$LOC_PATH" "$TEMP_PATH"/"${LOC_PATH##/*/}"
status=$?
if [[ $status = 0 ]]; then
    echo "Files are the same"
    echo " - HDFS         - Passed" >> "$LOG_PATH"/SummaryReport.txt
    echo "**************************************"
    echo "* HDFS test completed Successfully ! *"
    echo "**************************************"
else
    echo "Files are different"
    echo " - HDFS         - Failed[Files are different]" >> "$LOG_PATH"/SummaryReport.txt
    echo "**********************"
    echo "* HDFS test Failed ! *"
    echo "**********************"
fi
