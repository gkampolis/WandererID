# Intro Comments ----------------------------------------------------------

# Purpose: Script to specify the hyperparameters to be tuned for random forest.
# Author: Georgios Kampolis
# For: Marine Scotland Science
# Comments: As part of RGU MSc course in Data Science

# Details: This script is called by Main.R in the root folder of the project.


# Hyperparameter setup ----------------------------------------------------

rfParams <- makeParamSet(
  # Common recomendation for default mtry (e.g ranger package docs) is the square
  # root of the number of features, in this case 7. This is padded by 3 to
  # create a search space for the optimal value.
  makeDiscreteParam("mtry", values = 4L:10L), 
  # No. of observations in the terminal nodes (leafs), typically for
  # classificaion is set to 1. This can lead to very large trees with
  # overfitting, so a bit higher values are explored as well.
  makeDiscreteParam("min.node.size", values = 1L:5L),
  # No. of trees for the model. Default is 500, more trees are expected to
  # increase computation cost but also capture more detail. If RF proves to be a
  # good enough model, then a study on the effect of no. of trees to the results
  # would be appropriate.
  makeDiscreteParam("num.trees", values = 2000)
)
