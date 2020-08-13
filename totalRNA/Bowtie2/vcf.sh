#samtool="/home/ye/Software/Python/location/envs/Align/bin/samtools"
bcftool="/home/ye/Software/Python/location/envs/Align/bin/bcftools"
fasta="/home/ye/Data/Zoc/Cell/reference/dna/mouse/fasta/Mus_musculus.GRCm38.dna.primary_assembly.fa"
align_root="/home/ye/Data/Zoc/Cell/reference/data/qc/bowtie2/align/mouse"
vcf_root="/home/ye/Data/Zoc/Cell/reference/data/qc/bowtie2/vcf/mouse"

for file in `ls $align_root`;
do
	align="$align_root/$file/Aligned.sorted.out.bam"
	
	if [ ! -f $vcf_root/$file ];
	then
		mkdir -p $vcf_root/$file
	fi

	echo "$bcftools mpileup $vcf_root/$file/Align.sorted.out.bam  --fasta-ref $fasta  > $vcf_root/$file/mpileup.vcf"
	echo "$bcftools call $vcf_root/$file/mpileup.vcf -c  -v -o $vcf_root/$file/variants.vcf"
done


