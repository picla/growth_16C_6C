
# SETUP #
options(stringsAsFactors = F)
library(tidyverse)
library(nlme)

# DATA #


# read in phenotyping data
lemna <- read_csv('../../002.prepare_growthData/results/rawdata_combined_annotation_processed.csv') %>%
  mutate(accession = as.factor(accession))

## SELF START POWER LAW ##
## self start function from Paine et al., 2012. Methods Ecol. Evol.
fmla.pow <- as.formula("~(M0^(1-beta) + r*x*(1-beta))^(1/(1-beta))")
Init.pow <- function(mCall, LHS, data){
  xy <- sortedXyData(mCall[["x"]], LHS, data)
  if(nrow(xy) < 4) {stop("Too few distinct x values to fit a power-law")}
  M0   <- min(xy$y)		              # Use the minimum y value as an initial guess for M0
  r    <- coef(lm(log(y) ~ x, xy))[2]    # Use the slope from a log fit to the data as an initial guess for r
  beta <- 0.9	                          # give initial guess of beta as 0.9. don't use beta = 1, as it's undefined (1/0)
  value <- c(M0, r, beta) 
  names(value) <- mCall[c("M0", "r", "beta")]
  return(value)
}
SS.pow  <- selfStart(fmla.pow, initial = Init.pow, parameters = c("M0", "r", "beta"))

# MODEL #
# The model was built-up stepwise with added complexity at each step and using starting values based on the previous model.
# models were each time compared pairwise with the anova function.
# the final model fit.nlme.4 had the lowest AIC scores and was therefore used for further analyses.
fit.lis <- nlsList(Area.10000px ~ SS.pow(DAS_decimal, M0, r, beta) | ID,
                   data = lemna,
                   control = nls.control(maxiter = 1000,
                                         warnOnly = T))

# create nlme
fit.nlme.1 <- nlme(fit.lis,
                   control = nlmeControl(msMaxIter = 1000,
                                         maxIter = 1000,
                                         opt = 'nlminb',
                                         pnlsTol = 1,
                                         msVerbose = T),
                   data = lemna,
                   verbose = T)


n.accessions <- length(unique(lemna$accession)) - 1
start.vals.2 = c(fixef(fit.nlme.1)[['M0']], rep(0, n.accessions),
                 fixef(fit.nlme.1)[['r']], rep(0, n.accessions),
                 0, rep(0, n.accessions),
                 fixef(fit.nlme.1)[['beta']])


fit.nlme.2 <- update(fit.nlme.1,
                     fixed = list(M0 ~ accession, r ~ accession * temperature, beta ~ 1),
                     start = start.vals.2,
                     control = nlmeControl(msMaxIter = 1000,
                                           maxIter = 1000,
                                           opt = 'nlminb',
                                           #opt = 'nlm',
                                           pnlsTol = 1,
                                           msVerbose = T),
                     data = lemna,
                      verbose = T)


fit.nlme.3 <- update(fit.nlme.2,
                     correlation = corCAR1(form = ~ DAS_decimal),
                     start = fixef(fit.nlme.2),
                     control = nlmeControl(msMaxIter = 1000,
                                           maxIter = 1000,
                                           opt = 'nlminb',
                                           pnlsTol = 0.1,
                                           msVerbose = T),
                     data = lemna,
                     verbose = T)

fit.nlme.4 <- nlme(Area.10000px ~ SS.pow(DAS_decimal, M0, r, beta),
                   fixed = list(M0 ~ accession, r ~ accession * temperature, beta ~ 1),
                   random = list(experiment = pdMat(M0 + r + beta ~ 1),
                                 ID = pdMat(M0 + r + beta ~ 1)),
                   correlation = corCAR1(form = ~ DAS_decimal),
                   start = fixef(fit.nlme.3),
                   control = nlmeControl(msMaxIter = 1000,
                                         maxIter = 1000,
                                         opt = 'nlminb',
                                         #opt = 'nlm',
                                         pnlsTol = 1,
                                         msVerbose = T),
                   data = lemna,
                   verbose = T)

save(fit.nlme.4, file = paste0('/groups/nordborg/projects/cold_adaptation_16Cvs6C/002.growth/002.nonlinear_growthParameters/003.results/001.nonlinear_nlme/002.powerLaw_full/full_mixedModel.rda'))

