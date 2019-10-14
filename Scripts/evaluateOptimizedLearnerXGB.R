# Intro Comments ----------------------------------------------------------

# Purpose: Script to evaluate XGBoost learners with optimal
# hyperparameters, as determined in previous steps.
# Author: Georgios Kampolis
# For: Marine Scotland Science
# Comments: As part of RGU MSc course in Data Science

# Details: This script is called by Main.R in the root folder of the project.


# Max Accuracy hyperparameters --------------------------------------------

set.seed(seed = seed)

## Evaluate 
xgbEvalResultsMaxAccParams <- resample(
  learner = xgbOptLearnerMaxAccParams,
  task = dataTask,
  resampling = resamplingSchemeEval,
  measures = measuresSetEval,
  show.info = FALSE
)

## Save results
saveRDS(xgbEvalResultsMaxAccParams, compress = FALSE, 
        file = here::here(
          "ModelFiles",
          "xgbOptLearnerEvalResultsMaxAccParams.rds"
        )
)


# Max Balanced Accuracy hyperparameters -----------------------------------

set.seed(seed = seed)

## Evaluate 
xgbEvalResultsMaxBalAccParams <- resample(
  learner = xgbOptLearnerMaxBalAccParams,
  task = dataTask,
  resampling = resamplingSchemeEval,
  measures = measuresSetEval,
  show.info = FALSE
)

## Save results
saveRDS(xgbEvalResultsMaxBalAccParams, compress = FALSE, 
        file = here::here(
          "ModelFiles",
          "xgbOptLearnerEvalResultsMaxBalAccParams.rds"
        )
)


# Min Logloss hyperparameters ---------------------------------------------

set.seed(seed = seed)

## Evaluate 
xgbEvalResultsMinLoglossParams <- resample(
  learner = xgbOptLearnerMinLoglossParams,
  task = dataTask,
  resampling = resamplingSchemeEval,
  measures = measuresSetEval,
  show.info = FALSE
)

## Save results
saveRDS(xgbEvalResultsMinLoglossParams, compress = FALSE, 
        file = here::here(
          "ModelFiles",
          "xgbOptLearnerEvalResultsMinLoglossParams.rds"
        )
)

# Notify ------------------------------------------------------------------

beepr::beep(1)

print("XGBoost evaluation results are saved!")
