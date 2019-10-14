# Intro Comments ----------------------------------------------------------

# Purpose: Script to create a Random Forest (rf) learner with optimal
# hyperparameters, as determined in previous steps.
# Author: Georgios Kampolis For: Marine Scotland Science
# Comments: As part of RGU MSc course in Data Science

# Details: This script is called by Main.R in the root folder of the project.


# Create optimized learner ------------------------------------------------

rfOptLearner <- setHyperPars(
  learner = rfBaseLearner,
  par.vals = rfHyperparamsSelection
)


# Clean up ----------------------------------------------------------------

rm(rfTuneResults, rfMaxAccIter, rfHyperparamsSelection)
