#!/bin/bash
source ./conf/SmokeConfig.config

echo "NIFI_HOST: $NIFI_HOST"
echo "HADOOP_CORE_SITE_PATH: $HADOOP_CORE_SITE_PATH"
echo "HADOOP_HDFS_SITE_PATH: $HADOOP_HDFS_SITE_PATH"
echo "TEMP_HDFS_DIRECTORY: $TEMP_HDFS_DIRECTORY"

sed -e "s|<value>\$TEMP_HDFS_DIRECTORY</value>|<value>${TEMP_HDFS_DIRECTORY}</value>|" ./lib/VarSmokeTest.xml > SmokeTest.xml
sed -i -e "s|<value>\$HADOOP_CORE_SITE_PATH,\$HADOOP_HDFS_SITE_PATH</value>|<value>${HADOOP_CORE_SITE_PATH},${HADOOP_HDFS_SITE_PATH}</value>|" SmokeTest.xml

rc=$?; if [[ $rc != 0 ]]; then echo "Unable to create temporary Nifi template! Exiting!";  echo " - Nifi	- Failed [Unable to instantiate template]" >> ./log/SummaryReport.txt; exit $rc; fi

# Retrieve Root Process ID
mainProcessID=$(curl -s http://"$NIFI_HOST"/nifi-api/flow/process-groups/root/status?recursive=true |
    python -c "import sys, json; print (json.load(sys.stdin)['processGroupStatus']['id'])")

curl -X POST -H 'Content-Type: application/json' -d '{"revision":{"version":0},"component":{"name":"SmokeTestGroup","position":{"x":0,"y":0}}}' http://"$NIFI_HOST"/nifi-api/process-groups/"$mainProcessID"/process-groups
rc=$?; if [[ $rc != 0 ]]; then echo "Unable to create new process group! Exiting!";  echo " - Nifi	    - Failed [Unable to instantiate template]" >> ./log/SummaryReport.txt; exit $rc; fi

# Retrieve Process ID for newly created Process Group "SmokeTestGroup"
processID=$(python <<EOF
import sys, json, urllib;
obj = json.loads(urllib.urlopen('http://$NIFI_HOST/nifi-api/process-groups/$mainProcessID/process-groups').read().decode("utf-8"))
for x in obj['processGroups']:
    if (x['component']['name'] == "SmokeTestGroup"):
        print (x['component']['id']);
        break;

EOF
)

# Template Upload
curl -k -F template=@SmokeTest.xml -X POST http://"$NIFI_HOST"/nifi-api/process-groups/"$processID"/templates/upload
rc=$?; if [[ $rc != 0 ]]; then echo "Unable to upload template to Nifi! Exiting!";  echo " - Nifi	    - Failed [Unable to upload template to Nifi]" >> ./log/SummaryReport.txt; exit $rc; fi

# Retrieve template ID
templateID=$(
    python <<EOF
import sys, json, urllib; 
obj = json.loads(urllib.urlopen('http://$NIFI_HOST/nifi-api/flow/templates').read().decode("utf-8"))
for x in obj['templates']:
    if (x['template']['name'] == "SmokeTest"):
        print (x['template']['id']);
        break;
EOF
)

# Template Instantiate
curl -H 'Content-Type:application/json' -d '{"originX":"0","originY":"0","templateId":"'"$templateID"'"}' -X POST http://"$NIFI_HOST"/nifi-api/process-groups/"$processID"/template-instance
rc=$?; if [[ $rc != 0 ]]; then echo "Unable to instantiate template! Exiting!";  echo " - Nifi	    - Failed [Unable to instantiate template]" >> ./log/SummaryReport.txt; exit $rc; fi

# Start Process
curl -i -X PUT -H 'Content-Type: application/json' -d '{"state":"RUNNING","id":"'"$processID"'"}' http://"$NIFI_HOST"/nifi-api/flow/process-groups/"$processID"
rc=$?; if [[ $rc != 0 ]]; then echo "Unable to start the process! Exiting!";  echo " - Nifi	    - Failed [Unable to start the process]" >> ./log/SummaryReport.txt; exit $rc; fi

sleep 10s

# Stop Process
curl -i -X PUT -H 'Content-Type: application/json' -d '{"state":"STOPPED","id":"'"$processID"'"}' http://"$NIFI_HOST"/nifi-api/flow/process-groups/"$processID"
rc=$?; if [[ $rc != 0 ]]; then echo "Unable to stop the process! Exiting!";  echo " - Nifi	    - Failed [Unable to stop the process]" >> ./log/SummaryReport.txt; exit $rc; fi

sleep 5s

hadoop fs -ls "$TEMP_HDFS_DIRECTORY"

# Clear and drop queue
compID=$(curl -X GET http://"$NIFI_HOST"/nifi-api/process-groups/"$processID"/connections |
    python -c "import sys, json; print (json.load(sys.stdin)['connections'][0]['component']['id'])")

compVersion=$(curl -X GET http://"$NIFI_HOST"/nifi-api/process-groups/"$processID"/connections |
    python -c "import sys, json; print (json.load(sys.stdin)['connections'][0]['revision']['version'])")

curl -i -X POST http://"$NIFI_HOST"/nifi-api/flowfile-queues/"$compID"/drop-requests
rc=$?; if [[ $rc != 0 ]]; then echo "Failed to post queue drop request! Exiting!";  echo " - Nifi	    - Failed [Failed to post drop request]" >> ./log/SummaryReport.txt; exit $rc; fi

sleep 5s

curl -i -X DELETE http://"$NIFI_HOST"/nifi-api/connections/"$compID"?version="$compVersion"
rc=$?; if [[ $rc != 0 ]]; then echo "Connection couldn't be dropped! Exiting!";  echo " - Nifi	    - Failed [Connection couldn't be dropped]" >> ./log/SummaryReport.txt; exit $rc; fi

# Delete template
curl -X DELETE http://"$NIFI_HOST"/nifi-api/templates/"$templateID"
rc=$?; if [[ $rc != 0 ]]; then echo "Unable to stop the process! Exiting!";  echo " - Nifi	    - Failed [Template couldn't be deleted from Nifi]" >> ./log/SummaryReport.txt; exit $rc; fi

processVersion=$(python <<EOF
import sys, json, urllib; 
obj = json.loads(urllib.urlopen('http://$NIFI_HOST/nifi-api/process-groups/$mainProcessID/process-groups').read().decode("utf-8"))
for x in obj['processGroups']:
    if (x['component']['name'] == "SmokeTestGroup"):
        print (x['revision']['version']);
        break;
EOF
)

# Delete the process group
curl -X DELETE http://"$NIFI_HOST"/nifi-api/process-groups/"$processID"?version="$processVersion"
rc=$?; if [[ $rc != 0 ]]; then echo "Process group couldn't be deleted! Exiting!";  echo " - Nifi	- Failed [Process group couldn't be deleted]" >> ./log/SummaryReport.txt; exit $rc; fi

echo "***************************************"
echo "*  Nifi test completed Successfully!  *"
echo "***************************************"

echo " - Nifi		- Passed" >> ./log/SummaryReport.txt