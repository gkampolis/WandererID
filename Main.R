# Intro Comments ----------------------------------------------------------

# Purpose: This script forms the main skeleton for tuning the various models and
# evaluating their expected perfomance. 

# Author: Georgios Kampolis
# For: Marine Scotland Science
# Comments: As part of RGU MSc course in Data Science

# Details: The script assumes that it is located at the root of the project
# folder and accessed after reading the .Rproj file (for the relative paths to work).
# Simplest way to do so is to launch RStudio by double-clicking the .Rproj file
# and then access this script.


# Initial packages --------------------------------------------------------

## platform-agnostic path construction & root determination:
if (!require("here")) install.packages("here"); library(here)

## package management that takes care of loading and installing if necessary:
if (!require("pacman")) install.packages("pacman"); library(pacman)


# Flags for flow control --------------------------------------------------

# Flag to check the version of needed packages for this project.
# There is no need to keep this as TRUE after first run.
verifyCorrectVersions <- TRUE

# Set to true to (re-)run, false if results have already been obtained and only
# loading of relevant .rds is necessary.

runRF <- TRUE # Random Forest
runXGB <- TRUE # XGBoost
runKNN <- TRUE # k-NN, the surrogate learner of choice for this project.

# Seed for reproducibility ------------------------------------------------

seed <- 42L

# Package management ------------------------------------------------------

source(here::here("Scripts","loadPackages.R"))
## returns: messages re: packages and message at end of script.


# Parallelization setup ---------------------------------------------------

source(here::here("Scripts","setupParallelization.R"))
## returns message re: parallelization status on host machine


# Data handling -----------------------------------------------------------

source(here::here("Scripts","dataLoadAndClean.R"))
## returns: "data"
## saves: "data*.png" plots in ./ResultsReports/


# Classification task via mlr ---------------------------------------------

source(here::here("Scripts","createClassificationTask.R"))
## returns: "dataTask"


# Specify measures for evaluation -----------------------------------------

source(here::here("Scripts","specifyMeasures.R"))
## returns: 
## "measuresSet",
## "measuresSetEval" (also includes same measures on the training set)


# Resample scheme setup for tuning & evaluation ---------------------------

source(here::here("Scripts","specifyResamplingSchemes.R"))
## returns:
## "resamplingSchemeOuter",
## "resamplingSchemeInner",
## "resamplingSchemeEval"


# Tuning control ----------------------------------------------------------

## This specifies random or grid search search and any relevant parameters.
source(here::here("Scripts","specifyTuneControl.R"))
## returns:
## "tuneControl", (exhaustive grid search)
## "tuneControlRandom" (random sampling)


# Hyperparameter specification --------------------------------------------

## For Random Forest:
source(here::here("Scripts","specifyHyperparamsRF.R"))
## returns "rfParams"


## For XGBoost:
source(here::here("Scripts","specifyHyperparamsXGB.R"))
## returns "xgbParams"


## For k-NN:
source(here::here("Scripts","specifyHyperparamsKNN.R"))
## returns "knnParams"

# Learner creation --------------------------------------------------------

## For Random Forest:
source(here::here("Scripts","createLearnerRF.R"))
## returns:
## "rfBaseLearner",
## "rfLearner"


## For XGBoost:
source(here::here("Scripts","createLearnerXGB.R"))
## returns:
## "xgbBaseLearner",
## "xgbLearner"


## For k-NN:
source(here::here("Scripts","createLearnerKNN.R"))
## returns:
## "knnBaseLearner",
## "knnLearner"


# Hyperparameter tuning via nested resampling -----------------------------

## For Random Forest:
if (runRF) {
  source(here::here("Scripts","tuneHyperparamsRF.R"))
  ## returns: "rfHyperparamsResults"
  ## saves: "rfHyperparamsResults.rds" in ./ModelFiles/
} else {
  rfHyperparamsResults <- readRDS(
    here::here("ModelFiles","rfHyperparamsResults.rds")
  )
}

## For XGBoost:
if (runXGB) {
  source(here::here("Scripts", "tuneHyperparamsXGB.R"))
  ## returns: "xgbHyperparamsResults"
  ## saves: "xgbHyperparamsResults.rds" in ./ModelFiles/
} else {
  xgbHyperparamsResults <- readRDS(
    here::here("ModelFiles","xgbHyperparamsResults.rds")
  )
}

## For k-NN:
if (runKNN) {
  source(here::here("Scripts", "tuneHyperparamsKNN.R"))
  ## returns: "knnHyperparamsResults"
  ## saves: "knnHyperparamsResults.rds" in ./ModelFiles/
} else {
  knnHyperparamsResults <- readRDS(
    here::here("ModelFiles","knnHyperparamsResults.rds")
  )
}


# Hyperparameter tuning results extraction --------------------------------

