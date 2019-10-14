# Intro Comments ----------------------------------------------------------

# Purpose: Script to evaluate k-NN learners with optimal
# hyperparameters, as determined in previous steps.
# Author: Georgios Kampolis 
# For: Marine Scotland Science
# Comments: As part of RGU MSc course in Data Science

# Details: This script is called by Main.R in the root folder of the project.


# Max Accuracy hyperparameters --------------------------------------------

set.seed(seed = seed)

## Evaluate 
knnEvalResultsMaxAccParams <- resample(
  learner = knnOptLearnerMaxAccParams,
  task = dataTask,
  resampling = resamplingSchemeEval,
  measures = measuresSetEval,
  show.info = FALSE
)

## Save results
saveRDS(knnEvalResultsMaxAccParams, compress = FALSE, 
        file = here::here(
          "ModelFiles",
          "knnOptLearnerEvalResultsMaxAccParams.rds"
        )
)


# Max Balanced Accuracy hyperparameters -----------------------------------

set.seed(seed = seed)

## Evaluate 
knnEvalResultsMaxBalAccParams <- resample(
  learner = knnOptLearnerMaxBalAccParams,
  task = dataTask,
  resampling = resamplingSchemeEval,
  measures = measuresSetEval,
  show.info = FALSE
)

## Save results
saveRDS(knnEvalResultsMaxBalAccParams, compress = FALSE, 
        file = here::here(
          "ModelFiles",
          "knnOptLearnerEvalResultsMaxBalAccParams.rds"
        )
)


# Min Logloss hyperparameters ---------------------------------------------

set.seed(seed = seed)

## Evaluate 
knnEvalResultsMinLoglossParams <- resample(
  learner = knnOptLearnerMinLoglossParams,
  task = dataTask,
  resampling = resamplingSchemeEval,
  measures = measuresSetEval,
  show.info = FALSE
)

## Save results
saveRDS(knnEvalResultsMinLoglossParams, compress = FALSE, 
        file = here::here(
          "ModelFiles",
          "knnOptLearnerEvalResultsMinLoglossParams.rds"
        )
)

# Notify ------------------------------------------------------------------

beepr::beep(1)

print("k-NN evaluation results are saved!")
