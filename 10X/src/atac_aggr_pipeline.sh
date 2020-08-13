cellranger="/home/ye/Software/cellranger-atac-1.2.0/cellranger-atac"
      
species=$1  # human ,mouse
library=$2
sample_id=$3
out=$4

if [ ! -d $out ]
then
        mkdir -p $out
fi

cd $out


if [ $species=="human" ];
then
	reference="/home/ye/Data/10X/VDJ/ref/refdata-cellranger-atac-GRCh38-1.2.0"
	echo "loading the reference from : $reference"
elif [ $species=="mouse" ];
then
	reference="/home/ye/Data/10X/VDJ/ref/refdata-cellranger-atac-mm10-1.1.0"
	echo "loading the reference from : $reference"
else
	echo "Invalid species : $species provived !!!"
fi

#########
echo "Running command"
echo "$cellranger aggr --id $sample_id--csv $library --normalize depth --reference $reference --jobmode local --localcores 16"
$cellranger aggr --id $sample_id--csv $library --normalize depth --reference $reference --jobmode local --localcores 16
