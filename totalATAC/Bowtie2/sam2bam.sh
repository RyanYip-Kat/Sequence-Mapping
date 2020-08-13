#align_root="/home/ye/Data/Zoc/Cell/reference/data/qc/star/align"

samtool="/home/ye/anaconda3/envs/BioAlignment/bin/samtools"
sort=$1 # 0
align_root=$2 #"/home/ye/Data/Zoc/Cell/reference/data/qc/star/align"


for file in `ls $align_root`;
do
	align="$align_root/$file/Align.out.sam"
	#output="$align_root/$file/Aligned.out.bam"
	echo "$samtool view -S -b $align > $align_root/$file/Align.out.bam"
        $samtool view -S -b $align > $align_root/$file/Aligned.out.bam
	if [ $sort -eq 1 ];
	then    
		echo "$samtool sort $align_root/$file/Align.out.bam  -o $align_root/$file/Align.sorted.out.bam"
		$samtool sort $align_root/$file/Aligned.out.bam  -o $align_root/$file/Aligned.sorted.out.bam
	else
		echo "Not sort"

	fi
done

