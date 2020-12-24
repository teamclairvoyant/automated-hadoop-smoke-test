#!/bin/bash
source ./conf/SmokeConfig.config

echo "ZOOKEEPER: $ZOOKEEPER"
echo "ZOOKEEPER_ROOT: $ZOOKEEPER_ROOT"
echo "KAFKA_HOST: $KAFKA_HOST"
echo "TOPIC_NAME: $TOPIC_NAME"
echo "KAFKA_INP_LOC: $KAFKA_INP_LOC"
echo "KAFKA_OUP_LOC: $KAFKA_OUP_LOC"

kafka-topics  --zookeeper "${ZOOKEEPER}${ZOOKEEPER_ROOT}" --create --topic "$TOPIC_NAME" --partitions 1 --replication-factor 1
rc=$?; if [[ $rc != 0 ]]; then echo "Cannot create Topic! exiting";  echo " - Kafka	- Failed [Cannot create Topic]" >> ./log/SummaryReport.txt; exit $rc; fi

echo "Here Starts the producer...!!! "
echo "$KAFKA_OUP_LOC" "$KAFKA_INP_LOC"

echo "Please enter data ... cntrl+c for exit"

kafka-console-producer --broker-list "$KAFKA_HOST" --topic "$TOPIC_NAME" < "$KAFKA_INP_LOC"
rc=$?;echo "exitcode: $rc"; if [[ ($rc != 0) && ($rc != 130) ]]; then echo "Cannot produce data! exiting";  echo " - Kafka		- Failed [Cannot produce data]" >> ./log/SummaryReport.txt; exit $rc; fi

echo "Here Starts the Consuming...!!! "
echo "Check log for  Data... cntrl+c for exit"

kafka-console-consumer --bootstrap-server "$KAFKA_HOST" --topic "$TOPIC_NAME" --from-beginning > "$KAFKA_OUP_LOC"
rc=$?; if [[ ($rc != 0) && ($rc != 130) ]]; then echo "Cannot consume data! exiting";  echo " - Kafka		- Failed [Cannot consume data]" >> ./log/SummaryReport.txt; exit $rc; fi

if grep -f "$KAFKA_OUP_LOC" "$KAFKA_INP_LOC"
then
	echo "same data as produced"
	echo "******************************************"
	echo "* Kafka test completed Successfully! *"
	echo "******************************************"
	echo " - Kafka		- Passed " >> ./log/SummaryReport.txt
else
	echo "Not same data as produced"
	echo "******************************************"
	echo "* Kafka test completed Successfully! *"
	echo "******************************************"
	echo " - Kafka		- Failed [Not Consuming produced data] " >> ./log/SummaryReport.txt
fi
