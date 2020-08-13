path=$1  # UBR-25
outdir=$2
prefix=`basename $path`
ls $path | grep -E "*.R1_001.fastq.gz" > $outdir/${prefix}_R1.txt
ls $path | grep -E "*.R2_001.fastq.gz" > $outdir/${prefix}_R2.txt
ls $path | grep -E "*.I1_001.fastq.gz" > $outdir/${prefix}_I1.txt
