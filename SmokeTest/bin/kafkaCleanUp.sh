#!/bin/bash
source ./conf/SmokeConfig.config

echo "TOPIC_NAME: $TOPIC_NAME"
echo "KAFKA_OUP_LOC: $KAFKA_OUP_LOC"

#kafka-topics --zookeeper "${ZOOKEEPER}${ZOOKEEPER_ROOT}" --delete --topic "$TOPIC_NAME"
kafka-topics --bootstrap-server "$KAFKA_HOST" --delete --topic "$TOPIC_NAME"
rm -r -f "$KAFKA_OUP_LOC"

