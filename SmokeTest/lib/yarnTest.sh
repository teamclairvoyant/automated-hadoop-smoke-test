source ./conf/SmokeConfig.config

hdfs dfs -put -f ./lib/WordCountFile.txt $MAP_REDUCE_IN/

hdfs dfs -rm -r $MAP_REDUCE_OUT

yarn jar ./lib/MapReduce-1.0.jar com.fs.WordCount $MAP_REDUCE_IN/WordCountFile.txt $MAP_REDUCE_OUT

hdfs dfs -rm -r $MAP_REDUCE_IN/WordCountFile.txt


echo "******************************************************************************************************************************************"