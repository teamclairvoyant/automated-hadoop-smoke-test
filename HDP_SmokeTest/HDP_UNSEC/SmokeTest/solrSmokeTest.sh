#!/bin/bash

source /mnt/SmokeTest/SmokeConfig.config



cd $SOLR_HOME
./solr create -c $SOLR_COLLECTION_NAME -s 1 -rf 1 -force
echo "Created collection $SOLR_COLLECTION_NAME " >> $LOG_PATH
cd $EXAMPLE_HOME_SOLR/exampledocs
java -Durl=$SOLR_SERVER/$SOLR_COLLECTION_NAME/update -jar post.jar money.xml
echo "Finished $SOLR_COLLECTION_NAME collection update" >> $LOG_PATH
curl "$SOLR_SERVER/$SOLR_COLLECTION_NAME/select?q=*:*"
echo "Printed curl commands for $SOLR_COLLECTION_NAME" >> $LOG_PATH

cd $SCRIPT_HOME
