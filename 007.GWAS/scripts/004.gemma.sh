#!/usr/bin/env bash
# SLURM
#SBATCH --mem=30GB
#SBATCH --time=02:00:00
#SBATCH --array=1-5

# run GWAS on growth traits in GEMMA

# load gemma
source activate /users/pieter.clauw/.conda/envs/gemma

DATAdir=007.GWAS/results/
GEMMAdir=007.GWAS/results/
mkdir -p $GEMMAdir

# select phenotype by column id
i=$SLURM_ARRAY_TASK_ID
phenotype=$(sed -n "${i}p" ${DATAdir}phenotype.names.csv)

# genotype
# prepare phenotype and genotype files with custom python script
# gemma_prep_geno_pheno.sh

GENO=${DATAdir}genotypes.csv
ANNOT=${DATAdir}SNPannotation.csv
PHENO=${DATAdir}phenotype.data.csv
K=kinship_${phenotype}

# move to GEMMAdir, where output will be written
cd $GEMMAdir

# kinship
gemma -g $GENO -p $PHENO -n $i -gk 1 -o $K

# GWAS
gemma -g $GENO -a $ANNOT -p $PHENO -n $i -k output/${K}.cXX.txt -maf 0.05 -lmm 4 -o $phenotype