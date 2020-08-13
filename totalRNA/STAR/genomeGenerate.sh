genomeDir=$1  # /home/ye/Data/Zoc/Cell/reference/data/qc/star/genomeDir
genomeFastaFiles=$2
sjdbGTFfile=$3

star=$4

if [ -f $genomeDir ];
then 
	echo "$genomeDir exists"
else
	mkdir -p $genomeDir
fi



$star --runMode genomeGenerate \
	--genomeDir $genomeDir \
	--genomeFastaFiles $genomeFastaFiles \
	--sjdbGTFfile $sjdbGTFfile \
	--runThreadN 2
