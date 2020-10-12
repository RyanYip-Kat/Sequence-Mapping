nextflow run -bg nf-core/rnaseq  -profile docker \
	--gencode \
	--email "ryanyip_@hotmail.com" \
	--max_cpus 16 \
	--reads "/home/ye/Data/dataset/Liusheng/*_R{1,2}.fastq.gz" \
	--star_index /home/ye/Data/totalRNA_ref/human/index/STAR/star_hg38 \
	--fasta /home/ye/Data/genome/GRCh38.primary_assembly.genome.fa \
	--gtf /home/ye/Data/genome/gencode.v35.annotation.gtf \
	--outdir Liusheng  --genome GRCh38 -w workdir -with-report report.html
