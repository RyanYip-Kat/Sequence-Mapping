root=$1
index=$2
output=$3

bowtie="/home/ye/Software/Python/location/envs/Align/bin/bowtie2"

if [ ! -f $output ];
then 
	mkdir -p $output
else
	echo "$output exists"
fi


for i in ` ls $root | grep -E  "*.R1.clean.fastq.gz"`;
do
	if [ ! -f $output/${i%.R1.clean.fastq.gz} ];
        then
                mkdir -p $output/${i%.R1.clean.fastq.gz}
        else
                echo ""
        fi
        
	fq1=$root/$i 
	fq2=$root/${i%.R1.clean.fastq.gz}.R2.clean.fastq.gz
	
	echo "$bowtie -x $index  -1 $fq1 -2 $fq2 -S $output/${i%.R1.clean.fastq.gz}/Align.out.sam"
	$bowtie -x $index  -1 $fq1 -2 $fq2 -S $output/${i%.R1.clean.fastq.gz}/Align.out.sam
	
done


