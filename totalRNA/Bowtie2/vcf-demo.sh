samtools="/home/ye/Software/Python/location/envs/Align/bin/samtools"
sam="/home/ye/Data/Zoc/Cell/reference/data/qc/bowtie2/align/mouse/B1-1_L2_A007/Align.out.sam"
bcftools="/home/ye/Software/Python/location/envs/Align/bin/bcftools"
fasta="/home/ye/Data/Zoc/Cell/reference/dna/mouse/fasta/Mus_musculus.GRCm38.dna.primary_assembly.fa"
output=`dirname $sam`

#echo "Sam to Bam"
#$samtools view -bS $sam > $output/Align.out.bam

#echo "Sort bam"
#$samtools sort $output/Align.out.bam -o $output/Align.sorted.out.bam


$bcftools mpileup $output/Align.sorted.out.bam  --fasta-ref $fasta  > $output/mpileup.vcf
$bcftools call $output/mpileup.vcf -c  -v -o $output/variants.vcf
