import sys
from pyspark import SparkConf, SparkContext

try:
    conf = SparkConf().setAppName("pysparkTest-wordCount")
    sc = SparkContext(conf=conf)
    input = sys.argv[1]
    output = sys.argv[2]
    text_file = sc.textFile(input)
    counts = text_file.flatMap(lambda line: line.split(" ")) \
                .map(lambda word: (word, 1)) \
                .reduceByKey(lambda a, b: a + b)
    counts.saveAsTextFile(output)

except Exception as e: 
    print(e)
    print ("Error occured! Exiting!")
    sys.exit(1)