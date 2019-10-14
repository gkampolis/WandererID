# Intro Comments ----------------------------------------------------------

# Purpose: Script to specify the evaluation measures.
# Author: Georgios Kampolis
# For: Marine Scotland Science
# Comments: As part of RGU MSc course in Data Science

# Details: This script is called by Main.R in the root folder of the project.


# Measures set for hyperparameters optimization ---------------------------


# The first measure listed will be optimized, the others are reported.
measuresSet <- list(acc, # accuracy
                    bac, # balanced accuracy across classes (row-wise)
                    logloss, # cross entropy
                    kappa # Cohen's kappa, gains over random classifier
)


# Measures set for final evaluation (incl. test sets) ---------------------

measuresSetEval <- list(acc, setAggregation(acc, train.mean),
                    bac, setAggregation(bac, train.mean),
                    logloss, setAggregation(logloss, train.mean),
                    kappa, setAggregation(kappa, train.mean)
)
