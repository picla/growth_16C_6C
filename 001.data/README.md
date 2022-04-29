# data files

## general data
[1001genomes-accessions.csv](1001genomes-accessions.csv)
    Accession meta-information such as 'name', 'collection coordinates', 'genetic subpopulation'.
    Data expands to the whie [1001 genomes collection](https://www.1001genomes.org).

[2029_modified_MN_SH_wc2.0_30s_bilinear.csv](2029_modified_MN_SH_wc2.0_30s_bilinear.csv)
    [Climate data](https://www.worldclim.org) for all accessions (expands to 2029 accessions from [1001 genomes collection](https://www.1001genomes.org) and the [RegMap panel](https://pubmed.ncbi.nlm.nih.gov/22231484/)).

[outliers.csv](outliers.csv)
    list of all outlier datapoints (individual plants at a spceific day). Upon visual inspection of teh growth trajectory of each plant, we determined outliers as datapoints that showed negative growth or very abbarrant growth trajectories over time (sudden drops in size). Cause of this negative growth is the image algorithm not detecting the complete rosette at certain timepoints.

[Araport11_GFF3_genes_transposons.201606.ChrM_ChrC_FullName.gtf](Araport11_GFF3_genes_transposons.201606.ChrM_ChrC_FullName.gtf)
    GTF file used in transcriptome analyses.

[kinship_ibs_binary_mac5.h5py](kinship_ibs_binary_mac5.h5py)
    The kinship matrix used for population structure correction of the climate correlations.



## growth
[rawdata_combined_annotation.txt](rawdata_combined_annotation.txt)
    Raw phenotyping data with meta-information annotated.

## seed size
[seed_size_swedes_lab_updated.csv](seed_size_swedes_lab_updated.csv)
    Seed sizes of a set of swedish accessions. Methodology is described in Methods and Materials. Image analysis scripts can be found [here](https://github.com/vevel/seed_size).

## transcriptome
[RNAseq_samples.txt](RNAseq_samples.txt)
    Meta-information for the RNA-seq samples. 

[CBF_regulon_DOWN_ParkEtAl2015.txt](CBF_regulon_DOWN_ParkEtAl2015.txt)

[CBF_regulon_UP_ParkEtAl2015.txt](CBF_regulon_UP_ParkEtAl2015.txt)
    List of genes that are up/down regulated upon CBF1, CBF2 or CBF3 overexpression and correspondingly up/down regulated upon cold exposure ([Park et al., 2015](https://onlinelibrary.wiley.com/doi/10.1111/tpj.12796)).

[HSFC1_regulon_ParkEtAl2015.txt](HSFC1_regulon_ParkEtAl2015.txt)
    HSFC1-regulon genes as described by [Park et al., 2015](https://onlinelibrary.wiley.com/doi/10.1111/tpj.12796).

[ZAT12_downregulated_table10.csv](ZAT12_downregulated_table10.csv)

[ZAT12_upregulated_table9](ZAT12_upregulated_table9.csv)

## metabolome
[metabolic_distance.csv](metabolic_distance.csv)
    Metabolic distance for all accessions as determined by [Weiszmann et al. 2020](https://www.biorxiv.org/content/10.1101/2020.09.24.311092v1)

## files to download
The analyses require certain datafiles that are larger than 100MB.
[all_chromosomes_binary_gzip_attrs.hdf5](https://1001genomes.org/data/GMI-MPI/releases/v3.1/SNP_matrix_imputed_hdf5/)
    This file contains the SNP-matrix for all accessions from [the 1001genomes project](https://1001genomes.org/).

[Araport11_GFF3_genes_transposons.201606.gff](https://www.arabidopsis.org/download_files/Genes/Araport11_genome_release/archived/Araport11_GFF3_genes_transposons.201606.gff.gz)
    GFF file used for the gene selection after GWAS.