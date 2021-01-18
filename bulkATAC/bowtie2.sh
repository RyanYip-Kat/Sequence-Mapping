#!/bin/bash

# Parse parameters
usage()
{
	printf "Usage: alinment pipeline [options]\n\n"
	printf "Options:\n"
	printf "\t-p PORT, --jobs PORT\n"
	printf "\t\tnumber threads to be use.\n"
	printf "\t-o outDir, --outdir outDir\n"
	printf "\t\toutput path.\n"
	printf "\t--R1\n"
	printf "\t\tR1 fastq file.\n"
	printf "\t--R2\n"
	printf "\t\tR2 fastq file.\n"
	printf "\t--index\n"
	printf "\t\tbowtie2 index.\n"
	printf "\t--name\n"
	printf "\t\toutput prefix name.\n"
	printf "\t-h, --help\n"
	printf "\t\tShow this help message and exit.\n"
}

# Default parameters
samtools="/home/ye/anaconda3/envs/BulkBio/bin/samtools"
samblaster="/home/ye/anaconda3/envs/BulkBio/bin/samblaster"
bowtie2="/home/ye/anaconda3/envs/BulkBio/bin/bowtie2"
bedtools="/home/ye/anaconda3/envs/BulkBio/bin/bedtools"
sambamba="/home/ye/anaconda3/envs/BulkBio/bin/sambamba"
# Get the parameters selected by the user
while [ "$1" != "" ]; do
	PARAM=`echo $1 | awk -F' ' '{print $1}'`
	VALUE=`echo $2 | awk -F' ' '{print $1}'`
	case $PARAM in
		-h | --help)
			usage
			exit
			;;
		-p | --jobs)
			if [[ $VALUE =~ ^-?[0-9]+$ ]]; then
				jobs=$VALUE
				shift 2
			else
				echo "The port must be an integer"
				echo ""
				usage
				exit 1
			fi
			;;
		-o | --outdir)
			outDir=$VALUE
			shift 2
			;;
		--name)
			name=$VALUE
			shift 2
			;;
		--index)
			index=$VALUE
			shift 2
			;;
		--R1)
			R1=$VALUE
			shift 2
			;;
		--R2)
			R2=$VALUE
			shift 2
			;;

		*)
			echo "Error: unknown parameter \"$PARAM\""
			exit 1
			;;
	esac
done

##############  alignment
align_dir="${outDir}/alignment"
if [ ! -d $align_dir ];
then
	mkdir -p $align_dir
fi
echo "INFO : start alignment ... $(date)"
$bowtie2 -x $index --threads $jobs -1 $R1 -2 $R2 | $samblaster -e -d ${align_dir}/${name}.disc.sam -s ${align_dir}/${name}.split.sam | $samtools view -@ $jobs -Sb -q 1  | $samtools sort -@ $jobs -o ${align_dir}/${name}.sorted.bam -  

echo "INFO : build bam index ...$(date)"
$samtools index -@ $jobs ${align_dir}/${name}.sorted.bam
$samtools flagstat -@ $jobs ${align_dir}/${name}.sorted.bam  > ${align_dir}/${name}.sorted.bam.flagstat

$sambamba markdup -r ${align_dir}/${name}.sorted.bam  ${align_dir}/${name}.sambamba.rmdup.bam
$samtools index -@ $jobs ${align_dir}/${name}.sambamba.rmdup.bam
$samtools flagstat ${align_dir}/${name}.sambamba.rmdup.bam > ${align_dir}/${name}.sambamba.rmdup.bam.flagstat

echo "INFO : filter chrM ...$(date)"
$samtools view -h -f 2 -q 30  ${align_dir}/${name}.sambamba.rmdup.bam  |grep -v chrM| $samtools sort  -O bam  -@ $jobs -o - > ${align_dir}/${name}.last.bam
$bedtools bamtobed -i ${align_dir}/${name}.last.bam  > ${align_dir}/${name}.last.bed
$samtools view ${align_dir}/${name}.last.bam |awk '{print $9}'  > ${align_dir}/${name}_length.txt
echo "INFO : alignment finished at $(date)"

