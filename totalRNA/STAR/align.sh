root=$1  #  fastq root
star="/home/ye/anaconda3/envs/BioAlignment/bin/STAR"
genomeDir="/home/ye/Data/totalRNA_ref/human/index/STAR/hg38/genomeDir"  # /home/ye/Data/Zoc/Cell/reference/data/qc/star/genomeDir 
gtf="/home/ye/Data/totalRNA_ref/human/gtf/Homo_sapiens.GRCh38.97.chr.gtf"  #  /home/ye/Data/Zoc/Cell/reference/dna/mouse/gtf/Mus_musculus.GRCm38.95.gtf
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
		$star --runMode alignReads \
                      --genomeDir $genomeDir \
                      --sjdbGTFfile $gtf \
                      --readFilesType Fastx \
                      --runThreadN 2 \
                      --outTmpKeep None \
                      --outSAMtype SAM \
                      --outFileNamePrefix  $outfile/  \
                      --outFilterMismatchNmax 100 \
                      --seedSearchStartLmax 20 \
                      --seedPerReadNmax 100000 \
                      --seedPerWindowNmax 1000 \
                      --alignTranscriptsPerReadNmax 100000 \
                      --alignTranscriptsPerWindowNmax 10000 \
                      --readFilesCommand zcat \
                      --genomeLoad NoSharedMemory  \
                      --readFilesIn $fq1 $fq2
	done
done







	

