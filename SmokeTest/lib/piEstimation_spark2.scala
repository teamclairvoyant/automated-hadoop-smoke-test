// not working
try {
  val count = spark
    .sparkContext
    .parallelize(1 to 10)
    .filter { _ =>
      val x = math.random
      val y = math.random
      x * x + y * y < 1
    }
    .count()
  println(s"Pi is roughly ${4.0 * count / 10}")
  System.exit(0)
} catch {
  case e: Exception => { e.printStackTrace(); System.exit(1); }
}
