htseq="/home/ye/anaconda3/envs/BioAlignment/bin/htseq-count"
align_root=$1
gtf="/home/ye/Data/totalRNA_ref/human/gtf/Homo_sapiens.GRCh38.97.chr.gtf"
sort=$2   # 0 


if [ $sort -eq 0 ];
then
        bam="Aligned.out.bam"
else
        bam="Aligned.sorted.out.bam"
fi


for file in `ls $align_root`;
do
        align="$align_root/$file/$bam"
	echo "Align : $align"
        #output= "$align_root/$file/Counts.txt"

	$htseq --format sam \
		-s no \
		-t exon \
		-i gene_id \
		--additional-attr=gene_name \
		$align $gtf > $align_root/$file/htseq-counts.txt 

done

if [ $? -eq 0 ];
then
        echo "Successfully"
else
        echo "Error"
fi


