#!/usr/bin/env bash

# SLURM
#SBATCH --time=01:00:00
#SBATCH --mem=10GB
#SBATCH --array=0-6


# MODULES #
ml python/3.8.6-gcccore-10.2.0

PSEUDOGENIZE=006.gene_expression/scripts/004.pseudogenome.py

# DATA #
i=$SLURM_ARRAY_TASK_ID
FASTA=001.data/TAIR10_chr_all.fas

VCFfiles=(001.data/001.vcf/1001genomes_snp-short-indel_only_ACGTN_*.vcf)
VCF=${VCFfiles[$i]}
OUT=${VCF/.vcf/_pseudoTAIR10.fasta}

# MAKE PSEUDO GENOME #
python $PSEUDOGENIZE -O $OUT $FASTA $VCF

# add Chr as prefix for chromosome names
awk '/>./{gsub(/>/,">Chr")}{print}' $OUT > ${OUT}.tmp
mv ${OUT}.tmp $OUT

# move pseudogenomes to separate folder
mkdir 006.gene_expression/results/003.pseudogenomes/
mv $OUT 006.gene_expression/results/003.pseudogenomes/
