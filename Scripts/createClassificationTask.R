# Intro Comments ----------------------------------------------------------

# Purpose: Script to specify the classification task.
# Author: Georgios Kampolis
# For: Marine Scotland Science
# Comments: As part of RGU MSc course in Data Science

# Details: This script is called by Main.R in the root folder of the project.


# Create classification task ----------------------------------------------

dataTask <- mlr::makeClassifTask(
  data = data,
  target = "Ident"
)
