#!/usr/bin/env bash

# SLURM
#SBATCH --time=02:00:00
#SBATCH --mem=20GB
#SBATCH --cpus-per-task=4
#SBATCH --array=1-48

# MODULES #
ml salmon/1.2.1-foss-2018b

# DATA #
i=$SLURM_ARRAY_TASK_ID
WORK=006.gene_expression/results/
SAMPLES=001.data/RNAseq_samples.txt
FASTQdir=006.gene_expression/results/002.fastq_trimmed/
RESULTSdir=${WORK}006.quantification_salmon/

# Select accessions and index
BASE=$(awk '{print $5}' $SAMPLES | sed -n ${i}p)
ACN=$(awk '{print $2}' $SAMPLES | sed -n ${i}p)
OUTdir=${RESULTSdir}${BASE}_quantification_salmon/

INDEX=${WORK}005.indices/salmonIndex_${ACN}

# select fastq files of given sample
END1=${FASTQdir}${BASE}.end1_val_1.fq
END2=${FASTQdir}${BASE}.end2_val_2.fq

# PREP #
mkdir -p $OUTdir

salmon quant -i $INDEX -l ISR --seqBias --gcBias --writeUnmappedNames --validateMappings --rangeFactorizationBins 4 \
	-p 4 \
	-1 $END1 \
	-2 $END2 \
	-o $OUTdir


