import sys
import random
from pyspark import SparkConf, SparkContext

def inside(p):
    x = random.random()
    y = random.random() 
    return x*x + y*y < 1

try:
    conf = SparkConf().setAppName("pysparkTest-piEstimation")
    sc = SparkContext(conf=conf)

    count = sc.parallelize(xrange(0, 10)).filter(inside).count()
    print ("Pi is roughly %f" % (4.0 * count / 10))
    sc.stop()
    sys.exit(0)

except Exception as e: 
    print(e)
    print ("Error occured! Exiting!")
    sys.exit(1)