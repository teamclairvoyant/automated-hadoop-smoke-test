#!/bin/bash

source ./conf/SmokeConfig.config


SOLRSERVER=$SOLRSERVER
SKOPTS=$SKOPTS
STPROTO=$STPROTO
STPORT=$STPORT
EXAMPLE_HOME_SOLR=$EXAMPLE_HOME_SOLR

solrctl instancedir --generate /tmp/solr.$$
rc=$?; if [[ $rc != 0 ]]; then echo "Instance directory generation failed! exiting"; echo " - Solr	-  Failed [Instance directory generation failed]" >> ./log/SummaryReport.txt; exit $rc; fi

solrctl instancedir --create test_config /tmp/solr.$$
rc=$?; if [[ $rc != 0 ]]; then echo "Config file creation failed! exiting"; echo " - Solr	-  Failed [Config file creation failed]" >> ./log/SummaryReport.txt; exit $rc; fi

solrctl collection --create $SOLR_COLLECTION_NAME -s 1 -c test_config
rc=$?; if [[ $rc != 0 ]]; then echo "Collection creation failed! exiting"; echo " - Solr	-  Failed [Collection creation failed]" >> ./log/SummaryReport.txt; exit $rc; fi

cd $EXAMPLE_HOME_SOLR/exampledocs
rc=$?; if [[ $rc != 0 ]]; then echo "Change dirctory command failed! exiting"; echo " - Solr	-  Failed [Change dirctory command failed]" >> ./log/SummaryReport.txt; exit $rc; fi



java -Durl=${STPROTO:-http}://${SOLRSERVER}:${STPORT:-8983}/solr/$SOLR_COLLECTION_NAME/update -jar post.jar *.xml
rc=$?; if [[ $rc != 0 ]]; then echo "durl command failed! exiting"; echo " - Solr	-  Failed [durl command failed]" >> ./log/SummaryReport.txt; exit $rc; fi


curl $SKOPTS "${STPROTO:-http}://${SOLRSERVER}:${STPORT:-8983}/solr/${SOLR_COLLECTION_NAME}_shard1_replica1/select?q=*%3A*&wt=json&indent=true"
rc=$?; if [[ $rc != 0 ]]; then echo "curl command failed! exiting"; echo " - Solr	-  Failed [curl command failed]" >> ./log/SummaryReport.txt; exit $rc; fi

echo ""
echo "***************************************"
echo "*  Solr test completed Successfully ! *"
echo "***************************************"

echo "- Solr	- Passed" >> ./log/SummaryReport.txt