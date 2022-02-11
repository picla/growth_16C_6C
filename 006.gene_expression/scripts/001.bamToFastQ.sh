#!/bin/sh

# SLURM # 
#SBATCH --mem=10GB
#SBATCH --time=01:00:00
#SBATCH --array=1-60

# MODULES #
ml bedtools/2.27.1-foss-2018b
ml samtools/1.10-foss-2018b

# DATA #
i=$SLURM_ARRAY_TASK_ID
DATAdir=001.data
BAMfiles=(${DATAdir}/001.bamfiles/*.bam)
FASTQdir=006.gene_expression/results/001.fastqfiles

mkdir -p $FASTQdir

BAM=${BAMfiles[$i]}
BAMbase=$(basename -s .bam $BAM)

BAMsort=${DATAdir}/001.bamfiles/${BAMbase}.qsort.bam
FASTQ1=${FASTQdir}/${BAMbase}.end1.fastq
FASTQ2=${FASTQdir}/${BAMbase}.end2.fastq

# sort bam file in order to make 2 fastq files -> paired-end data
samtools sort -n $BAM -o $BAMsort

echo 'bamfile sorted'

# split sorted BAM file into two fastq files (paired-end data)
bedtools bamtofastq -i $BAMsort -fq $FASTQ1 -fq2 $FASTQ2

echo 'bamtofastq finished'


