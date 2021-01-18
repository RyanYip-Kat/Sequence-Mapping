#!/bin/bash

##### build index
#extract_exons.py gencode.vM19.annotation.gtf > genome.exon
#extract_splice_sites.py gencode.vM19.annotation.gtf > genome.ss
#hisat2-build -p 20 GRCm38.chr.fa --ss genome.ss --exon genome.exon genome_tran

############################
# Parse parameters
usage()
{
	printf "Usage: alinment pipeline [options]\n\n"
	printf "Options:\n"
	printf "\t-o outDir, --outdir outDir\n"
	printf "\t\toutput path.\n"
	printf "\t--bed\n"
	printf "\t\tbed file.\n"
	printf "\t--narrow\n"
	printf "\t\tnarrowPeak file.\n"
	printf "\t--name\n"
        printf "\t\toutput prefix name.\n"
	printf "\t-h, --help\n"
	printf "\t\tShow this help message and exit.\n"
}

# Default parameters
samtools="/home/ye/anaconda3/envs/BulkBio/bin/samtools"
samblaster="/home/ye/anaconda3/envs/BulkBio/bin/samblaster"
sambamba="/home/ye/anaconda3/envs/BulkBio/bin/sambamba"
hisat2="/home/ye/anaconda3/envs/BulkBio/bin/hisat2"
bedtools="/home/ye/anaconda3/envs/BulkBio/bin/bedtools"
# Get the parameters selected by the user
while [ "$1" != "" ]; do
	PARAM=`echo $1 | awk -F' ' '{print $1}'`
	VALUE=`echo $2 | awk -F' ' '{print $1}'`
	case $PARAM in
		-h | --help)
			usage
			exit
			;;
		-o | --outdir)
			outDir=$VALUE
			shift 2
			;;
		--name)
                        name=$VALUE
                        shift 2
                        ;;

		--bed)
			bed=$VALUE
			shift 2
			;;
		--narrow)
			narrow=$VALUE
			shift 2
			;;

		*)
			echo "Error: unknown parameter \"$PARAM\""
			exit 1
			;;
	esac
done

##############  fastqc
frip_dir="${outDir}/FRIP"
if [ ! -d $frip_dir ];
then
	mkdir -p $frip_dir
fi
Reads=$($bedtools intersect -a $bed -b $narrow |wc -l|awk '{print $1}')
totalReads=$(wc -l $bed|awk '{print $1}')
echo '==> FRiP value:' $(bc <<< "scale=2;100*$Reads/$totalReads")'%' > ${frip_dir}/${name}_frip.txt
