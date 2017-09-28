< config.mk

all:QV:
	bin/targets | xargs mk

results/%.png:Q: tmp/%.dataframe
	mkdir -p $(dirname $target)
	echo "[DEBUGGING] generating Depht by exon Graphics for $target"
	Rscript bin/boxplot_generator.R $prereq $target.build \
	&& mv $target.build $target \
	&& rm Rplots.pdf

tmp/%.dataframe:Q: tmp/Panel_index
	mkdir -p $(dirname $target)
	echo "[DEBUGGING] generating temporary dir for $target"
	echo "GENE	SAMPLE	EXON	MEAN_DEPTH	TOTAL_READS_IN_BAM"	> $target.build
	cut -f1 $prereq | tail -n+2 > tmp/filtered_paths
	while read p
	do
		SAMPLE=$(echo $p | cut -d"/" -f6,7)
		TOTAL_READS_IN_BAM=$(grep $p tmp/Panel_index | cut -f4)
		grep $stem $p/exon_orderedDepths.tsv | awk -v SAMP="$SAMPLE" -v READS="$TOTAL_READS_IN_BAM" '{print $3,SAMP,$1":"$2":"$4,$5,READS}' >> $target.build
	done < tmp/filtered_paths \
	&& mv $target.build $target

tmp/Panel_index:Q: data/sample_paths
	mkdir -p $(dirname $target)
	echo "[DEBUGGING] creating panel index for $target"
	echo "PATH_TO_FILE	PANEL	INTERVALS	TOTAL_READS_IN_BAM" > $target.build \
	&& while read p
	do
		echo "processing $p"
		PATH_TO_FILE=$(dirname $p)
		PANEL=$(echo $p | cut -d"/" -f6 | cut -d"-" -f2)
		INTERVALS=$(wc -l $p)
		TOTAL_READS_IN_BAM=$(samtools view -c $PATH_TO_FILE/aln_recaled2.bam)
		echo "$PATH_TO_FILE	$PANEL	$INTERVALS	$TOTAL_READS_IN_BAM" >> $target.build
        done < $prereq \
        && mv $target.build $target
