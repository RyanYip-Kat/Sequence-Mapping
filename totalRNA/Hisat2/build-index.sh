extract_exons="/home/ye/Software/Python/location/envs/Align/bin/hisat2_extract_exons.py"
extract_splice_sites="/home/ye/Software/Python/location/envs/Align/bin/hisat2_extract_splice_sites.py"
gtf="/home/ye/Data/Zoc/Cell/reference/dna/mouse/gtf/Mus_musculus.GRCm38.97.chr.gtf"
output="/home/ye/Data/Zoc/Cell/reference/dna/mouse/hisat2-index"

#$extract_exons $gtf > $output/exons.gtf
#$extract_splice_sites $gtf > $output/splice_sites.gtf

/home/ye/Software/Python/location/envs/Align/bin/hisat2-build --ss $output/splice_sites.gtf --exon $output/exons.gtf \
	/home/ye/Data/Zoc/Cell/reference/dna/mouse/fasta/Mus_musculus.GRCm38.dna.primary_assembly.fa  $output/genome



