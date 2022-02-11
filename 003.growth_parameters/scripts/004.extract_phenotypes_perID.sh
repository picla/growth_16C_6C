#!/usr/bin/env bash                                                                                                                                         

#SBATCH --time=20:00:00
#SBATCH --mem=60GB
#SBATCH --qos=medium


# setup #
ml build-env/f2021
ml r/4.0.3-foss-2020b

# run #
Rscript --vanilla /groups/nordborg/projects/cold_adaptation_16Cvs6C/002.growth/002.nonlinear_growthParameters/002.scripts/004.extract_phenotypes_perID.r
