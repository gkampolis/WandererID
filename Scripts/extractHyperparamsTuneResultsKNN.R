# Intro Comments ----------------------------------------------------------

# Purpose: Script to extract tuning results for k-NN.
# Author: Georgios Kampolis
# For: Marine Scotland Science
# Comments: As part of RGU MSc course in Data Science

# Details: This script is called by Main.R in the root folder of the project.


# Results extraction ------------------------------------------------------

## Tuning was based on repeated CV (5 folds with 5 repeats) so there are 25
## results to extract. This is generalised via:
## length(knnHyperparamsResults$extract)

## Similarly there were 4 measures specified for the tuning, generalised via:
## length(measuresSet)


## Initialize dataframe
knnTuneResults <- data.frame(
  init = c(1L:length(measuresSet)),
  stringsAsFactors = FALSE
)

## Extract results
for (iteration in 1L:length(knnHyperparamsResults$extract)) {
  temp <- knnHyperparamsResults$extract[[iteration]]$y %>% as.data.frame()
  names(temp) <- paste0(iteration)
  knnTuneResults <<- cbind(knnTuneResults, temp, deparse.level = 0)
}

# Remove initialization values, transpose and convert row names to first column
knnTuneResults <- knnTuneResults %>%
  select(- init) %>%
  t() %>% as.data.frame() %>% # transpose converts to matrix
  tibble::rownames_to_column("i") %>% 
  mutate(i = as.integer(i))

# Apply proper names to columns
names(knnTuneResults) <- c(
  "iteration",
  "mean accuracy", "mean balanced accuracy",
  "mean logloss", "mean kappa"
)

# Determine best iteration(s) ---------------------------------------------

# Function to find iteration with  best score on measures. The function assumes
# that row names correspond to iterations i.e. 1st row containes first
# iteration. This is the default for this script.
findBestIter <- function(df, measure = "mean accuracy", maximize = T) {
  if (maximize) { # max of measure is best (such as accuracy)
    bestIter <- which.max(df[[measure]])
  } else { # min of measure is best (such as logloss)
    bestIter <- which.min(df[[measure]])
  }
  return(bestIter)
}

# Find best iteration in terms of accuracy & extract hyperparams in
# mlr-compatible format:
knnMaxAccIter <- findBestIter(knnTuneResults)
knnHyperparamsSelectionMaxAcc <- knnHyperparamsResults$extract[[knnMaxAccIter]]$x

# As above, but in terms of balanced accuracy
knnMaxBalAccIter <- findBestIter(knnTuneResults, "mean balanced accuracy")
knnHyperparamsSelectionBalAcc <- knnHyperparamsResults$extract[[knnMaxBalAccIter]]$x

# As above, but in terms of logloss
knnMinLoglossIter <- findBestIter(knnTuneResults, "mean logloss", F)
knnHyperparamsSelectionLogloss <- knnHyperparamsResults$extract[[knnMinLoglossIter]]$x

# As above, but in terms of kappa
knnMaxKappaIter <- findBestIter(knnTuneResults, "mean kappa")
knnHyperparamsSelectionKappa <- knnHyperparamsResults$extract[[knnMaxKappaIter]]$x

# Notify user of selection ------------------------------------------------

message(
  paste0("Best iteration in terms of accuracy for k-NN: ",
         knnMaxAccIter
  )
)

message("Optimal hyperparameters selected in terms of accuracy:")
knnHyperparamsSelectionMaxAcc %>% as.data.frame() %>% print()

message("Results for other measures have been saved as well.")

# Save table of tuning results --------------------------------------------

readr::write_csv(
  knnTuneResults,
  here::here("ResultsReports","knnTuningResults.csv")
)


# Clean up ----------------------------------------------------------------

rm(temp, iteration)
