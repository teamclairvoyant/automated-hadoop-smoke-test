#!/bin/bash

PARENT_PATH=$(dirname "$0")
cd "$PARENT_PATH" || exit
source conf/SmokeConfig.config

timestamp=$(date '+%Y%m%d%H%M%S')

mkdir -p "$LOG_PATH"
touch "$LOG_PATH"/"$timestamp"logs.log

bash bin/Main.sh 2>&1 | tee -a "$LOG_PATH"/"$timestamp"logs.log

cat "$LOG_PATH"/SummaryReport.txt
mv "$LOG_PATH"/SummaryReport.txt "$LOG_PATH"/"$timestamp"SummaryReport.txt

