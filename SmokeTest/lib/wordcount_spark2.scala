try {
  val args = spark.sqlContext.getAllConfs.get("spark.driver.args").get
  val args2 = spark.sqlContext.getAllConfs.get("spark.driver.args2").get

  println("input : " + args);
  println("output : " + args2);
  // val file = spark.read.textFile(args)
  val data = spark.read.text(args).as[String]
  val words = data.flatMap(value => value.split("\\s+"))
  val groupedWords = words.groupByKey(_.toLowerCase)
  val counts = groupedWords.count()
  counts.rdd.saveAsTextFile(args2)
  System.exit(0)
} catch {
  case e: Exception => { e.printStackTrace(); System.exit(1); }
}
