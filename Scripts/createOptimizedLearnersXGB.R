# Intro Comments ----------------------------------------------------------

# Purpose: Script to create XGBoost learners with optimal
# hyperparameters, as determined in previous steps.
# Author: Georgios Kampolis For: Marine Scotland Science
# Comments: As part of RGU MSc course in Data Science

# Details: This script is called by Main.R in the root folder of the project.


# Create optimized learners -----------------------------------------------

xgbOptLearnerMaxAccParams <- setHyperPars(
  learner = xgbBaseLearner,
  par.vals = xgbHyperparamsSelectionMaxAcc
)

xgbOptLearnerMaxBalAccParams <- setHyperPars(
  learner = xgbBaseLearner,
  par.vals = xgbHyperparamsSelectionBalAcc
)

xgbOptLearnerMinLoglossParams <- setHyperPars(
  learner = xgbBaseLearner,
  par.vals = xgbHyperparamsSelectionLogloss
)

# Clean up ----------------------------------------------------------------

rm(xgbTuneResults, xgbMaxAccIter, xgbHyperparamsSelectionMaxAcc,
   xgbMaxBalAccIter, xgbHyperparamsSelectionBalAcc,
   xgbMinLoglossIter, xgbHyperparamsSelectionLogloss,
   xgbMaxKappaIter, xgbHyperparamsSelectionKappa

)
