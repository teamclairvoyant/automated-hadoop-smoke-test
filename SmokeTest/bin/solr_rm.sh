#!/bin/bash

source ./conf/SmokeConfig.config

solrctl collection --delete $SOLR_COLLECTION_NAME
rc=$?; if [[ $rc != 0 ]]; then echo "error! exiting"; exit $rc; fi

solrctl instancedir --delete test_config
rc=$?; if [[ $rc != 0 ]]; then echo "error! exiting"; exit $rc; fi

rm -rf /tmp/test_config.$$
rc=$?; if [[ $rc != 0 ]]; then echo "error! exiting"; exit $rc; fi

