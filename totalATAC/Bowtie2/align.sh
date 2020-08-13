root=$1 #  fastq root
bowtie="/home/ye/anaconda3/envs/BioAlignment/bin/bowtie2"
index="/home/ye/Data/totalRNA_ref/human/index/Bowtie2/hg38/index"
output=$2    # output file : /home/ye/Data/Zoc/Cell/reference/data/qc/star/align

if [ -f $output ];
then 
	echo "$output exists"
else
	mkdir -p $output
fi

for path in `ls $root`
do
	fqpath=$root/$path
	echo $fqpath
	ls $fqpath | grep  "R1" | xargs -i echo "$fqpath/{}" > R1.txt
	ls $fqpath | grep  "R2" | xargs -i echo "$fqpath/{}" > R2.txt
	paste  R1.txt R2.txt > config.txt
	cat config.txt  |while read id
	do
		arr=(${id})
		fq1=${arr[0]}
		fq2=${arr[1]}
		file=`basename $fq1`
		outfile=$output/$path/${file%_R1*}
		echo "$outfile"
		if [ ! -d $outfile ];
		then
			mkdir -p $outfile
		fi
		echo "$bowtie -x $index  -1 $fq1 -2 $fq2 -S $outfile/Align.out.sam"
		$bowtie -x $index  -1 $fq1 -2 $fq2 -S $outfile/Align.out.sam
	done
done







	

