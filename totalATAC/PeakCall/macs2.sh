root="/home/ye/Work/BioAligment/totalATAC/aligned"
samtool="/home/ye/anaconda3/envs/BioAlignment/bin/samtools"
macs2="/home/ye/anaconda3/envs/BioAlignment/bin/macs2"

wkdir=$1

for path in `ls $root`;
do
	infile=$root/$path/Aligned.sorted.out.bam
	echo "Input file : $infile"
	outdir=$wkdir/$path
	if [ ! -d $outdir ];
	then
	       	mkdir -p $outdir
        fi
	echo " Output path : $outdir"
	$macs2 callpeak -t $infile -g 2.7e9 --bdg --verbose 2 --outdir $outdir --name $path --nomodel --call-summits --nolambda --keep-dup all 
done
