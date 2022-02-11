#!/usr/bin/env bash

OUTDIR=007.GWAS/results/
ANNOT=SNPannotation.csv

# combine per chromosome genotypes
cat ${OUTDIR}genotypes_chr*.csv > ${OUTDIR}genotypes.csv
rm ${OUTDIR}genotypes_chr*.csv

# make SNP annotation file
awk -F',' '{split($1,a,"_"); print $1,a[2],substr(a[1],4)}' ${OUTDIR}genotypes.csv > ${OUTDIR}${ANNOT}

