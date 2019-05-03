#!/bin/bash
source ./conf/SmokeConfig.config


ZOOKEEPER=$ZOOKEEPER
KAFKA=$KAFKA_PORT

#cd $KAFKA_LOC


$KAFKA_HOME/kafka-topics.sh  --zookeeper ${ZOOKEEPER} --create --topic $TOPIC_NAME --partitions 1 --replication-factor 1
rc=$?; if [[ $rc != 0 ]]; then echo "Can not create Topic! exiting";  echo " - Kafka	- Failed [Can not create Topic]" >> ./log/SummaryReport.txt; exit $rc; fi



echo "Here Starts the producer...!!! "
echo "Please enter data ... cntrl+c for exit"
$KAFKA_HOME/kafka-console-producer.sh --broker-list ${KAFKA} --topic $TOPIC_NAME
rc=$?; if [[ ($rc != 0) && ($rc != 130) ]]; then echo "Can not produce data! exiting";  echo " - Kafka	- Failed [Can not produce data]" >> ./log/SummaryReport.txt; exit $rc; fi


echo "Here Starts the Consuming...!!! "
echo "Check log for  Data... cntrl+c for exit"
$KAFKA_HOME/kafka-console-consumer.sh   --bootstrap-server ${KAFKA} --topic $TOPIC_NAME --from-beginning
rc=$?; if [[ ($rc != 0) && ($rc != 130) ]]; then echo "Can not consume data! exiting";  echo " - Kafka	- Failed [Can not consume data]" >> ./log/SummaryReport.txt; exit $rc; fi


echo "******************************************"
echo "* Kafka test completed Successfully! *"
echo "******************************************"

echo "- Kafka	- Passed " >> ./log/SummaryReport.txt