## For Random Forest:
source(here::here("Scripts","extractHyperparamsTuneResultsRF.R"))
## returns:
## "rfTuneResults",
## "rfMaxAccIter" (iteration no where best accuracy was observed)
## "rfHyperparamsSelection" (optimal set of hyperparameters)
## saves: "rfTuningResults.csv" in ./ResultsReports/

## For XGBoost:
source(here::here("Scripts","extractHyperparamsTuneResultsXGB.R"))
## returns:
## "xgbTuneResults",
## "xgbMaxAccIter" (iteration no where best accuracy was observed)
## "xgbHyperparamsSelectionMaxAcc" (corresponding hyperparameters)
## "xgbMaxBalAccIter" (as above but for balanced accuracy)
## "xgbHyperparamsSelectionBalAcc" (corresponding hyperparameters)
## "xgbMinLoglossIter" (as above but for logloss)
## "xgbHyperparamsSelectionLogloss" (corresponding hyperparameters)
## "xgbMaxKappaIter" (as above but for kappa, same iteration as max accuracy)
## "xgbHyperparamsSelectionKappa" (corresponding hyperparameters, same as max accuracy)
## saves: "xgbTuningResults.csv" in ./ResultsReports/

## For k-NN:
source(here::here("Scripts","extractHyperparamsTuneResultsKNN.R"))
## returns:
## "knnTuneResults",
## "knnMaxAccIter" (iteration no where best accuracy was observed)
## "knnHyperparamsSelectionMaxAcc" (corresponding hyperparameters)
## "knnMaxBalAccIter" (as above but for balanced accuracy)
## "knnHyperparamsSelectionBalAcc" (corresponding hyperparameters)
## "knnMinLoglossIter" (as above but for logloss)
## "knnHyperparamsSelectionLogloss" (corresponding hyperparameters)
## "knnMaxKappaIter" (as above but for kappa, same iteration as max accuracy)
## "knnHyperparamsSelectionKappa" (corresponding hyperparameters, same as max accuracy)
## saves: "knnTuningResults.csv" in ./ResultsReports/


# Optimized learner creation & evaluation ---------------------------------

## For Random Forest:
source(here::here("Scripts", "createOptimizedLearnerRF.R"))
## returns: "rfOptimalLearner"
## cleans up: "rfTuneResults", "rfMaxAccIter", "rfHyperparamsSelection"

if (runRF) {
  source(here::here("Scripts", "evaluateOptimizedLearnerRF.R"))
  ## returns: "rfEvalResults"
  ## saves: "rfOptLearnerEvalResults.rds" in ./ModelFiles/  
} else {
  rfEvalResults <- readRDS(
    here::here("ModelFiles","rfOptLearnerEvalResults.rds")
  )
}

## For XGBoost:
source(here::here("Scripts", "createOptimizedLearnersXGB.R"))
## returns:
## "xgbOptLearnerMaxAccParams",
## "xgbOptLearnerMaxBalAccParams",
## "xgbOptLearnerMinLoglossParams",
## cleans up: returns from "extractHyperparamsTuneResultsXGB.R" above

if (runXGB) {
  source(here::here("Scripts", "evaluateOptimizedLearnerXGB.R"))
  ## returns: 
  ## "xgbEvalResultsMaxAccParams",
  ## "xgbEvalResultsMaxBalAccParams",
  ## "xgbEvalResultsMinLoglossParams",
  ## saves: 
  ## "xgbOptLearnerEvalResultsMaxAccParams.rds" in ./ModelFiles/
  ## "xgbOptLearnerEvalResultsMaxBalAccParams.rds" in ./ModelFiles/
  ## "xgbOptLearnerEvalResultsMinLoglossParams.rds" in ./ModelFiles/
} else {
  
  xgbEvalResultsMaxAccParams <- readRDS(
    here::here("ModelFiles","xgbOptLearnerEvalResultsMaxAccParams.rds")
  )
  
  xgbEvalResultsMaxBalAccParams <- readRDS(
    here::here("ModelFiles","xgbOptLearnerEvalResultsMaxBalAccParams.rds")
  )
  
  xgbEvalResultsMinLoglossParams <- readRDS(
    here::here("ModelFiles","xgbOptLearnerEvalResultsMinLoglossParams.rds")
  )
}


## For kNN:
source(here::here("Scripts", "createOptimizedLearnersKNN.R"))
## returns:
## "knnOptLearnerMaxAccParams",
## "knnOptLearnerMaxBalAccParams",
## "knnOptLearnerMinLoglossParams",
## cleans up: returns from "extractHyperparamsTuneResultsKNN.R" above

