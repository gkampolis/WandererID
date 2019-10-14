# Intro Comments ----------------------------------------------------------

# Purpose: Script to create a Random Forest (rf) learner.
# Author: Georgios Kampolis
# For: Marine Scotland Science
# Comments: As part of RGU MSc course in Data Science

# Details: This script is called by Main.R in the root folder of the project.


# Create learners ---------------------------------------------------------

rfBaseLearner <- makeLearner(
  "classif.ranger",
  predict.type = "prob" # needed to calculate cross entropy (logloss)
)


rfLearner <- mlr::makeTuneWrapper(
  learner = rfBaseLearner,
  resampling = resamplingSchemeInner, # Inner level of nested resampling
  measures = measuresSet,
  par.set = rfParams,
  control = tuneControl,
  show.info = FALSE
)
