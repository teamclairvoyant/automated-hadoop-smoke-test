#!/bin/bash
source /home/murshida/KitePharma_SmokeTest/HDP_SEC/conf/SmokeConfig.config


ZOOKEEPER=$ZOOKEEPER
KAFKA=$KAFKA

cd $KAFKA_LOC
echo "Creating Topic"
$KAFKA_HOME/kafka-topics.sh  --zookeeper ${ZOOKEEPER} --create --topic $TOPIC_NAME --partitions 1 --replication-factor 1 >> $LOG_PATH
echo "Here Starts the producer...!!! "
echo "Please enter data ... cntrl+c for exit"
$KAFKA_HOME/kafka-console-producer.sh --broker-list ${KAFKA} --producer.config $KAFKA_CONFIG/kafka.properties  --topic $TOPIC_NAME >> $LOG_PATH

echo "Here Starts the Consuming...!!! "
echo " Check log for Data... cntrl+c for exit"
$KAFKA_HOME/kafka-console-consumer.sh   --bootstrap-server ${KAFKA} --consumer.config $KAFKA_CONFIG/kafka.properties  --topic $TOPIC_NAME --from-beginning >> $LOG_PATH