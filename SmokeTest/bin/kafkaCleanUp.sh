#!/bin/bash
source ./conf/SmokeConfig.config

echo "TOPIC_NAME: $TOPIC_NAME"

rm -r -f "$KAFKA_OUP_LOC"
export KAFKA_OPTS="-Dlog4j.configuration=file:./conf/tools-log4j.properties $KAFKA_OPTS"
#export KAFKA_OPTS="-Djava.security.auth.login.config=./conf/jaas-client.conf $KAFKA_OPTS"

_KAFKA_TOPIC_OPTS="--command-config=./conf/kafka.conf-${KAFKA_SECURITY_TYPE}"

#kafka-topics  --zookeeper "$KAFKA_ZOOKEEPER_QUORUM" --delete --topic "$TOPIC_NAME"
kafka-topics "$_KAFKA_TOPIC_OPTS" --bootstrap-server "$KAFKA_HOST" --delete --topic "$TOPIC_NAME"
rc=$?
if [[ $rc != 0 ]]; then
  echo "Cannot delete Topic! exiting"
  echo " - Kafka        - Failed [Cannot delete Topic]" >> "$LOG_PATH"/SummaryReport.txt
  exit $rc
fi

echo "Kafka ${TOPIC_NAME} topic removed !"

