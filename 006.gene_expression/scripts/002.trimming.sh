#!/bin/sh

# SLURM #
#SBATCH --time=01:00:00
#SBATCH --mem=1GB
#SBATCH --array=0-94:2
#SBATCH --cpus-per-task=15

# MODULES #
ml trim_galore/0.6.2-foss-2018b-python-3.6.6

# DATA #
i=$SLURM_ARRAY_TASK_ID
DATAdir=001.data
FASTQfiles=(006.gene_expression/results/001.fastqfiles/*.fastq)
OUTdir=006.gene_expression/results/002.fastq_trimmed/

FASTQ1=${FASTQfiles[$i]}
FASTQ2=${FASTQ1/end1/end2}

# start trim_galor
echo 'starting trim_galore on files:'
echo $FASTQ1
echo $FASTQ2

trim_galore -q 10 \
	--fastqc \
	--output_dir $OUTdir \
	--phred33 \
	--paired \
	--nextera \
	--cores 4 \
	$FASTQ1 $FASTQ2

