import org.apache.kudu.spark.kudu._
import org.apache.kudu.client._
import collection.JavaConverters._
import org.apache.kudu.spark.kudu.KuduContext

val args = sc.getConf.get("spark.driver.args").split("\\s+")
val kudu_master_host = args(0)
val kudu_table_name = args(1)

val kuduContext = new KuduContext(kudu_master_host, spark.sparkContext)

if (kuduContext.tableExists(kudu_table_name))
{
    kuduContext.deleteTable(kudu_table_name)
}

val df_create = Seq( (1, "bat"), (2, "mouse"), (3, "horse") ).toDF("number", "word")

kuduContext.createTable(
    kudu_table_name, df_create.schema, Seq("number"),
    new CreateTableOptions()
        .setNumReplicas(1)
        .addHashPartitions(List("number").asJava, 3))

kuduContext.insertRows(df_create, kudu_table_name)

val df_read = spark.sqlContext.read.options(Map("kudu.master" -> kuduContext.kuduMaster,"kudu.table" -> kudu_table_name)).kudu
df_read.show()

println("Table Exists: " + kuduContext.tableExists(kudu_table_name))

println("Deleting Table!")
kuduContext.deleteTable(kudu_table_name)

println("Table Exists: " + kuduContext.tableExists(kudu_table_name))

sys.exit