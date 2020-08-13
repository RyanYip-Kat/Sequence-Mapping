import os
import argparse

def make(args):
    
    files=[file for file in os.listdir(args.align_root) if not "STAR" in file]
    outname="Aligned.sorted.out.sam" if args.sort else "Aligned.out.sam"
    for i,sample in enumerate(files):
        file=os.path.join(args.align_root,sample,outname)
        output=os.path.join(args.align_root,sample)
        command=args.featureCounts + " " + "-a" + " " +args.gtf + \
                " " + "-o" + " " + os.path.join(output,"featureCounts.txt") + \
                " " + "-T" + " " + str(args.threads) + \
                " " + "-d" + " " + str(args.min_length) + \
                " " + "-D" + " " + str(args.max_length) + \
                " " + "-g" + " " + "gene_id" +  \
                " " + "-t" + " " + "exon" + \
                " " + file
        log="featureCounts.sh"
        with open(os.path.join(output,log),"w") as f:
           f.write(command)
           f.write("\n")
           f.write("\n")
           cut= "cut -f 1,7,8,9,10,11,12"+ " " + os.path.join(output,"featureCounts.txt") + \
                   " " + ">" + " " + os.path.join(output,"featureMatrix.txt")
           f.write(cut)
           f.close()
        print("The No.{} command is : {}\n".format(i,command))
        #os.system("nohup" + " " + "bash" + " " + os.path.join(output,log) + " " + "&")

if __name__=="__main__":
     parser=argparse.ArgumentParser("STAR ON EACH GROUP OR ALL,AND THEN FEATURECOUNTS")
     parser.add_argument("--align_root",type=str,default="",help="The root path of aligned files")
     parser.add_argument("--featureCounts",type=str,default="/home/ye/Software/Python/location/envs/Align/bin/featureCounts")
     parser.add_argument("--gtf",type=str,default="/home/ye/Data/Zoc/Cell/reference/dna/mouse/gtf/Mus_musculus.GRCm38.95.gtf")

     parser.add_argument("--threads",type=int,default=2)
     parser.add_argument("--min_length",type=int,default=50)
     parser.add_argument("--max_length",type=int,default=600)
     parser.add_argument("--sort", dest='sort', action='store_true')

     args=parser.parse_args()

     make(args)




        

