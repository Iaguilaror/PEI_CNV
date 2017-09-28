#!/bin/bash

source config.mk
NUMBER_OF_SAMPLES=$(shuf -i5-100 -n1)
NUMBER_OF_GENES=$(shuf -i3-10 -n1)

mkdir -p data/

find -L $DATA_DIR \
	-type f \
	-name "exon_orderedDepths.tsv" \
| sort -R \
| head -n$NUMBER_OF_SAMPLES \
> data/sample_paths

cat data/sample_paths  \
| xargs cat \
| cut -f3 \
| uniq \
| sort -u \
| sort -R \
| head -n$NUMBER_OF_GENES \
> data/genes_of_interest.txt
