#!/bin/bash

parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

cd "$parent_path"

source $parent_path/conf/SmokeConfig.config

timestamp=`date '+%Y%m%d%H%M%S'`

mkdir -p $LOG_PATH
touch $LOG_PATH/${timestamp}logs.log

sh ./bin/Main.sh | tee -a $LOG_PATH/${timestamp}logs.log 

cat ./log/SummaryReport.txt
mv ./log/SummaryReport.txt ./log/${timestamp}SummaryReport.txt