featureCounts="/home/ye/Software/Python/location/envs/Align/bin/featureCounts"
align_root="/home/ye/Data/Zoc/Cell/reference/data/qc/star/align"
gtf="/home/ye/Data/Zoc/Cell/reference/dna/mouse/gtf/Mus_musculus.GRCm38.95.gtf"
sort=0


if [ $sort -eq 0 ];
then
	bam="Aligned.out.sam"
else
        bam="Aligned.sorted.out.sam"
fi


for file in `ls $align_root | grep -v "STAR"`;
do      
	#echo "Counts : $file"
	align="$align_root/$file/$bam"
	echo "Align : $align"
	echo "output : $align_root/$file/featureCounts.txt"
	#output= "$align_root/$file"
        #output="featureCounts.txt"


	echo "$featureCounts  -T 2 -g gene_id -t exon -o $align_root/$file/featureCounts.txt -a $gtf $align"
	$featureCounts  -T 2 -g gene_id -t exon -o $align_root/$file/featureCounts.txt -a $gtf $align

	echo "cut -f 1,7,8,9,10,11,12 $align_root/$file/featureCounts.txt  > $align_root/$file/Counts.txt"
	sed -n '3,$p' $align_root/$file/featureCounts.txt  |  cut -f1,7- | sed s/Geneid/id/  > $align_root/$file/Counts.txt
done

if [ $? -eq 0 ];
then
	echo "Successfully"
else
	echo "Error"
fi



