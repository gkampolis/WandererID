# Intro Comments ----------------------------------------------------------

# Purpose: Script to create k-NN learners with optimal
# hyperparameters, as determined in previous steps.
# Author: Georgios Kampolis For: Marine Scotland Science
# Comments: As part of RGU MSc course in Data Science

# Details: This script is called by Main.R in the root folder of the project.


# Create optimized learners -----------------------------------------------

knnOptLearnerMaxAccParams <- setHyperPars(
  learner = knnBaseLearner,
  par.vals = knnHyperparamsSelectionMaxAcc
)

knnOptLearnerMaxBalAccParams <- setHyperPars(
  learner = knnBaseLearner,
  par.vals = knnHyperparamsSelectionBalAcc
)

knnOptLearnerMinLoglossParams <- setHyperPars(
  learner = knnBaseLearner,
  par.vals = knnHyperparamsSelectionLogloss
)

# Clean up ----------------------------------------------------------------

rm(knnTuneResults, knnMaxAccIter, knnHyperparamsSelectionMaxAcc,
   knnMaxBalAccIter, knnHyperparamsSelectionBalAcc,
   knnMinLoglossIter, knnHyperparamsSelectionLogloss,
   knnMaxKappaIter, knnHyperparamsSelectionKappa
   
)
