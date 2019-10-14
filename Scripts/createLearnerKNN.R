# Intro Comments ----------------------------------------------------------

# Purpose: Script to create a weighted kNN learner (see details).
# Author: Georgios Kampolis
# For: Marine Scotland Science
# Comments: As part of RGU MSc course in Data Science

# Details: This script is called by Main.R in the root folder of the project.
# Furthermore, this particular implementation of kNN is the one introduced by
# Schliep and Hechenbichler in their report "Weighted k-Nearest-Neighbor
# Techniques and Ordinal Classification", which expands kNN to also extrapolate
# from the voting process to the underlying distribution. This allows for the
# logloss to be measured and comapred relative to the other approaches.


# Create learners ---------------------------------------------------------

knnBaseLearner <- makeLearner(
  "classif.kknn",
  predict.type = "prob" # needed to calculate cross entropy (logloss)
)


knnLearner <- mlr::makeTuneWrapper(
  learner = knnBaseLearner,
  resampling = resamplingSchemeInner, # Inner level of nested resampling
  measures = measuresSet,
  par.set = knnParams,
  control = tuneControl,
  show.info = FALSE
)
