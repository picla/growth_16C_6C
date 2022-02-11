#!/usr/bin/env bash

# SLURM
#SBATCH --time=01:00:00
#SBATCH --mem=10GB
#SBATCH --array=0-7

# DATA
i=$SLURM_ARRAY_TASK_ID
accessions=(6909 6017 9728 9559 8242 9888 9433 9075)
acn=${accessions[$i]}

WORK=006.gene_expression/results/
GTF=001.data/Araport11_GFF3_genes_transposons.201606.gtf

# get GENOME
if [ $acn = 6909 ]
then
    GENOME=001.data/TAIR10_chr_all.fas
else
    GENOME=006.gene_expression/results/003.pseudogenomes/1001genomes_snp-short-indel_only_ACGTN_${acn}_pseudoTAIR10.fasta
fi

TRANSCRIPTOME=006.gene_expression/results/004.pseudotranscriptomes/pseudotranscriptome_${acn}.fasta
mdir -p 006.gene_expression/results/004.pseudotranscriptomes/

# MAKE PSEUDO TRANSCRIPTOME
ml samtools/1.10-foss-2018b
samtools faidx $GENOME

ml gffread/0.11.8-gcccore-8.3.0
gffread -w $TRANSCRIPTOME -g $GENOME $GTF