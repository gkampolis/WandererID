# Intro Comments ----------------------------------------------------------

# Purpose: Script to evaluate hyperparameters' combinations for Random Forest.
# Author: Georgios Kampolis
# For: Marine Scotland Science
# Comments: As part of RGU MSc course in Data Science

# Details: This script is called by Main.R in the root folder of the project.


# Run nested resampling ---------------------------------------------------

set.seed(seed = seed)

rfHyperparamsResults <- mlr::resample(
  learner = rfLearner, # Contains inner level of nested resampling
  task = dataTask,
  measures = measuresSet,
  resampling = resamplingSchemeOuter, # Outer level of nested resampling
  extract = getTuneResult,
  show.info = FALSE
)


# Save results ------------------------------------------------------------

saveRDS(rfHyperparamsResults, compress = FALSE,
        file = here::here("ModelFiles","rfHyperparamsResults.rds")
)

# Notify ------------------------------------------------------------------

beepr::beep(1)
print("Random Forest tuning results are saved!")
