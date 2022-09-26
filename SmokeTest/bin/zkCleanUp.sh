#!/bin/bash
source ./conf/SmokeConfig.config

echo "ZOOKEEPER: $ZOOKEEPER"
echo "ZOOKEEPER_PATH: $ZOOKEEPER_PATH"

#cat <<EOF >/tmp/zk-rm.$$
#delete /zk_test
#quit
#EOF
#cat /tmp/zk-rm.$$ | zookeeper-client -server $ZOOKEEPER
#rm -f /tmp/zk.$$ /tmp/zk-rm.$$

export ZOO_LOG4J_PROP="ERROR,CONSOLE"

printf "sync\ndelete %s\n" "$ZOOKEEPER_PATH" | zookeeper-client -server "$ZOOKEEPER"
rc=$?
echo
if [[ $rc != 0 ]]; then
  echo "Error in deleting znode in ZooKeeper!"
  #echo "Error in deleting znode in ZooKeeper! exiting"
  #echo " - ZooKeeper    - Failed [Error in deleting znode in ZooKeeper]" >> ./log/SummaryReport.txt
  #exit $rc
fi

