import sys
from operator import add
from pyspark import SparkConf, SparkContext

try:
    spark = SparkSession.builder.appName("pyspark2Test-wordCount").getOrCreate()
    input = sys.argv[1]
    output = sys.argv[2]
    lines = spark.read.text(input).rdd.map(lambda r: r[0])
    counts = lines.flatMap(lambda x: x.split(' ')) \
                    .map(lambda x: (x, 1)) \
                    .reduceByKey(add)
    counts.saveAsTextFile(output)
    spark.stop()

except Exception as e: 
    print(e)
    print ("Error occured! Exiting!")
    sys.exit(1)