htseq="/home/ye/Software/Python/location/envs/Align/bin/htseq-count"
align_root="/home/ye/Data/Zoc/Cell/reference/data/qc/star/align"
gff="/home/ye/Data/Zoc/Cell/reference/dna/mouse/gtf/Mus_musculus.GRCm38.95.gtf"
sort=0


if [ $sort -eq 0 ];
then
        bam="Aligned.out.sam"
else
        bam="Aligned.sorted.out.sam"
fi


for file in `ls $align_root | grep -v "STAR"`;
do
        align="$align_root/$file/$bam"
	echo "Align : $align"
        #output= "$align_root/$file/Counts.txt"

	$htseq --format sam \
		-s no \
		-t exon \
		-i gene_id \
		--additional-attr=gene_name \
		$align $gff > $align_root/$file/htseq-counts.txt 

done

if [ $? -eq 0 ];
then
        echo "Successfully"
else
        echo "Error"
fi


