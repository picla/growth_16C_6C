#!/usr/bin/env bash

# SLURM
#SBATCH --mem=50GB
#SBATCH --time=3:00:00
#SBATCH --array=1-5


# ENVIRONMENT #
source activate /users/pieter.clauw/.conda/envs/allel

ml tabix/0.2.6-gcccore-7.3.0

# DATA #
i=$SLURM_ARRAY_TASK_ID
PHENO=001.data/phenotypes.csv
GENO=001.data/1001genomes_snp-short-indel_only_ACGTN.bial.vcf.gz 
OUTDIR=007.GWAS/results/

PREPpy=007.GWAS/scripts/002.gemma_prep_geno_pheno.py

python $PREPpy -c $i -p $PHENO -g $GENO -o $OUTDIR


