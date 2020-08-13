cellranger="/home/ye/Software/cellranger-3.1.0/cellranger-cs/3.1.0/bin/cellranger"

library=$1
sample_id=$2
out=$3

if [ ! -d $out ]
then
        mkdir -p $out
fi

cd $out

echo "$cellranger aggr --id $sample_id --csv $library --normalize mapped --jobmode local --localcores 16"
$cellranger aggr --id $sample_id --csv $library --normalize mapped --jobmode local --localcores 16

        	
