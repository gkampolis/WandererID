# Intro Comments ----------------------------------------------------------

# Purpose: Script to specify the hyperparameters to be tuned for kNN learner (see details)
# Author: Georgios Kampolis
# For: Marine Scotland Science
# Comments: As part of RGU MSc course in Data Science

# Details: This script is called by Main.R in the root folder of the project.
# Furthermore, this particular implementation of kNN is the one introduced by
# Schliep and Hechenbichler in their report "Weighted k-Nearest-Neighbor
# Techniques and Ordinal Classification", which expands kNN to also extrapolate
# from the voting process to the underlying distribution. This allows for the
# logloss to be measured and comapred relative to the other approaches.


# Hyperparameter setup ----------------------------------------------------

knnParams <- makeParamSet(
  # No. of nearest neighbours to use for determining prediction. The upper bound
  # was determind arbitrarily as one third of the no. of observations of the
  # least represented class (annelida, 52 observations). For the lower bound,
  # the trivial solutions of 1 and 2 were avoided as empirically they do not
  # offer good results.
  makeDiscreteParam("k", values = 3L:17L),
  # Type of distance to use - the p parameter in the Minkowski distance. For p=1
  # then the absolute/Manhattan distance is obtained, whereas for p=2 the
  # Euclidean distance is utilised.
  makeDiscreteParam("distance", values = 1L:2L), 
  # Use the typical kNN algorithm ratehr than a weighted version
  makeDiscreteParam("kernel", values = "rectangular"),
  # Scale input to the learner so that all features will have the same standard
  # variation.
  makeLogicalParam("scale", default = TRUE)
)
