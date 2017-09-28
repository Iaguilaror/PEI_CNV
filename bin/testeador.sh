#!/bin/bash
set -x
MAIN_TEST_DATE=$(date +%c | tr " " "_" | tr ":" "-")
NUMERO_DE_PRUEBAS="50"

mkdir -p TEST
mkdir -p TEST/logs
mkdir -p TEST/results
mkdir -p TEST/tmp

for i in $(eval echo "{1..$NUMERO_DE_PRUEBAS}")	## needs eval to concatenate numbers into a sinlge value readable by command
do
	TEST_DATE=$(date +%c | tr " " "_" | tr ":" "-") \
	&& echo "[DEBUGGING] INICIO de prueba $i de $NUMERO_DE_PRUEBAS fechada en $TEST_DATE" \
	&& bin/sample_and_gene_randomizer.testing.sh \
	&& time mk all \
	&& mv results TEST/results/$TEST_DATE \
	&& mv tmp TEST/tmp/$TEST_DATE \
	&& echo "[DEBUGGING] FIN de prueba $i de $NUMERO_DE_PRUEBAS fechada en $TEST_DATE"
done 2>&1 | tee TEST/logs/MAIN_TEST_$MAIN_TEST_DATE
