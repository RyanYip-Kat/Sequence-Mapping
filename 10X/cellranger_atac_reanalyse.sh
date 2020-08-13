cellranger="/home/ye/Software/cellranger-atac-1.2.0/cellranger-atac"
#reference="/home/ye/Data/10X/VDJ/ref/refdata-cellranger-atac-mm10-1.1.0"
reference="/home/ye/Data/10X/VDJ/ref/refdata-cellranger-atac-GRCh38-1.2.0"
peaks="/home/ye/Data/HsPBMC/aggr/outs/peaks.bed"
fragments="/home/ye/Data/HsPBMC/aggr/outs/fragments.tsv.gz"
barcode="/home/ye/Work/BioAligment/10X/cat_singlecell.csv"
wkdir=$1 
cd $wkdir

$cellranger reanalyze --id HsReanalyze --peaks $peaks --fragments $fragments  --reference $reference --barcodes $barcode
        	
