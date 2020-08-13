cellranger="/home/ye/Software/cellranger-3.1.0/cellranger-cs/3.1.0/bin/cellranger"

#######################
pattern=$1
species=$2
root=$3
out=$4

if [ ! -d $out ]
then
       	mkdir -p $out
fi

cd $out
##############
if [ $species == "human" ]
then
	if [ $pattern == "pcr" ]
	then 
		reference="/home/ye/Data/10X/VDJ/ref/refdata-cellranger-vdj-GRCh38-alts-ensembl-3.1.0"
	else
		reference="/home/ye/Data/10X/VDJ/ref/refdata-cellranger-GRCh38-3.0.0"
	fi
	echo "loading the reference from : $reference"

elif [ $species == "mouse" ]
then
	if [ $pattern == "pcr" ]
	then
		reference="/home/ye/Data/10X/VDJ/ref/refdata-cellranger-vdj-GRCm38-alts-ensembl-3.1.0"
	else
		reference="/home/ye/Data/10X/VDJ/ref/refdata-cellranger-mm10-3.0.0"
	fi
	echo "loading the reference from : $reference"
else 
	echo "Invalid species :$species provide,please check again !!!"
fi

###############
echo "--- Running Align pattern with pattern : $pattern ,species : $species  ---"
for path in `ls $root`
do
        fastqs=$root/$path
        id=$path
        prefix=$path
	
	if [ $pattern == "count" ]
	then
		echo "$cellranger count --id $id --fastqs $fastqs --transcriptome  $reference --sample $prefix --jobmode local --localcores 16"
		$cellranger count --id $id --fastqs $fastqs --transcriptome  $reference --sample $prefix --jobmode local --localcores 16
	elif [ $pattern == "pcr" ]
	then
		echo "$cellranger vdj --id $id --fastqs $fastqs --reference $reference --sample $prefix --jobmode local --localcores 16"
		$cellranger vdj --id $id --fastqs $fastqs --reference $reference --sample $prefix --jobmode local --localcores 16
	else
		echo "Invalid pattern : $pattern!!!"
	fi
done

