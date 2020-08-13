import os
import argparse
parser=argparse.ArgumentParser()
parser.add_argument("--path",type=str)
parser.add_argument("--pattern",type=str)
args=parser.parse_args()
path=args.path
#path2="/home/ye/Data/Su/LBFC20190554-10_11_12/U-N-1-6_5RNA"

fqs=[f for f in os.listdir(path) if "fastq.gz" in f]

for fq in fqs:
    new_fq=fq.replace("-"+args.pattern,"")
    print("old path : {} -> new path :{}".format(os.path.join(path,fq),os.path.join(path,new_fq)))
    os.rename(os.path.join(path,fq),os.path.join(path,new_fq))
