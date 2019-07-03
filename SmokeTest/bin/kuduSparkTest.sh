#!/bin/bash
source ./conf/SmokeConfig.config

echo "KUDU_MASTER: $KUDU_MASTER"
echo "KUDU_SPARK2_JAR: $KUDU_SPARK2_JAR"

cat <<EOF >/tmp/kudu-spark2.scala.$$
import org.apache.kudu.spark.kudu._
import org.apache.kudu.client._
import collection.JavaConverters._
import org.apache.kudu.spark.kudu.KuduContext

val kudu_master_host = "$KUDU_MASTER"
val kuduContext = new KuduContext(kudu_master_host, spark.sparkContext)

if (kuduContext.tableExists("test_table"))
{
    kuduContext.deleteTable("test_table")
}

val df_create = Seq( (1, "bat"), (2, "mouse"), (3, "horse") ).toDF("number", "word")

kuduContext.createTable(
    "test_table", df_create.schema, Seq("number"),
    new CreateTableOptions()
        .setNumReplicas(1)
        .addHashPartitions(List("number").asJava, 3))

kuduContext.insertRows(df_create, "test_table")

val df_read = spark.sqlContext.read.options(Map("kudu.master" -> kuduContext.kuduMaster,"kudu.table" -> "test_table")).kudu
df_read.show()

println("Table Exists: " + kuduContext.tableExists("test_table"))

println("Deleting Table!")
kuduContext.deleteTable("test_table")

println("Table Exists: " + kuduContext.tableExists("test_table"))
EOF

cat /tmp/kudu-spark2.scala.$$ | spark2-shell --master yarn --jars $KUDU_SPARK2_JAR
rc=$?; if [[ $rc != 0 ]]; then echo "Something went wrong! Exiting!";  echo " - Kudu-Spark2	- Failed [Error]" >> ./log/SummaryReport.txt; exit $rc; fi

echo "***************************************"
echo "*  Kudu-Spark2 test completed Successfully!  *"
echo "***************************************"

echo " - Kudu-Spark2		- Passed" >> ./log/SummaryReport.txt