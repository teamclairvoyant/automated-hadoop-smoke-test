#!/bin/bash
#set -x

source ./conf/SmokeConfig.config

echo "SOLR_SERVER: $SOLR_SERVER"
#echo "SOLR_OPS: $SOLR_OPS"
echo "SOLR_CURL_OPS: $SOLR_CURL_OPS"
echo "SOLR_SSL_ENABLED: $SOLR_SSL_ENABLED"
echo "SOLR_EXAMPLE_HOME: $SOLR_EXAMPLE_HOME"
echo "SOLR_COLLECTION_NAME: $SOLR_COLLECTION_NAME"
echo "SOLR_INSTANTDIR_NAME: $SOLR_INSTANTDIR_NAME"

SOLR_PROTOCOL="http"
if $SOLR_SSL_ENABLED; then
    SOLR_PROTOCOL="https"
fi
echo "SOLR_PROTOCOL: $SOLR_PROTOCOL"

solrctl instancedir --generate /tmp/solr.$$
rc=$?; if [[ $rc != 0 ]]; then echo "Instance directory generation failed! exiting"; echo " - Solr         - Failed [Instance directory generation failed]" >> ./log/SummaryReport.txt; exit $rc; fi

solrctl instancedir --create "$SOLR_INSTANTDIR_NAME" /tmp/solr.$$
rc=$?; if [[ $rc != 0 ]]; then echo "Config file creation failed! exiting"; echo " - Solr         - Failed [Config file creation failed]" >> ./log/SummaryReport.txt; exit $rc; fi
#solrctl instancedir --list | grep "^${SOLR_INSTANTDIR_NAME}$"

solrctl collection --create "$SOLR_COLLECTION_NAME" -s 1 -c "$SOLR_INSTANTDIR_NAME"
rc=$?; if [[ $rc != 0 ]]; then echo "Collection creation failed! exiting"; echo " - Solr         - Failed [Collection creation failed]" >> ./log/SummaryReport.txt; exit $rc; fi
#solrctl collection --list | grep "^${SOLR_COLLECTION_NAME} "

echo "* Uploading data..."
# shellcheck disable=SC2086
#java $SOLR_OPS -Durl="${SOLR_PROTOCOL}"://"$SOLR_SERVER"/solr/"$SOLR_COLLECTION_NAME"/update -jar ${SOLR_EXAMPLE_HOME}/exampledocs/post.jar ${SOLR_EXAMPLE_HOME}/exampledocs/*.xml
#/opt/cloudera/parcels/CDH/lib/solr/bin/post -url "${SOLR_PROTOCOL}"://"$SOLR_SERVER"/solr/"$SOLR_COLLECTION_NAME"/update ${SOLR_EXAMPLE_HOME}/exampledocs/*.xml
#rc=$?; if [[ $rc != 0 ]]; then echo "java command failed! exiting"; echo " - Solr         -  Failed [java command failed]" >> ./log/SummaryReport.txt; exit $rc; fi
#curl -s $SOLR_CURL_OPS "${SOLR_PROTOCOL}://${SOLR_SERVER}/solr/${SOLR_COLLECTION_NAME}/update?commit=true" -H "Content-Type: application/xml" --data-binary @${SOLR_EXAMPLE_HOME}/exampledocs/*.xml
curl -s $SOLR_CURL_OPS "${SOLR_PROTOCOL}://${SOLR_SERVER}/solr/${SOLR_COLLECTION_NAME}/update?commit=true" -H "Content-Type: text/csv" --data-binary "@$(eval echo "${SOLR_EXAMPLE_HOME}/exampledocs/books.csv")"
rc=$?; if [[ $rc != 0 ]]; then echo "curl upload command failed! exiting"; echo " - Solr         -  Failed [curl upload command failed]" >> ./log/SummaryReport.txt; exit $rc; fi

echo "* Querying..."
# shellcheck disable=SC2086
#curl -s $SOLR_CURL_OPS "${SOLR_PROTOCOL}://${SOLR_SERVER}/solr/${SOLR_COLLECTION_NAME}/get?id=0812550706"
curl -s $SOLR_CURL_OPS "${SOLR_PROTOCOL}://${SOLR_SERVER}/solr/${SOLR_COLLECTION_NAME}/query?q=series_t:Chronicles&fl=name,author"
#curl -s $SOLR_CURL_OPS "${SOLR_PROTOCOL}://${SOLR_SERVER}/solr/${SOLR_COLLECTION_NAME}/select?q=*%3A*&wt=json&indent=true"
rc=$?; if [[ $rc != 0 ]]; then echo "curl query command failed! exiting"; echo " - Solr         -  Failed [curl query command failed]" >> ./log/SummaryReport.txt; exit $rc; fi

echo ""
echo "*************************************"
echo "* Solr test completed Successfully! *"
echo "*************************************"

echo " - Solr         - Passed" >> ./log/SummaryReport.txt
