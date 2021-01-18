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
	printf "\t--genome\n"
	printf "\t\tgenome dir from star build index.\n"
	printf "\t--gtf\n"
	printf "\t\tgtf file(Homo_sapiens.GRCh38.97.chr.gtf).\n"
	printf "\t--name\n"
	printf "\t\tprefix name for output.\n"
	printf "\t-h, --help\n"
	printf "\t\tShow this help message and exit.\n"
}

# Default parameters
samtools="/home/ye/anaconda3/envs/BulkBio/bin/samtools"
samblaster="/home/ye/anaconda3/envs/BulkBio/bin/samblaster"
star="/home/ye/anaconda3/envs/BulkBio/bin/STAR"
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
		--genome)
			genome=$VALUE
			shift 2
			;;
		--gtf)
			gtf=$VALUE
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

align_dir="${outDir}/STAR"
if [ ! -d $align_dir ];
then
	mkdir -p $align_dir
fi

$outfile="${align_dir}/${name}"
echo "INFO : start alignment ... $(date)"
$star --runMode alignReads \
                      --genomeDir $genome \
                      --readFilesType Fastx \
                      --runThreadN $jobs \
                      --outTmpKeep None \
                      --outSAMtype SAM \
                      --outFileNamePrefix  $outfile  \
                      --genomeLoad NoSharedMemory  \
                      --readFilesIn $R1 $R2

echo "INFO : alignment finished at $(date)"

