#!/bin/bash

PARENT_PATH=$(dirname "$0")
cd "$PARENT_PATH" || exit
source conf/SmokeConfig.config

timestamp=$(date '+%Y%m%d%H%M%S')

mkdir -p "$LOG_PATH"
touch "$LOG_PATH"/"$timestamp"logs.log

bash bin/Main.sh 2>&1 | tee -a "$LOG_PATH"/"$timestamp"logs.log

cat ./log/SummaryReport.txt
mv ./log/SummaryReport.txt ./log/"$timestamp"SummaryReport.txt
