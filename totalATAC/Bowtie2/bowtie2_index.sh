bowtie2="/home/ye/Software/Python/location/envs/Align/bin/bowtie2-build"   # where the bowtiew
fasta="/home/ye/Data/Zoc/Cell/reference/dna/mouse/fasta/Mus_musculus.GRCm38.dna.primary_assembly.fa"
index_dir="/home/ye/Data/Zoc/Cell/reference/data/qc/bowtie2/index/mouse"


if [ ! -e $index_dir ]
then
	mkdir -p $index_dir
else
	echo "$index_dir is exists"
fi

echo "$bowtie2 -f $fasta $index_dir/Mus_musculus"
$bowtie2 -f $fasta $index_dir/Mus_musculus
