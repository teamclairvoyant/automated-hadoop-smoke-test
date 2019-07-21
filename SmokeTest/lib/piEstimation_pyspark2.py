import sys
import random
from pyspark.sql.session import SparkSession

def inside(p):
    x = random.random()
    y = random.random() 
    return x*x + y*y < 1

try:
    spark = SparkSession.builder.appName("pysparkTest2").getOrCreate()

    count = spark.parallelize(xrange(0, 10)).filter(inside).count()
    print ("Pi is roughly %f" % (4.0 * count / 10))
    sys.exit(0)

except Exception as e: 
    print(e)
    print ("Error occured! Exiting!")
    sys.exit(1)