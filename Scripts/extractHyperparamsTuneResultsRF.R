# Intro Comments ----------------------------------------------------------

# Purpose: Script to extract tuning results for Random Forest (rf).
# Author: Georgios Kampolis
# For: Marine Scotland Science
# Comments: As part of RGU MSc course in Data Science

# Details: This script is called by Main.R in the root folder of the project.


# Results extraction ------------------------------------------------------

## Tuning was based on repeated CV (5 folds with 5 repeats) so there are 25
## results to extract.

## Initialize dataframe
rfTuneResults <- data.frame(
  init = c(1:4),
  stringsAsFactors = FALSE
)

## Extract results
for (iteration in 1L:25L) {
  temp <- rfHyperparamsResults$extract[[iteration]]$y %>% as.data.frame()
  names(temp) <- paste0(iteration)
  rfTuneResults <<- cbind(rfTuneResults, temp, deparse.level = 0)
}

# Remove initialization values, transpose and convert row names to first column
rfTuneResults <- rfTuneResults %>%
  select(- init) %>%
  t() %>% as.data.frame() %>% # transpose converts to matrix
  tibble::rownames_to_column("i") %>% 
  mutate(i = as.integer(i))

# Apply proper names to columns
names(rfTuneResults) <- c(
  "iteration",
  "mean accuracy", "mean balanced accuracy",
  "mean logloss", "mean kappa"
)

# Find iteration with maximum accuracy
rfMaxAccIter <- rfTuneResults %>% 
  filter(`mean accuracy` == max(`mean accuracy`)) %>% 
  select(iteration) %>% 
  as.integer()

# In this case, the same iteration is the best performing one across all
# measures. For a more complicated solution where not one clear iteration is
# best, see the equivalent script for XGBoost
# "extractHyperparamsTuneResultsXGB.R".

# Extract optimal hyperparameters only in mlr-compatible format
rfHyperparamsSelection <- rfHyperparamsResults$extract[[rfMaxAccIter]]$x


# Notify user of selection ------------------------------------------------

message(
  paste0("Best iteration in terms of accuracy for random forest: ",
  rfMaxAccIter
  )
)

message("Optimal hyperparameters selected:")
rfHyperparamsSelection %>% as.data.frame() %>% print()


# Save table of tuning results --------------------------------------------

readr::write_csv(
  rfTuneResults,
  here::here("ResultsReports","rfTuningResults.csv")
)


# Clean up ----------------------------------------------------------------

rm(temp, iteration)
