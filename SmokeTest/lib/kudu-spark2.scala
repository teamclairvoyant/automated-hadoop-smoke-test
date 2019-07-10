import org.apache.kudu.spark.kudu._
import org.apache.kudu.client._
import collection.JavaConverters._
import org.apache.kudu.spark.kudu.KuduContext

try {
  val args = sc.getConf.get("spark.driver.args").split("\\s+")
  val kudu_master_host = args(0)
  val kudu_table_name = args(1)

  val kuduContext = new KuduContext(kudu_master_host, spark.sparkContext)

  if (kuduContext.tableExists(kudu_table_name)) {
    kuduContext.deleteTable(kudu_table_name)
  }

  val df_create =
    Seq((1, "bat"), (2, "mouse"), (3, "horse")).toDF("number", "word")

  println("Creating Table!")
  kuduContext.createTable(kudu_table_name,
                          df_create.schema,
                          Seq("number"),
                          new CreateTableOptions()
                            .setNumReplicas(1)
                            .addHashPartitions(List("number").asJava, 3))

  println("Table Exists: " + kuduContext.tableExists(kudu_table_name))

  if (kuduContext.tableExists(kudu_table_name) == false) {
    println("Error creating table! Exiting!")
    System.exit(1)
  }

  kuduContext.insertRows(df_create, kudu_table_name)

  val df_read = spark.sqlContext.read
    .options(
      Map("kudu.master" -> kuduContext.kuduMaster,
          "kudu.table" -> kudu_table_name))
    .kudu
  df_read.show()

  println(df_read.count())
  if (df_read.count() != 3) {
    println("Error inserting rows in the table! Exiting!")
    System.exit(1)
  }

  println("Deleting Table!")
  kuduContext.deleteTable(kudu_table_name)

  println("Table Exists: " + kuduContext.tableExists(kudu_table_name))
  if (kuduContext.tableExists(kudu_table_name) == true) {
    println("Error deleting table! Exiting!")
    System.exit(1)
  }

  System.exit(0)
} catch {
  case e: Exception => { e.printStackTrace(); System.exit(1); }
}
