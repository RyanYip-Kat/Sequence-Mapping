cellranger="/home/ye/Software/cellranger-atac-1.2.0/cellranger-atac"
#######################
species=$1
root=$2
out=$3

if [ ! -d $out ]
then
       	mkdir -p $out
fi

cd $out
##############
if [ $species == "human" ]
then
	reference="/home/ye/Data/10X/VDJ/ref/refdata-cellranger-atac-GRCh38-1.2.0"
	echo "loading the reference from : $reference"

elif [ $species == "mouse" ]
then
	reference="/home/ye/Data/10X/VDJ/ref/refdata-cellranger-atac-mm10-1.1.0"
	echo "loading the reference from : $reference"
else 
	echo "Invalid species :$species provide,please check again !!!"
fi

###############
echo "--- Running command with species : $species---"
for path in `ls $root`
do
        fastqs=$root/$path
        id=$path
        prefix=$path

	echo "$cellranger count --id=$id --fastqs=$fastqs --reference=$reference --sample=$prefix --jobmode local --localcores 16"
        $cellranger count --id=$id --fastqs=$fastqs --reference=$reference --sample=$prefix --jobmode local --localcores 16
	
done

