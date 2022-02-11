
options(stringsAsFactors = F)
library(tidyverse)
library(nlme)


# read in phenotyping data
lemna <- read_csv('../../002.prepare_growthData/results/rawdata_combined_annotation_processed.csv') %>%
  mutate(accession = as.factor(accession))
# load the power-law mixed model
fit.nlme <- get(load('../results/full_mixedmodel.rda'))

# read in phenotypes per accession
pheno_accession <- read_csv('../results/phenotypes.csv')

# phenotypes per individual plant
fit.nlme.re <- ranef(fit.nlme)

pheno_ID <- map(unique(lemna$ID), function(ID){
  acn <-  filter(lemna, ID == !!ID) %>% pull(accession) %>% unique()
  if (length(acn) > 1){print(paste0('more than one accession detected for ID: ', ID)); next}
  
  temp <- filter(lemna, ID == !!ID) %>% pull(temperature) %>% unique()
  if (length(temp) > 1){print(paste0('more than one temperature detected for ID: ', ID)); next}
  
  exp <- paste(strsplit(as.character(ID), split = '_')[[1]][3:4], collapse = '_')
  
  M0 <- filter(pheno_accession, accession == !!acn) %>% pull(M0) + fit.nlme.re$experiment[exp, 'M0.(Intercept)'] + fit.nlme.re$ID[paste(exp, ID, sep = '/'), 'M0.(Intercept)']
  
  r <- filter(pheno_accession, accession == !!acn) %>% pull(paste0('r_', temp)) + fit.nlme.re$experiment[exp, 'r.(Intercept)'] + fit.nlme.re$ID[paste(exp, ID, sep = '/'), 'r.(Intercept)']
  
  beta <- filter(pheno_accession, accession == !!acn) %>% pull(beta) + fit.nlme.re$experiment[exp, 'beta'] + fit.nlme.re$ID[paste(exp, ID, sep = '/'), 'beta']
    
  tbl <- tibble('ID' = ID,
                'accession' = acn,
                'temperature' = temp,
                'M0' = M0,
                'r' = r,
                'beta' = beta)
  
  return(tbl)
}) %>%
  bind_rows()

write_csv(pheno_ID, file = '../results/phenotypes_ID.csv')


