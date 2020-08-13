trim_galore="/home/ye/Software/Python/location/envs/Align/bin/trim_galore"
cutadapt="/home/ye/Software/Python/location/envs/Align/bin/cutadapt"
path=$1  # UBR-25
sample=$2  # sample
clean_outdir=$3 # clean
prefix=`basename $path` # eg. UBR-25

if [ ! -d $sample/$prefix ]
then
	mkdir -p $sample/$prefix
fi

ls $path | grep -E "*.R1_001.fastq.gz" | xargs -i echo "$path/{}" > $sample/$prefix/R1.txt
ls $path | grep -E "*.R2_001.fastq.gz" | xargs -i echo "$path/{}" > $sample/$prefix/R2.txt
ls $path | grep -E "*.I1_001.fastq.gz" | xargs -i echo "$path/{}" > $sample/$prefix/I1.txt

paste  $sample/$prefix/R1.txt $sample/$prefix/R2.txt $sample/$prefix/I1.txt  > $sample/$prefix/config.txt

cat $sample/$prefix/config.txt  |while read id
do
        arr=(${id})
        fq1=${arr[0]}
        fq2=${arr[1]}
	fq3=${arr[2]}
        echo  $clean_outdir  $fq1 $fq2 $fq3
        $trim_galore -q 20 -e 0.1 --stringency 3 --path_to_cutadapt $cutadapt --paired -o $clean_outdir  $fq1 $fq2
done
