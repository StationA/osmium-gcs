#!/bin/sh

set -x

if [ "$#" -ne 2 ]; then
    echo "exporter <GCS_INPUT> <GCS_OUTPUT>"
    exit
fi

GCS_INPUT=$1
GCS_OUTPUT=$2

INPUT_FILENAME=$(basename $GCS_INPUT)
OUTPUT_FILENAME=$(basename $GCS_OUTPUT)

gsutil cp $GCS_INPUT $INPUT_FILENAME
osmium export -ren -o $OUTPUT_FILENAME -f geojsonseq $INPUT_FILENAME

if [ "$COMPRESS_OUTPUT" -eq "1" ]; then
    gzip $OUTPUT_FILENAME
    gsutil cp "$OUTPUT_FILENAME.gz" "$GCS_OUTPUT.gz"
    rm "$OUTPUT_FILENAME.gz"
else
    gsutil cp $OUTPUT_FILENAME $GCS_OUTPUT
    rm $OUTPUT_FILENAME
fi

rm $INPUT_FILENAME
