#!/usr/bin/env bash
# SLURM
#SBATCH --mem=15GB
#SBATCH --time=4:00:00
#SBATCH --output=999.logs/prepareVCF_%A_%a.log

# prepare the 1001genomes VCF file to be further processed into bimbam genotype file for gemma

# MODULES
ml bcftools/1.9-foss-2018b
ml tabix/0.2.6-gcccore-7.3.0

VCF=001.data/1001genomes_snp-short-indel_only_ACGTN.vcf.gz 
VCFbial=${VCF/.vcf.gz/.bial.vcf.gz}

# index input vcf file
tabix -p vcf $VCF

# filter for bi-allelic SNPs
bcftools view -m2 -M2 -v snps --threads 10 --output-type z --output-file $VCFbial $VCF

# index the vcf file for easier querying
tabix -p vcf $VCFbial

