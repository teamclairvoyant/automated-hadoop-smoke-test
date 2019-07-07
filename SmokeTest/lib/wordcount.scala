val args = sc.getConf.get("spark.driver.args").split("\\s+")
println("input : "+args(0));
println("output : "+args(1));
val file = sc.textFile(args(0))
val counts = file.flatMap(line => line.split(" ")).map(word => (word,1)).reduceByKey(_ + _)
counts.saveAsTextFile(args(1))
sys.exit
