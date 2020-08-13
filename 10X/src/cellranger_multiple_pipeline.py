import os
import argparse
parser=argparse.ArgumentParser()
parser.add_argument("--outdir",type=str,default="output")
parser.add_argument("--path",type=str,default=None)
parser.add_argument("--pattern",type=str,default="count",choices=["count","vdj"])
parser.add_argument("--sample",nargs="+",type=str,default=None)
parser.add_argument("--name",type=str,default="pbmc")
parser.add_argument("--cores",type=int,default=16)
parser.add_argument("--reference",type=str,default="/home/ye/Data/10X/VDJ/ref/refdata-cellranger-GRCh38-3.0.0")
parser.add_argument("--cellranger",type=str,default="/home/ye/Software/cellranger-3.1.0/cellranger-cs/3.1.0/bin/cellranger")

args=parser.parse_args()
if not os.path.exists(args.outdir):
   os.makedirs(args.outdir)


if args.sample is None:
    raise ValueError("Invalid sample,please enter invalid sample in {}".format(args.path))
elif len(args.sample)==1:
    samples=args.sample[0]
else:
    samples=",".join(args.sample)

#############
fastqs=args.path
print("*** Align dataset's path is : {},and samples is : {}".format(fastqs,samples))
if args.pattern=="count":
    cmd="{} count --id={} --fastqs={} --transcriptome={} --sample={} --jobmode=local --localcores={} --localmem=64".format(
                args.cellranger,args.name,fastqs,args.reference,samples,args.cores)
else:
    cmd="{} vdj --id={} --fastqs={} --reference={} --sample={} --jobmode=local --localcores={} --localmem=64".format(
                args.cellranger,args.name,fastqs,args.reference,samples,args.cores)


print("---- Running command : {} ----".format(cmd))
os.system("cd {}".format(args.outdir))
os.system(cmd)



