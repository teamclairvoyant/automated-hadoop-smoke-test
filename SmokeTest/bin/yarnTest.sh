source ./conf/SmokeConfig.config


hdfs dfs -mkdir -p $MAP_REDUCE_IN
hdfs dfs -mkdir -p $MAP_REDUCE_OUT

hdfs dfs -put -f ./lib/WordCountFile.txt $MAP_REDUCE_IN/
rc=$?; if [[ $rc != 0 ]]; then echo "Input dat tranfser failed! exiting"; echo " - MapReduce	- Failed [Input dat tranfser failed]" >> ./log/${timestamp}SummaryReport.txt; exit $rc; fi

hdfs dfs -rm -r $MAP_REDUCE_OUT

yarn jar ./lib/MapReduce-1.0.jar com.fs.WordCount $MAP_REDUCE_IN/WordCountFile.txt $MAP_REDUCE_OUT
rc=$?; if [[ $rc != 0 ]]; then echo "Mapreduce Job failed! exiting"; echo " - MapReduce	- Failed [Wordcount test failed]" >> ./log/${timestamp}SummaryReport.txt; exit $rc; fi

hdfs dfs -rm -r $MAP_REDUCE_IN/WordCountFile.txt
#rc=$?; if [[ $rc != 0 ]]; then echo "Wordcount input removal failed! exiting"; echo " - MapReduce	- Failed [Wordcount input removal failed] >> ./log/${timestamp}SummaryReport.txt; exit $rc; fi

echo "******************************************"
echo "* MapReduce test completed Successfully! *"
echo "******************************************"

echo " - MapReduce	- Passed" >> ./log/${timestamp}SummaryReport.txt