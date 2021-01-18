import os
import argparse
import subprocess

idr="/home/ye/anaconda3/envs/BulkBio/bin/idr"
def submitter(commander):
        """Submits commands directly to the command line and waits for the process to finish."""
        submiting = subprocess.Popen(commander,shell=True)
        submiting.wait()

parser=argparse.ArgumentParser()
parser.add_argument("--outdir",type=str,default=None)
parser.add_argument("--files",nargs="+",type=str,default=None)

args=parser.parse_args()

####################################
if not os.path.exists(args.outdir):
   os.makedirs(args.outdir)

samples=" ".join(args.files)
idr_cmd="{} --samples {} --input-file-type narrowPeak --plot --verbose --output-file {} ".format(idr,samples,args.outdir+"/"+"idrValues.txt")
submitter(idr_cmd)
print("INFO : Done!")
