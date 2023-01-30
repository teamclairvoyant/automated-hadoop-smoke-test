#!/bin/bash
# shellcheck disable=SC1091
source ./conf/SmokeConfig.config

echo "OZONE_SERVICE_ID: $OZONE_SERVICE_ID"
echo "OZONE_VOLUME: $OZONE_VOLUME"
echo "OZONE_BUCKET: $OZONE_BUCKET"
echo "OZONE_LOC_PATH: $OZONE_LOC_PATH"
echo "OZONE_TEMP_PATH: $OZONE_TEMP_PATH"

# List buckets
# Create a volume
# Create a bucket
# Put a key
# Get a key
# Delete a key
# Delete a bucket
# Delete a volume

ozone fs -ls "ofs://${OZONE_SERVICE_ID}/"
rc=$?
if [[ $rc != 0 ]]; then
  echo "Error in showing buckets in Ozone! exiting"
  echo " - Ozone        - Failed [Error in showing buckets in Ozone]" >> "$LOG_PATH"/SummaryReport.txt
  exit $rc
fi

ozone fs -mkdir -p "ofs://${OZONE_SERVICE_ID}/${OZONE_VOLUME}/${OZONE_BUCKET}"
rc=$?
if [[ $rc != 0 ]]; then
  echo "Error in creating volume and bucket in Ozone! exiting"
  echo " - Ozone        - Failed [Error in creating volume and bucket in Ozone]" >> "$LOG_PATH"/SummaryReport.txt
  exit $rc
fi

ozone fs -put "$OZONE_LOC_PATH" "ofs://${OZONE_SERVICE_ID}/${OZONE_VOLUME}/${OZONE_BUCKET}/file"
rc=$?
if [[ $rc != 0 ]]; then
  echo "Error in copying file to Ozone! exiting"
  echo " - Ozone        - Failed [Error in copying file to Ozone]" >> "$LOG_PATH"/SummaryReport.txt
  exit $rc
fi

ozone fs -get "ofs://${OZONE_SERVICE_ID}/${OZONE_VOLUME}/${OZONE_BUCKET}/file" "$OZONE_TEMP_PATH"
rc=$?
if [[ $rc != 0 ]]; then
  echo "Error in copying file from Ozone! exiting"
  echo " - Ozone        - Failed [Error in copying file from Ozone]" >> "$LOG_PATH"/SummaryReport.txt
  exit $rc
fi

cat "$OZONE_TEMP_PATH"
rc=$?
if [[ $rc != 0 ]]; then
  echo "Error in showing copied file from Ozone! exiting"
  echo " - Ozone        - Failed [Error in showing copied file from Ozone]" >> "$LOG_PATH"/SummaryReport.txt
  exit $rc
fi

cmp "$OZONE_LOC_PATH" "$OZONE_TEMP_PATH"
status=$?
if [[ $status = 0 ]]; then
    echo "Files are the same"
    echo " - Ozone        - Passed" >> "$LOG_PATH"/SummaryReport.txt
    echo "***************************************"
    echo "* Ozone test completed Successfully ! *"
    echo "***************************************"
else
    echo "Files are different"
    echo " - Ozone        - Failed[Files are different]" >> "$LOG_PATH"/SummaryReport.txt
    echo "***********************"
    echo "* Ozone test Failed ! *"
    echo "***********************"
fi
