#!/bin/bash

source ./conf/SmokeConfig.config

solrctl instancedir --generate /tmp/solr.$$
rc=$?; if [[ $rc != 0 ]]; then echo "Instance directory generation failed! exiting"; echo " - Solr		- Failed [Instance directory generation failed]" >> ./log/${timestamp}SummaryReport.txt; exit $rc; fi

solrctl instancedir --create test_config /tmp/solr.$$
rc=$?; if [[ $rc != 0 ]]; then echo "Config file creation failed! exiting"; echo " - Solr		- Failed [Config file creation failed]" >> ./log/${timestamp}SummaryReport.txt; exit $rc; fi

solrctl collection --create $SOLR_COLLECTION_NAME -s 1 -c test_config
rc=$?; if [[ $rc != 0 ]]; then echo "Collection creation failed! exiting"; echo " - Solr		- Failed [Collection creation failed]" >> ./log/${timestamp}SummaryReport.txt; exit $rc; fi

java -Durl=${STPROTO:-http}://${SOLRSERVER}/solr/$SOLR_COLLECTION_NAME/update -jar $SOLR_EXAMPLE_HOME/exampledocs/post.jar $SOLR_EXAMPLE_HOME/exampledocs/*.xml
rc=$?; if [[ $rc != 0 ]]; then echo "durl command failed! exiting"; echo " - Solr		-  Failed [durl command failed]" >> ./log/${timestamp}SummaryReport.txt; exit $rc; fi

curl $SKOPTS "${STPROTO:-http}://${SOLRSERVER}/solr/${SOLR_COLLECTION_NAME}_shard1_replica1/select?q=*%3A*&wt=json&indent=true"
rc=$?; if [[ $rc != 0 ]]; then echo "curl command failed! exiting"; echo " - Solr		-  Failed [curl command failed]" >> ./log/${timestamp}SummaryReport.txt; exit $rc; fi

echo ""
echo "***************************************"
echo "*  Solr test completed Successfully ! *"
echo "***************************************"

echo " - Solr		- Passed" >> ./log/${timestamp}SummaryReport.txt