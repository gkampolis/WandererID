# Intro Comments ----------------------------------------------------------

# Purpose: Script to specify the hyperparameters to be tuned for XGBoost.
# Author: Georgios Kampolis
# For: Marine Scotland Science
# Comments: As part of RGU MSc course in Data Science

# Details: This script is called by Main.R in the root folder of the project.


# Hyperparameter setup ----------------------------------------------------

xgbParams <- makeParamSet(
  # Controlling model complexity with max_depth, default is 3.
  # Avoided 1 as this corresponds to decission stumps.
  makeIntegerParam("max_depth", lower = 2L, upper = 10L), 
  # If leaf node has a lower minimum sum of instance weights than this, stop the
  # tree splitting. This prevents overfitting by controlling features
  # interactions.
  makeNumericParam("min_child_weight", lower =  1L, upper = 10L),
  # No. of observations passed to a tree, typicall values 0.5-0.8, default 1 (in
  # which case it absolutely requires heldout sets via explicit resampling, as
  # is the case here). Lower values help prevent overfitting, larger values
  # allow for more information to be gleaned.
  makeNumericParam("subsample",lower = 0.5,upper = 1),
  # No. of features supplied to a tree, used to prevent overfitting with a logic
  # similar to random forests were not all features are evaluated at every step.
  makeNumericParam("colsample_bytree",lower = 0.5,upper = 1),
  # Maximum no. of iterations for adding boosted trees. This is somewhat
  # empirically tied with the learning rate below.
  makeDiscreteParam("nrounds", values = 100L),
  # The learning rate or shrinkage for each step. Lower rates allow to the model
  # to not overshoot the optimum configuration (perfect balance of
  # underfitting/overfitting) but need many more steps to reach it (nrounds as
  # above) and strongly increase computation cost. Typical values are 0.01 -
  # 0.3, possible values 0-1.
  makeDiscreteParam("eta", values = 0.1),
  # Early stopping rounds refers to how many successive steps (out of the max
  # set by nrounds further above) are allowed to be taken by the algorithm when
  # not seeing a better result. A better result may come up "down the line" so
  # to speak, but ussually this resutls in overfitting (i.e. no improvement for
  # a number of iterations and suddenyl having some improvement is a typical
  # case of recognising noise as pattern). Typicall value is 10.
  makeDiscreteParam("early_stopping_rounds", values = 10L)
)
