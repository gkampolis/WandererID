# Intro Comments ----------------------------------------------------------

# Purpose: Script to create an XGBoost learner.
# Author: Georgios Kampolis
# For: Marine Scotland Science
# Comments: As part of RGU MSc course in Data Science

# Details: This script is called by Main.R in the root folder of the project.


# Create learners ---------------------------------------------------------

## suppressWarnings is used to not show the warning for not setting all the
## parameters during learner creation. These are taken care of in one place
## while specifying all the hyperparameters of XGBoost and their search space in
## "specifyHyperparamsXGB.R".

suppressWarnings(
  xgbBaseLearner <- makeLearner(
    "classif.xgboost",
    predict.type = "prob" # needed to calculate cross entropy (logloss)
  )
)



xgbLearner <- mlr::makeTuneWrapper(
  learner = xgbBaseLearner,
  resampling = resamplingSchemeInner, # Inner level of nested resampling
  measures = measuresSet,
  par.set = xgbParams,
  control = tuneControlRandom,
  show.info = FALSE
)
