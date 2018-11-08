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
gsutil cp $OUTPUT_FILENAME $GCS_OUTPUT

rm $INPUT_FILENAME $OUTPUT_FILENAME
