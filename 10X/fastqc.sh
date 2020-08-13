fastqc=/home/ye/anaconda3/envs/BioAlignment/bin/fastqc
root=$1
outdir=$2

for path in `ls $root`
do
	if [ -d $root/$path ];
	then
		if [ ! -d $outdir/$path ];
		then 
			mkdir -p $outdir/$path
		fi
		$fastqc -o $outdir/$path -t 4 $root/$path/*R*.fastq.gz
	fi
done
