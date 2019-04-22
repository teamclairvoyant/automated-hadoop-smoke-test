#!/bin/bash
source /mnt/SmokeTest/SmokeConfig.config


ZOOKEEPER=$ZOOKEEPER
KAFKA=$KAFKA

cd $KAFKA_LOC


$KAFKA_HOME/kafka-topics.sh  --zookeeper ${ZOOKEEPER} --create --topic $TOPIC_NAME --partitions 1 --replication-factor 1 >> $LOG_PATH
echo "Here Starts the producer...!!! "
echo "Please enter data ... cntrl+c for exit"
$KAFKA_HOME/kafka-console-producer.sh --broker-list ${KAFKA} --topic $TOPIC_NAME >> $LOG_PATH

echo "Here Starts the Consuming...!!! "
echo "Check log for  Data... cntrl+c for exit"
$KAFKA_HOME/kafka-console-consumer.sh   --bootstrap-server ${KAFKA} --topic $TOPIC_NAME --from-beginning >> $LOG_PATH