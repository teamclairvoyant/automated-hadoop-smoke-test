#!/bin/bash
source ./conf/SmokeConfig.config

#echo "ZOOKEEPER_QUORUM: $ZOOKEEPER_QUORUM"
#
#cat <<EOF >/tmp/zk.$$
#create /zk_test my_data
#ls /
#get /zk_test
#set /zk_test junk
#get /zk_test
#quit
#EOF
#
#cat /tmp/zk.$$ | zookeeper-client -server $ZOOKEEPER_QUORUM
#
#exit
echo "ZOOKEEPER_QUORUM: $ZOOKEEPER_QUORUM"
echo "ZOOKEEPER_QUORUM_PATH: $ZOOKEEPER_QUORUM_PATH"

export ZOO_LOG4J_PROP="ERROR,CONSOLE"

printf "ls /\n" | zookeeper-client -server "$ZOOKEEPER_QUORUM"
rc=$?
echo
if [[ $rc != 0 ]]; then
  echo "Error listing znodes in ZooKeeper! exiting"
  echo " - ZooKeeper    - Failed [Error listing znodes in ZooKeeper]" >> ./log/SummaryReport.txt
  exit $rc
fi

printf "create %s my_data\n" "$ZOOKEEPER_QUORUM_PATH" | zookeeper-client -server "$ZOOKEEPER_QUORUM"
rc=$?
echo
if [[ $rc != 0 ]]; then
  echo "Error creating znode in ZooKeeper! exiting"
  echo " - ZooKeeper    - Failed [Error creating znode in ZooKeeper]" >> ./log/SummaryReport.txt
  exit $rc
fi

printf "sync /\nget %s\n" "$ZOOKEEPER_QUORUM_PATH" | zookeeper-client -server "$ZOOKEEPER_QUORUM"
rc=$?
echo
if [[ $rc != 0 ]]; then
  echo "Error getting znode in ZooKeeper! exiting"
  echo " - ZooKeeper    - Failed [Error getting znode in ZooKeeper]" >> ./log/SummaryReport.txt
  exit $rc
fi

printf "set %s junk\n" "$ZOOKEEPER_QUORUM_PATH" | zookeeper-client -server "$ZOOKEEPER_QUORUM"
rc=$?
echo
if [[ $rc != 0 ]]; then
  echo "Error setting znode in ZooKeeper! exiting"
  echo " - ZooKeeper    - Failed [Error setting znode in ZooKeeper]" >> ./log/SummaryReport.txt
  exit $rc
fi

printf "sync /\nget %s\n" "$ZOOKEEPER_QUORUM_PATH" | zookeeper-client -server "$ZOOKEEPER_QUORUM"
rc=$?
echo
if [[ $rc != 0 ]]; then
  echo "Error getting updated znode in ZooKeeper! exiting"
  echo " - ZooKeeper    - Failed [Error getting updated znode in ZooKeeper]" >> ./log/SummaryReport.txt
  exit $rc
fi

echo "******************************************"
echo "* ZooKeeper test completed Successfully! *"
echo "******************************************"
echo " - ZooKeeper    - Passed" >> ./log/SummaryReport.txt

#echo "**************************"
#echo "* ZooKeeper test Failed! *"
#echo "**************************"
#echo " - ZooKeeper    - Failed" >> ./log/SummaryReport.txt

