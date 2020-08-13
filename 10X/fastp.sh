fastp="/home/ye/anaconda3/envs/BioAlignment/bin/fastp"
root=$1 #"/home/ye/Data/IBFC2018771-16"
clean_outdir=$2 # clean
sample=$3

for path in `ls $root`
do
     outdir=$clean_outdir/$path
     if [ ! -d $outdir ]
     then
	     mkdir -p $outdir
     fi

     prefix=$path # eg. UBR-25
     if [ ! -d $sample/$prefix ]
     then
          mkdir -p $sample/$prefix
     fi

     ls $root/$path | grep "R1" | xargs -i echo "$root/$path/{}" > $sample/$prefix/R1.txt
     ls $root/$path | grep "R2" | xargs -i echo "$root/$path/{}" > $sample/$prefix/R2.txt

     paste  $sample/$prefix/R1.txt $sample/$prefix/R2.txt > $sample/$prefix/config.txt
     cat $sample/$prefix/config.txt  |while read id
     do
          arr=(${id})
          fq1=${arr[0]}
          fq2=${arr[1]}
	  out1_name=`basename $fq1`
	  out2_name=`basename $fq2`
          echo  $fq1 $fq2 $outdir/$out1_name  $outdir/$out2_name
          #$trim_galore -q 20 -e 0.1 --stringency 3 --path_to_cutadapt $cutadapt --paired -o $qc_outdir  $fq1 $fq2 $fq3
          $fastp -i $fq1 -o $outdir/$out1_name -I $fq2 -O $outdir/$out2_name
     done

     #for fastq in `ls $root/$path | grep -E "*.fastq.gz"`
     #do
     #	     fq=$root/$path/$fastq
     #     outfq=$outdir/$fastq
     #	     $fastp -i $fq -o $outfq
     #done
done
