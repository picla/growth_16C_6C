#!/bin/python

import os
os.environ["NUMEXPR_MAX_THREADS"]="272"
import allel
import pandas as pd
import numpy as np
import argparse

# parameters
parser = argparse.ArgumentParser(description = 'Parse arguments to prepare genotype and phenotype files for GWAS using GEMMA')
parser.add_argument('-c', '--chromosome', help = 'Chromosome number', default = None)
parser.add_argument('-p', '--phenotype', help = 'filepath for csv files containing phenotype(s)', required=True)
parser.add_argument('-g', '--genotype', help='fielpath for vcf file to be processed. Buidl index with tabix in advance to speed up filereading', required=True)
parser.add_argument('-o', '--outdir', help='directory to store output files', required=True)
#parser.add_argument('-a', '--accessions', help='filepath wiht a list of accessions to select', required = False)
args = parser.parse_args()

# accession selection
#acnSelection = pd.read_csv(args.accessions, header = None)
#acnSelection = np.array(acnSelection.iloc[:,0]) 

# phenotype
phenoIn = pd.read_csv(args.phenotype)

# prepare phenotype for GEMMA
pheno = phenoIn.sort_values('accession')
# save sorted accession list for selecting and sorting genotypes
acns = np.array(pheno.accession)
acns = [str(acn) for acn in acns]
#acns = [str(acn) for acn in acns if acn in acnSelection]
# save phenotype names
phenotypes = pheno.columns.values[1:]
np.savetxt(f"{args.outdir}phenotype.names.csv", phenotypes, fmt='%s')
# remove header and accession
phenoOut = pheno.iloc[:,1:].to_numpy()
np.savetxt(f"{args.outdir}phenotype.data.csv", phenoOut, delimiter = ', ')
# save accession list in order
np.savetxt(f"{args.outdir}accessions.csv", acns, delimiter = ', ', fmt = '%s')

# genotype
# processed with prepare_VCF.sh (remove indels with bcftools and index with tabix)
genoIn = allel.read_vcf(args.genotype, region = args.chromosome, samples = acns, fields = ['samples', 'calldata/GT', 'variants/CHROM', 'variants/POS', 'variants/REF', 'variants/ALT'])

# filter for variable positons (maf > 0)
gt = allel.GenotypeArray(genoIn['calldata/GT'])
# allele count
ac = gt.count_alleles()
# remove non-segregating alleles (0 count for REF or ALT allele)
segregants = ac.is_segregating()
gtSeg = gt[segregants]
chrom = genoIn['variants/CHROM'][segregants]
pos = genoIn['variants/POS'][segregants]
ref = genoIn['variants/REF'][segregants]
alt = genoIn['variants/ALT'][segregants]
# check that all negative values are gone now (should be only 0 and 1)
# homozygous 0 become 0, heterzygous gets removed, homozygous 1 becomes 2 i.o.w sum genotype values and remove 1's (check unique values for 0,1 and 2)
snpMatrix = gtSeg.to_n_alt()

# order snpMatrix according order of accessions in phenotype data
idx = [acns.index(a) for a in genoIn['samples']]
snpMatrix[:, idx]

# convert into bimbam format
snpID = [f"chr{c}_{p}" for c, p in zip(chrom, pos)]
genoOut = np.array([[i, r,  a[0]] + list(g) for i, r, a, g in zip(snpID, ref, alt, snpMatrix)])

# write to bimbam file
if (args.chromosome == None):
    np.savetxt(f"{args.outdir}genotypes.csv", genoOut, delimiter = ', ', fmt = '%s')
else:
    np.savetxt(f"{args.outdir}genotypes_chr{args.chromosome}.csv", genoOut, delimiter = ', ', fmt = '%s')





