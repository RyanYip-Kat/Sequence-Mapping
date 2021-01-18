#!/bin/bash

# Parse parameters
usage()
{
	printf "Usage: alinment pipeline [options]\n\n"
	printf "Options:\n"
	printf "\t-p jobs, --jobs jobs\n"
	printf "\t\tnumber threads to be use.\n"
	printf "\t-o outDir, --outdir outDir\n"
	printf "\t\toutput path.\n"
	printf "\t--R1\n"
	printf "\t\tR1 fastq file.\n"
	printf "\t--R2\n"
	printf "\t\tR2 fastq file.\n"
	printf "\t--name\n"
	printf "\t\tprefix name for trim fastq.\n"
	printf "\t-h, --help\n"
	printf "\t\tShow this help message and exit.\n"
}

# Default parameters
samtools="/home/ye/anaconda3/envs/BulkBio/bin/samtools"
samblaster="/home/ye/anaconda3/envs/BulkBio/bin/samblaster"
hisat2="/home/ye/anaconda3/envs/BulkBio/bin/hisat2"
bowtie2="/home/ye/anaconda3/envs/BulkBio/bin/bowtie2"
trim_galore="/home/ye/anaconda3/envs/BulkBio/bin/trim_galore"
bwa="/home/ye/anaconda3/envs/BulkBio/bin/bwa"
star="/home/ye/anaconda3/envs/BulkBio/bin/STAR"
cutadapt="/home/ye/anaconda3/envs/BulkBio/bin/cutadapt"
fastqc="/home/ye/anaconda3/envs/BulkBio/bin/fastqc"
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
		--R1)
			R1=$VALUE
			shift 2
			;;
		--R2)
			R2=$VALUE
			shift 2
			;;
		--name) 
			name=$VALUE
			shift 2
			;;

		*)
			echo "Error: unknown parameter \"$PARAM\""
			exit 1
			;;
	esac
done

##############  fastqc
qc_dir="${outDir}/fastqc/${name}"
if [ ! -d $qc_dir ];
then
	mkdir -p $qc_dir
fi
echo "INFO : start Fastqc ... $(date)"
$fastqc -o ${qc_dir} $R1 $R2
echo "INFO : fastqc finished at $(date)"



############## trim and clean data
echo "INFO : start trim_galore ...$(date)"
clean_dir="${outDir}/trim_clean"
if [ ! -d $clean_dir ];
then
        mkdir -p $clean_dir
fi

$trim_galore -q 20 --phred33 --stringency 3 --length 20 -e 0.1 --cores $jobs \
            --paired $R1 $R2  \
	    --path_to_cutadapt $cutadapt \
	    --basename ${name} --output_dir $clean_dir --fastqc --gzip --cores $jobs

echo "INFO : trim_galore cut adapters finished at $(date)"


