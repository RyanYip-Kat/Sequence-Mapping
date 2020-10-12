BIN_VERSION="latest"
INPUT_DIR="/home/ye/Work/BioAligment/Variant-Calling/data"
OUTPUT_DIR="/home/ye/Work/BioAligment/Variant-Calling/data"

REF_DIR="/home/ye/Data/genome"
docker run -itd -v ${INPUT_DIR}:/input \
	-v ${OUTPUT_DIR}:/output \
	-v ${REF_DIR}:/ref \
	google/deepvariant:"${BIN_VERSION}" \
	/opt/deepvariant/bin/run_deepvariant \
	--model_type WGS \
	--ref "/ref/GRCh38.primary_assembly.genome.fa" \
	--reads "/input/C_L1_382382Aligned.sortedByCoord.out.bam" \
	--output_vcf "/output/output.vcf.gz" \
	--output_gvcf "/output/output.g.vcf.gz" \
	--num_shards 8 \
	--regions "chr1 chr2 chr3 chr4 chr5 chr6 chr7 chrX" \
	--vcf_stats_report


