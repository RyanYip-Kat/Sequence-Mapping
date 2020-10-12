root=$1
sample_list=$2
out=$3

file="/home/ye/Work/BioAligment/MiXCR/merge_fastqs_channel.py"
for pattern in `cat $sample_list`
do
   python $file --path $root --pattern $pattern --outdir $out
done

