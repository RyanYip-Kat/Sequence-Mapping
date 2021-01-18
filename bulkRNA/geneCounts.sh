#!/bin/bash

# Parse parameters
usage()
{
	printf "Usage: get counts [options]\n\n"
	printf "Options:\n"
	printf "\t-p JOBS, --jobs JOBS\n"
	printf "\t\tnumber threads to be use.\n"
	printf "\t-o outDir, --outdir outDir\n"
	printf "\t\toutput path.\n"
	printf "\t--bam\n"
	printf "\t\tbam file from alignment pipeline(STAR,bowtiew,bwa,hisat2).\n"
	printf "\t--method\n"
	printf "\t\twhich counts method use,eg(featureCounts or htseq-count),choices=(feature,htseq).\n"
	printf "\t--gtf\n"
	printf "\t\tgtf file.\n"
	printf "\t-h, --help\n"
	printf "\t\tShow this help message and exit.\n"
}

# Default parameters
featureCount="/home/ye/anaconda3/envs/BulkBio/bin/featureCounts"
htseqCount="/home/ye/anaconda3/envs/BulkBio/bin/htseq-count"

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
				echo "The jobs must be an integer"
				echo ""
				usage
				exit 1
			fi
			;;
		-o | --outdir)
			outDir=$VALUE
			shift 2
			;;
		-m | --method)
			method=$VALUE
			shift 2
			;;
		--bam)
			bam=$VALUE
			shift 2
			;;
		--gtf)
			gtf=$VALUE
			shift 2
			;;
		*)
			echo "Error: unknown parameter \"$PARAM\""
			exit 1
			;;
	esac
done

##############  fastqc
count_dir="${outDir}/counts"
if [ ! -d $count_dir ];
then
	mkdir -p $count_dir
fi

echo "INFO : start get counts ... $(date)"
if [ $method == "feature" ];
then
	$featureCount  -T $jobs -g gene_id -t exon -o ${count_dir}/${method}.Counts.txt -a $gtf $bam
	sed -n '3,$p' ${count_dir}/${method}.Counts.txt  |  cut -f1,7- | sed s/Geneid/id/  > ${count_dir}/counts.txt
elif [ $method == "htseq" ];
then
        $htseqCount --format bam -r name -s no -a 10 -t exon -i gene_id -m union --nonunique=none  $bam $gtf > ${count_dir}/${method}.Counts.txt

else
	echo "INFO : invalid counts method!!!"
fi

echo "INFO : get counts finished at $(date)"
