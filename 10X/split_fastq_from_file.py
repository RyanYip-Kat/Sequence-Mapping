import os
import argparse
import numpy as np
import shutil

parser=argparse.ArgumentParser()
parser.add_argument("--path",type=str)
parser.add_argument("--outdir",type=str)
args=parser.parse_args()
path=args.path

fqs=[f for f in os.listdir(path) if "fastq.gz" in f]

idents=[]
for fq in fqs:
    chrs=fq.split("-")
    n=len(chrs)
    chrs=chrs[:n-1]
    chrs="-".join(chrs)
    idents.append(chrs)

unique_ident=np.unique(idents)
for ident in unique_ident:
    out_ident=os.path.join(args.outdir,ident)
    if not os.path.exists(out_ident):
        os.makedirs(out_ident)

    ident_fqs=[fq for fq in fqs if ident in fq]
    print("There are : {} fqs in {}".format(len(ident_fqs),ident))
    
    for ident_fq in ident_fqs:
        print("move : {} -> into:{}".format(os.path.join(args.path,ident_fq),os.path.join(out_ident,ident_fq)))
        shutil.move(os.path.join(args.path,ident_fq), os.path.join(out_ident,ident_fq))




