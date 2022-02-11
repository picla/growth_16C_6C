#!/bin/python

'''
Original by Michael Schon:
adjustements by Pieter Clauw:
open([fileX]) -> open([fileX], 'r')
if 'Chr' in chrom:
    chrom = chrom[-1]
'''

import os,re
import argparse

desc = (
    "Takes a FASTA file of a genome and a VCF file of SNPs.\n"
    "For every location with a SNP, the FASTA sequence is changed.\n"
)

parser = argparse.ArgumentParser(description=desc)

# add arguments to the ArgumentParser
parser.add_argument(
    'FASTA',
    type=str, help='input FASTA file'
)
parser.add_argument(
    'VCF',
    type=str, help='input VCF file'
)
parser.add_argument(
    '-O', '--output', dest='OUTPUT',
    type=str, help='output filename',
    default='pseudo.fa'
)
parser.add_argument(
    '--row_length', dest='ROWLEN', type=int, default=60,
    help='Number of nucleotides per row in output file.'
)
args = parser.parse_args()

# ENVIRONMENT SETUP #
#####################

def import_genome(genome_FASTA, split_on=' ', keep_case=True):
    """Reads FASTA file to a dict."""
    genome = {}
    chrom = 'none'
    genome_file = open(genome_FASTA, 'r')
    for line in genome_file:
        line = line.rstrip()
        if len(line)==0:
            continue
        if line[0] == '>':
            if chrom != 'none':
                genome[chrom] = ''.join(current_lines)
            chrom = line[1:].split(split_on)[0]
            if 'Chr' in chrom:
                chrom = chrom[-1]
            current_lines = []
            continue
        
        if not keep_case:
            line = line.upper()
        current_lines.append(line)
    genome[chrom] = ''.join(current_lines)
    return genome


# ANALYZE DATA #
################
if __name__ == '__main__':
    FASTA = import_genome(args.FASTA)
    PSEUDO = {}
    polycount = {}
    for k in FASTA.keys():
        polycount[k] = 0
        PSEUDO[k] = list(FASTA[k])
    
    polymorphisms={}
    intersect=open(args.VCF, 'r')
    curchrom=0
    print("Loading polymorphism index...")
    for line in intersect:
        if line[0] in ['#','C']:
            continue
        
        l=line.rstrip().split('\t')
        chrom,pos,ID,ref,alt=l[0:5]
        if chrom!=curchrom:
            polymorphisms[chrom]={}
            curchrom=chrom
        
        if len(ref)==1 and len(alt)==1: # Require SNP, disallow indels
            polymorphisms[chrom][pos]=(ref,alt)
            polycount[chrom] += 1
            assert PSEUDO[chrom][int(pos)-1] == ref # REF must match the input genome sequence
            PSEUDO[chrom][int(pos)-1] = alt
    
    print("Number of polymorphisms:")
    for k in sorted(polycount.keys()):
        v = polycount[k]
        print('{}\t{}'.format(k,v))

    outfile=open(args.OUTPUT,"w")
    l = args.ROWLEN
    for k in sorted(PSEUDO.keys()):
        v = ''.join(PSEUDO[k])
        outfile.write('>{}\n'.format(k))
        outfile.write('\n'.join([v[i:i+l] for i in range(0,len(v),l)]))
        outfile.write('\n')
    
    outfile.close()
    print("Pseudogenome saved to {}".format(args.OUTPUT))
    
