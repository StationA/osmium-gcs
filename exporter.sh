#!/bin/sh

set -e
set -x

if [ "$#" -ne 2 ]; then
    echo "exporter <GCS_INPUT> <GCS_OUTPUT>"
    exit
fi

GCS_INPUT=$1
GCS_OUTPUT=$2

COMPRESS_OUTPUT=${COMPRESS_OUTPUT:-"0"}
INPUT_FILENAME=$(basename $GCS_INPUT)
OUTPUT_FILENAME=$(basename $GCS_OUTPUT)
INTER_FILENAME="buildings-$INPUT_FILENAME"

function cleanup {
    rm -f "$OUTPUT_FILENAME.gz"
    rm -f $OUTPUT_FILENAME
    rm -f $INTER_FILENAME
    rm -f $INPUT_FILENAME
}
trap cleanup EXIT

gsutil cp $GCS_INPUT $INPUT_FILENAME
osmium tags-filter -o $INTER_FILENAME $INPUT_FILENAME w/building
osmium export -ren -o $OUTPUT_FILENAME -f geojsonseq $INTER_FILENAME

if [ "$COMPRESS_OUTPUT" -eq "1" ]; then
    gzip $OUTPUT_FILENAME
    gsutil cp "$OUTPUT_FILENAME.gz" "$GCS_OUTPUT.gz"
else
    gsutil cp $OUTPUT_FILENAME $GCS_OUTPUT
fi
