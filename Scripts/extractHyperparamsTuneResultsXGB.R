# Intro Comments ----------------------------------------------------------

# Purpose: Script to extract tuning results for XGBoost (xgb).
# Author: Georgios Kampolis
# For: Marine Scotland Science
# Comments: As part of RGU MSc course in Data Science

# Details: This script is called by Main.R in the root folder of the project.


# Results extraction ------------------------------------------------------

## Tuning was based on repeated CV (5 folds with 5 repeats) so there are 25
## results to extract. This is generalised via:
## length(xgbHyperparamsResults$extract)

## Similarly there were 4 measures specified for the tuning, generalised via:
## length(measuresSet)

## Initialize dataframe
xgbTuneResults <- data.frame(
  init = c(1L:length(measuresSet)),
  stringsAsFactors = FALSE
)

## Extract results
for (iteration in 1L:length(xgbHyperparamsResults$extract)) {
  temp <- xgbHyperparamsResults$extract[[iteration]]$y %>% as.data.frame()
  names(temp) <- paste0(iteration)
  xgbTuneResults <<- cbind(xgbTuneResults, temp, deparse.level = 0)
}

# Remove initialization values, transpose and convert row names to first column
xgbTuneResults <- xgbTuneResults %>%
  select(- init) %>%
  t() %>% as.data.frame() %>% # transpose changes the type
  tibble::rownames_to_column("i") %>% 
  mutate(i = as.integer(i))

# Apply proper names to columns
names(xgbTuneResults) <- c(
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
xgbMaxAccIter <- findBestIter(xgbTuneResults)
xgbHyperparamsSelectionMaxAcc <- xgbHyperparamsResults$extract[[xgbMaxAccIter]]$x

# As above, but in terms of balanced accuracy
xgbMaxBalAccIter <- findBestIter(xgbTuneResults, "mean balanced accuracy")
xgbHyperparamsSelectionBalAcc <- xgbHyperparamsResults$extract[[xgbMaxBalAccIter]]$x

# As above, but in terms of logloss
xgbMinLoglossIter <- findBestIter(xgbTuneResults, "mean logloss", F)
xgbHyperparamsSelectionLogloss <- xgbHyperparamsResults$extract[[xgbMinLoglossIter]]$x

# As above, but in terms of kappa
xgbMaxKappaIter <- findBestIter(xgbTuneResults, "mean kappa")
xgbHyperparamsSelectionKappa <- xgbHyperparamsResults$extract[[xgbMaxKappaIter]]$x

# Notify user of selection ------------------------------------------------

message(
  paste0("Best iteration in terms of accuracy for XGBoost: ",
         xgbMaxAccIter
  )
)

message("Optimal hyperparameters selected in terms of accuracy:")
xgbHyperparamsSelectionMaxAcc %>% as.data.frame() %>% print()

message("Results for other measures have been saved as well.")

# Save table of tuning results --------------------------------------------

readr::write_csv(
  xgbTuneResults,
  here::here("ResultsReports","xgbTuningResults.csv")
)


# Clean up ----------------------------------------------------------------

rm(temp, iteration)
