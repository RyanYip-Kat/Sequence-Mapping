genrich="/home/ye/Work/BioAligment/totalATAC/Genrich/Genrich"
root="/home/ye/Work/BioAligment/totalATAC/aligned"
samtool="/home/ye/anaconda3/envs/BioAlignment/bin/samtools"

for path in `ls $root`;
do
	infile=$root/$path/Aligned.out.bam
	echo "Input file is : $infile"
	$samtool sort -n $infile -o $root/$path/Align.sortedname.bam --threads 4
	sortfile=$root/$path/Align.sortedname.bam
	echo "Input file(sort) is : $sortfile"
	outfile=$root/$path/Aligned.out.narrowPeak 
	echo "Output file is : $outfile"
	ishfile=$root/$path/bedgraph.log
	echo "Output bedgraph-ish file for p/q values is : $ishfile"
	pileups=$root/$path/pileups.log
	echo "Output bedgraph-ish file for pileups and p-values : $pileups"
        bedfile=$root/$path/Aligned.out.bed
	echo "Output BED file for reads/fragments/intervals : $bedfile"
	$genrich -t $sortfile  -o $outfile -f $ishfile -b $bedfile -k $pileups -j -r -v 
done
