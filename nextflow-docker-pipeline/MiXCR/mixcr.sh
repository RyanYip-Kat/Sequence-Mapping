sample_list=$1
receptor=$2  # bcr ,tcr
for sample in `cat $sample_list`
do
mixcr analyze amplicon --species hs --starting-material rna --5-end v-primers --3-end j-primers --adapters adapters-present -t 12 --impute-germline-on-export --receptor-type $receptor /Data/$sample/merged_fastq_R1.fastq.gz /Data/$sample/merged_fastq_R2.fastq.gz $sample

done
