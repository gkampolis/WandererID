# Intro Comments ----------------------------------------------------------

# Purpose: Script to evaluate a Random Forest (rf) learner with optimal
# hyperparameters, as determined in previous steps.
# Author: Georgios Kampolis
# For: Marine Scotland Science
# Comments: As part of RGU MSc course in Data Science

# Details: This script is called by Main.R in the root folder of the project.

# Evaluation --------------------------------------------------------------

set.seed(seed = seed)

rfEvalResults <- resample(
  learner = rfOptLearner,
  task = dataTask,
  resampling = resamplingSchemeEval,
  measures = measuresSetEval,
  show.info = FALSE
)


# Save results ------------------------------------------------------------

saveRDS(rfEvalResults, compress = FALSE, 
        file = here::here("ModelFiles","rfOptLearnerEvalResults.rds")
)

# Notify ------------------------------------------------------------------

beepr::beep(1)

print("Random Forest evaluation results are saved!")
