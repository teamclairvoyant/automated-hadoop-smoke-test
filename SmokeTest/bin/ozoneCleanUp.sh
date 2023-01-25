#!/bin/bash
# shellcheck disable=SC1091

source ./conf/SmokeConfig.config

ozone fs -rm -r -skipTrash "ofs://${OZONE_SERVICE_ID}/${OZONE_VOLUME}"
rm -f -r "$OZONE_TEMP_PATH"

