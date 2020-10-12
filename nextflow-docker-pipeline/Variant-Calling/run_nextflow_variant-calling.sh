nextflow run -bg CRG-CNAG/CalliNGS-NF  -profile docker \
	--reads "/home/ye/Data/dataset/totalRNA/Liusheng/*_R{1,2}.fastq.gz" \
	--variants "/home/ye/Data/genome/homo_sapiens_somatic.vcf.gz" \
	--genome "/home/ye/Data/genome/GRCh38.primary_assembly.genome.fa" \
	-with-report report.html 