if (runKNN) {
  source(here::here("Scripts", "evaluateOptimizedLearnerKNN.R"))
  ## returns: 
  ## "knnEvalResultsMaxAccParams",
  ## "knnEvalResultsMaxBalAccParams",
  ## "knnEvalResultsMinLoglossParams",
  ## saves: 
  ## "knnOptLearnerEvalResultsMaxAccParams.rds" in ./ModelFiles/
  ## "knnOptLearnerEvalResultsMaxBalAccParams.rds" in ./ModelFiles/
  ## "knnOptLearnerEvalResultsMinLoglossParams.rds" in ./ModelFiles/
} else {
  
  knnEvalResultsMaxAccParams <- readRDS(
    here::here("ModelFiles","knnOptLearnerEvalResultsMaxAccParams.rds")
  )
  
  knnEvalResultsMaxBalAccParams <- readRDS(
    here::here("ModelFiles","knnOptLearnerEvalResultsMaxBalAccParams.rds")
  )
  
  knnEvalResultsMinLoglossParams <- readRDS(
    here::here("ModelFiles","knnOptLearnerEvalResultsMinLoglossParams.rds")
  )
}


# Optimized learner results extraction ------------------------------------

## For Random Forest
source(here::here("Scripts", "extractOptimLearnerEvalResultsRF.R"))
## returns: "rfConfMat", "rfErrorRates" (for collating across models)
## saves in ResultsReports:
## "rfEvalResults.png", "rfEvalAnnelidaMisclass.png"
## "rfConfMatAbsolute.csv", "rfConfMatRelative.csv" (row-wise)


## For XGBoost
source(here::here("Scripts", "extractOptimLearnerEvalResultsXGB.R"))
## returns:
## "xgbMaxAccConfMat",
## "xgbMaxBalAccConfMat",
## "xgbMinLoglossConfMat",
## "xgbErrorRates" (for collating across models)
## saves in ResultsReports:
## "xgbEvalResults.png",
## "xgbMaxAccEvalAnnelidaMisclass.png",
## "xgbMaxBalAccEvalAnnelidaMisclass.png",
## "xgbMinLoglossEvalAnnelidaMisclass.png",
## "xgbMaxAccConfMatAbsolute.csv", "xgbMaxAccConfMatRelative.csv" (row-wise)
## "xgbMaxBalAccConfMatAbsolute.csv", "xgbMaxBalAccConfMatRelative.csv" (row-wise)
## "xgbMinLoglossConfMatAbsolute.csv", "xgbMinLoglossConfMatRelative.csv" (row-wise)

## For k-NN
source(here::here("Scripts", "extractOptimLearnerEvalResultsKNN.R"))
## returns:
## "knnMaxAccConfMat",
## "knnMaxBalAccConfMat",
## "knnMinLoglossConfMat",
## "knnErrorRates" (for collating across models)
## saves in ResultsReports:
## "knnEvalResults.png",
## "knnMaxAccEvalAnnelidaMisclass.png",
## "knnMaxBalAccEvalAnnelidaMisclass.png",
## "knnMinLoglossEvalAnnelidaMisclass.png",
## "knnMaxAccConfMatAbsolute.csv", "knnMaxAccConfMatRelative.csv" (row-wise)
## "knnMaxBalAccConfMatAbsolute.csv", "knnMaxBalAccConfMatRelative.csv" (row-wise)
## "knnMinLoglossConfMatAbsolute.csv", "knnMinLoglossConfMatRelative.csv" (row-wise)


# Summarized results across optimized classifiers -------------------------

# Generate aggregating plots:
source(here::here("Scripts", "extractOveralOptimLearnerResults.R"))

# Train final models ------------------------------------------------------


## XGBoost
if (runXGB) {
  set.seed(seed = seed)
  # train model on all available data:
  xgbModel <- mlr::train(
    xgbOptLearnerMinLoglossParams,
    dataTask
  )
  # save model
  saveRDS(xgbModel, compress = FALSE, 
          file = here::here(
            "ModelOutput",
            "xgbModel.rds"
          )
  )
} else {
  xgbModel <- readRDS(here::here("ModelOutput", "xgbModel.rds"))
}

## Random Forest
if (runRF) {
  set.seed(seed = seed)
  # train model on all available data:
  rfModel <- mlr::train(
    rfOptLearner,
    dataTask
  )
  # save model
  saveRDS(rfModel, compress = FALSE, 
          file = here::here(
            "ModelOutput",
            "rfModel.rds"
          )
  )
} else {
  rfModel <- readRDS(here::here("ModelOutput", "rfModel.rds"))
}


# Interpretable ML plots --------------------------------------------------

# Generate plots:
source(here::here("Scripts", "generateIMLPlots.R"))


# Parallelization cleanup -------------------------------------------------

if (parallelizationFlag) {
  parallelMap::parallelStop()
}

beepr::beep(1)
message("Script complete!")
