library(ChIPseeker)
library(GenomicRanges)
library(TxDb.Hsapiens.UCSC.hg38.knownGene)
library(clusterProfiler)
library(argparse)
library(ggpubr)

parser <- ArgumentParser(description='Process some tasks')
parser$add_argument("--path",
                    type="character",
                    default="/home/ye/Work/BioAligment/totalATAC/Macs2")
                    

parser$add_argument("--outdir",
                    type="character",
                    default="output",
                    help="which dataset")

args <- parser$parse_args()

if(!dir.exists(args$outdir)){
           dir.create(args$outdir,recursive=TRUE)
}

readPeak<-function(file){
	peak=peak=readPeakFile(file)
	metadata<-elementMetadata(peak)
	colnames(metadata)=c("name","score","strand","signalValue","pValue","qValue","peak")
	elementMetadata(peak)<-metadata
	s<-as.character(seqnames(peak))
	gr<-peak[s%in%c(as.character(1:22),"X","Y")]
	seqlevels(gr)<-c(as.character(1:22),"X","Y")
	#seqnames(gr)=paste("chr",seqnames(gr),sep="")
	return(gr)
}

txdb <- TxDb.Hsapiens.UCSC.hg38.knownGene
#path="/home/ye/Work/BioAligment/totalATAC/Macs2"
path=args$path
files=file.path(path,list.files(path,pattern="*.narrowPeak",recursive=TRUE))
peaks<-lapply(files,readPeak)

print("### Profile of several ChIP peak data binding to TSS region")

promoter <- getPromoters(TxDb=txdb, upstream=3000, downstream=3000)
tagMatrixList <- lapply(peaks, getTagMatrix, windows=promoter)

pdf(file.path(args$outdir,"tagMatrixList.pdf"),width=12,height=10)
plotAvgProf(tagMatrixList, xlim=c(-3000, 3000), conf=0.95,resample=500, facet="row")
dev.off()

pdf(file.path(args$outdir,"peakHeatmap.pdf"),width=12,height=10)
tagHeatmap(tagMatrixList, xlim=c(-3000, 3000), color=NULL)
dev.off()


print("### ChIP peak annotation comparision")
peakAnnoList <- lapply(peaks, annotatePeak, TxDb=txdb,
                       tssRegion=c(-3000, 3000), verbose=TRUE)

pdf(file.path(args$outdir,"plotAnnoBars.pdf"),width=12,height=10)
plotAnnoBar(peakAnnoList)
dev.off()

pdf(file.path(args$outdir,"plotDistToTSSs.pdf"),width=12,height=10)
plotDistToTSS(peakAnnoList)
dev.off()

genes= lapply(peakAnnoList, function(i) as.data.frame(i)$geneId)
pdf(file.path(args$outdir,"vennplots.pdf"),width=12,height=10)
vennplot(genes)
dev.off()

covplot_list<-lapply(peaks,covplot,weightCol="V5")

pdf(file.path(args$outdir,"covplots.pdf"),width=12,height=10)
ggarrange(covplot_list,ncol=2)
dev.off()


