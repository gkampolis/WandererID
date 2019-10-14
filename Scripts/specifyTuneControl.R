# Intro Comments ----------------------------------------------------------

# Purpose: Script to specify the tuning control.
# Author: Georgios Kampolis
# For: Marine Scotland Science
# Comments: As part of RGU MSc course in Data Science

# Details: This script is called by Main.R in the root folder of the project.


# Tuning scheme setup -----------------------------------------------------

# This relies on manual discretization of hyperparameters
tuneControl <- mlr::makeTuneControlGrid()

# A second option that randomly samples the hyperparamter space. 200 iterations to
# balance computation cost with adequate sampling of the search space.
tuneControlRandom <- mlr::makeTuneControlRandom(maxit = 200L)
