featureCounts="/home/ye/anaconda3/envs/BioAlignment/bin/featureCounts"
align_root=$1  #"/home/ye/Data/Zoc/Cell/reference/data/qc/star/align"
gtf="/home/ye/Data/totalRNA_ref/human/gtf/Homo_sapiens.GRCh38.97.chr.gtf"
sort=$2


if [ $sort -eq 0 ];
then
	bam="Aligned.out.bam"
else
        bam="Aligned.sorted.out.bam"
fi


for file in `ls $align_root`;
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



