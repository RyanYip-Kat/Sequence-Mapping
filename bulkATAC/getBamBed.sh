#!/bin/bash
# Parse parameters
usage()
{
	printf "Usage: alinment pipeline [options]\n\n"
	printf "Options:\n"
	printf "\t-p JOBS, --jobs JOBS\n"
	printf "\t\tnumber threads to be use.\n"
	printf "\t-o outDir, --outdir outDir\n"
	printf "\t\toutput path.\n"
	printf "\t--R1\n"
	printf "\t\tR1 fastq file.\n"
	printf "\t--R2\n"
	printf "\t\tR2 fastq file.\n"
	printf "\t--method\n"
	printf "\t\twhich alignment method use,eg(STAR,Bowtie2,bwa,hisat2).\n"
	printf "\t--index\n"
	printf "\t\tindex file consistent with method.\n"
	printf "\t--gsize\n"
	printf "\t\tgsize for call peaks.(hs or mm)\n"
	printf "\t--name\n"
        printf "\t\tprefix name for sort bam file.\n"
	printf "\t--preQC\n"
	printf "\t\twether run QC and get clean fastq files.\n"
	printf "\t-h, --help\n"
	printf "\t\tShow this help message and exit.\n"
}

# Default parameters
macs2="/home/ye/anaconda3/envs/BulkBio/bin/macs2"
SCRIPTS="/home/ye/Work/BioAligment/totalATAC/Pipeline/src"
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
			outdir=$VALUE
			shift 2
			;;
		-m | --method)
			method=$VALUE
			shift 2
			;;
		--index)
			index=$VALUE
			shift 2
			;;
		--preQC)
                        preQC=true
                        shift 1
			;;
		--gsize)
			gsize=$VALUE
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

#############################   pipeline
if [ $preQC == true ]
then    
	fq=${outdir}/trim_clean/${name}_val_1.fq.gz
	if [ ! -f ${fq} ]
	then
		bash ${SCRIPTS}/qc.sh --name ${name} -p ${jobs} --R1 ${R1} --R2 ${R2} --outdir ${outdir}  # trimed fastq is ${outdir}/trim_clean/galore_val_1.fq.gz" ...
	fi
	fq1=${outdir}/trim_clean/${name}_val_1.fq.gz
	fq2=${outdir}/trim_clean/${name}_val_2.fq.gz
else
	fq1=${R1}
	fq2=${R2}

fi

############################## alignment
if [ ${method} == "hisat2" ];
then
	bash ${SCRIPTS}/hisat2.sh -p ${jobs} --R1 ${fq1} --R2 ${fq2} --name ${name} --index ${index} --outdir ${outdir}
elif [ ${method} == "bowtie2" ];
then
	bash ${SCRIPTS}/bowtie2.sh -p ${jobs} --R1 ${fq1} --R2 ${fq2} --name ${name} --index ${index} --outdir ${outdir}
elif [ ${method} == "bwa" ];
then
	bash ${SCRIPTS}/bwa.sh -p ${jobs} --R1 ${fq1} --R2 ${fq2} --name ${name} --index ${index} --outdir ${outdir}
else
	echo "INFO : Invalid method,Not support Now!!!"
	exit 1
fi

############################### callpeak
peakDir="${outdir}/callpeak"
if [ ! -d $peakDir ];
then
        mkdir -p $peakDir
fi

bedFile=${outdir}/alignment/${name}.last.bed
$macs2 callpeak -t $bedFile  -g $gsize --nomodel --shift  -100 --extsize 200  -n ${name} --outdir $peakDir
echo "INFO : Done!"


