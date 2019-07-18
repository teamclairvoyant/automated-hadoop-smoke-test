import sys, random;

def inside(p):
    x, y = random.random(), random.random()
    return x*x + y*y < 1


try:
    count = sc.parallelize(xrange(0, 10)) \
                .filter(inside).count()
    print ("Pi is roughly %f" % (4.0 * count / 10))
    sys.exit(0)
except:
    print('An error occured.')
    sys.exit(1)
