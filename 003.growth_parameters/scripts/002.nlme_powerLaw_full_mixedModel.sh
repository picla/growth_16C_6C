#!/usr/bin/env bash                                                                                                                                         

#SBATCH --time=7-00:00:00
#SBATCH --mem=60GB
#SBATCH --qos=long

# setup #
ml build-env/f2021
ml r/4.0.3-foss-2020b

# run #
Rscript --vanilla 002.growth_parameters/001.scripts/002.nlme_powerLaw_full_mixedModel.r


