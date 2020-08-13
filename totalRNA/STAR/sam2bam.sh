#align_root="/home/ye/Data/Zoc/Cell/reference/data/qc/star/align"

samtool="/home/ye/Software/Python/location/envs/Align/bin/samtools"
sort=$1 # 0
align_root=$2 #"/home/ye/Data/Zoc/Cell/reference/data/qc/star/align"


for file in `ls $align_root | grep -v "STAR"`;
do
	align="$align_root/$file/Aligned.out.sam"
	#output="$align_root/$file/Aligned.out.bam"
	echo "$samtool view -S -b $align > $align_root/$file/Aligned.out.bam"
        $samtool view -S -b $align > $align_root/$file/Aligned.out.bam
	if [ $sort -eq 1 ];
	then    
		echo "$samtool sort $align_root/$file/Aligned.out.bam  -o $align_root/$file/Aligned.sorted.out.bam"
		$samtool sort $align_root/$file/Aligned.out.bam  -o $align_root/$file/Aligned.sorted.out.bam
	else
		echo "Not sort"

	fi
done

