cellranger="/home/ye/Software/cellranger-3.1.0/cellranger-cs/3.1.0/bin/cellranger"
reference="/home/ye/Data/10X/VDJ/ref/refdata-cellranger-vdj-GRCh38-alts-ensembl-3.1.0"
root=$1

wkdir=$2
cd $wkdir
for path in `ls $root`
do
	fastqs=$root/$path
	id=$path
	prefix=$path
	$cellranger vdj --id $id --fastqs $fastqs --reference $reference --sample $prefix 
done

