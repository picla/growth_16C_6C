# data files

## general data
[1001genomes-accessions.csv](1001genomes-accessions.csv)
    Accession meta-information such as 'name', 'collection coordinates', 'genetic subpopulation'.
    Data expands to the whie [1001 genomes collection](https://www.1001genomes.org).

[2029_modified_MN_SH_wc2.0_30s_bilinear.csv](2029_modified_MN_SH_wc2.0_30s_bilinear.csv)
    [Climate data](https://www.worldclim.org) for all accessions (expands to 2029 accessions from [1001 genomes collection](https://www.1001genomes.org) and the [RegMap panel](https://pubmed.ncbi.nlm.nih.gov/22231484/)).

[outliers.csv](outliers.csv)
    list of all outlier datapoints (individual plants at a spceific day). Upon visual inspection of teh growth trajectory of each plant, we determined outliers as datapoints that showed negative growth or very abbarrant growth trajectories over time (sudden drops in size). Cause of this negative growth is the image algorithm not detecting the complete rosette at certain timepoints.

## growth

## seed size
[seed_size_swedes_lab_updated.csv](seed_size_swedes_lab_updated.csv)
    Seed sizes of a set of swedish accessions. Methodology is described in Methods and Materials. Image analysis scripts can be found [here](https://github.com/vevel/seed_size).

## transcriptome
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
