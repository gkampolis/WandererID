# Intro Comments ----------------------------------------------------------
  
  # Purpose: Script to specify the resampling schemes.
  # Author: Georgios Kampolis
  # For: Marine Scotland Science
  # Comments: As part of RGU MSc course in Data Science
  
  # Details: This script is called by Main.R in the root folder of the project.


# Resampling scheme setup for tuning --------------------------------------

resamplingSchemeOuter <- mlr::makeResampleDesc(
  "RepCV",
  predict = "both",
  stratify = TRUE,
  reps = 5L,
  fold = 5L
)

resamplingSchemeInner <- mlr::makeResampleDesc(
  "CV", 
  predict = "both",
  stratify = TRUE,
  iters = 4L
)


# Resampling scheme setup for evaluation ----------------------------------

resamplingSchemeEval <- mlr::makeResampleDesc(
  "RepCV",
  predict = "both",
  stratify = TRUE,
  reps = 5L,
  fold = 5L
)
