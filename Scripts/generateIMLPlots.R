# Intro Comments ----------------------------------------------------------

# Purpose: Script to generate feature importance and partial dependance plots
# from classifiers.

# Author: Georgios Kampolis
# For: Marine Scotland Science
# Comments: As part of RGU MSc course in Data Science

# Details: This script is called by Main.R in the root folder of the project.


# Feature Importance ------------------------------------------------------

# Opject to hold model and data
xgbPredictor <- iml::Predictor$new(
  xgbModel,
  data = data,
  y = "Ident"
)

if (runXGB) {
  set.seed(seed = seed)
  # Generate feature importance data via permutation
  xgbFeatureImportance <- FeatureImp$new(
    xgbPredictor, loss = "ce" # classification error
  )
  # save output
  saveRDS(xgbFeatureImportance, compress = FALSE, 
          file = here::here(
            "ModelFiles",
            "xgbFeatureImportance.rds"
          )
  )
} else {
  xgbFeatureImportance <- readRDS(here::here("ModelFiles", "xgbFeatureImportance.rds"))
}

## Generate feature importance plot
xgbFeatImport <- xgbFeatureImportance %>% 
  plot() + # Creates ggplot2 object
  theme_ipsum_rc(grid = "Y", ticks = F) +
  labs(
    title = "Feature importance",
    subtitle = "Based on XGBoost and classification error by permutation",
    x = "Importance"
  )


ggsave(filename = "xgbFeatImport.png", plot = xgbFeatImport,
       path = here::here("ResultsReports"),
       height = 25, width = 20, units = "cm"
)



# Partial Dependence ------------------------------------------------------

# Calculate for the two top features according to feature importance

## Elongation
if (runXGB) {
  set.seed(seed = seed)
  xgbFeatPDP <- FeatureEffect$new(xgbPredictor, feature = "Elongation")
  saveRDS(xgbFeatPDP, compress = FALSE, 
          file = here::here(
            "ModelFiles",
            "xgbFeatPDPElongation.rds"
          )
  )
} else {
  xgbFeatPDP <- readRDS(here::here("ModelFiles", "xgbFeatPDPElongation.rds"))
}

xgbFeatPDPElongation <- xgbFeatPDP$plot() + # Creates ggplot2 object
  theme_ipsum_rc(grid = "Y", ticks = F)


ggsave(filename = "xgbFeatPDPElongation.png", plot = xgbFeatPDPElongation,
       path = here::here("ResultsReports"),
       height = 28, width = 21, units = "cm"
)

## PerimAreaexc
if (runXGB) {
  set.seed(seed = seed)
  xgbFeatPDP <- FeatureEffect$new(xgbPredictor, feature = "PerimAreaexc")
  saveRDS(xgbFeatPDP, compress = FALSE, 
          file = here::here(
            "ModelFiles",
            "xgbFeatPDPPerimAreaexc.rds"
          )
  )
} else {
  xgbFeatPDP <- readRDS(here::here("ModelFiles", "xgbFeatPDPPerimAreaexc.rds"))
}

xgbFeatPDPPerimAreaexc <- xgbFeatPDP$plot() +
  theme_ipsum_rc(grid = "Y", ticks = F)

ggsave(filename = "xgbFeatPDPPerimAreaExc.png", plot = xgbFeatPDPPerimAreaexc,
       path = here::here("ResultsReports"),
       height = 28, width = 21, units = "cm"
)


# Interaction between features --------------------------------------------

## Overall
if (runXGB) {
  set.seed(seed = seed)
  
  xgbInteractOverall <- Interaction$new(xgbPredictor)
  # save interact object
  saveRDS(xgbInteractOverall, compress = FALSE, 
          file = here::here(
            "ModelFiles",
            "xgbInteractOverall.rds"
          )
  )
} else {
  xgbInteractOverall <- readRDS(here::here("ModelFiles", "xgbInteractOverall.rds"))
}


xgbInteractOverallPlot <- xgbInteractOverall %>% plot() +
  theme_ipsum_rc(grid = "Y", ticks = F)

ggsave(filename = "xgbFeatInteractOverall.png", plot = xgbInteractOverallPlot,
       path = here::here("ResultsReports"),
       height = 80, width = 25, units = "cm"
)

## Elongation
if (runXGB) {
  set.seed(seed = seed)
  
  xgbInteractElongation <- Interaction$new(xgbPredictor, feature = "Elongation")
  
  # save interact object
  saveRDS(xgbInteractElongation, compress = FALSE, 
          file = here::here(
            "ModelFiles",
            "xgbInteractElongation.rds"
          )
  )
} else {
  xgbInteractElongation <- readRDS(here::here("ModelFiles", "xgbInteractElongation.rds"))
}

xgbInteractElongationPlot <- xgbInteractElongation %>% plot() +
  theme_ipsum_rc(grid = "Y", ticks = F)

ggsave(filename = "xgbFeatInteractElongation.png", plot = xgbInteractElongationPlot,
       path = here::here("ResultsReports"),
       height = 80, width = 25, units = "cm"
)

## PerimAreaexc
if (runXGB) {
  set.seed(seed = seed)
  
  xgbInteractPerimAreaexc <- Interaction$new(xgbPredictor, feature = "PerimAreaexc")
  
  # save interact object
  saveRDS(xgbInteractPerimAreaexc, compress = FALSE, 
          file = here::here(
            "ModelFiles",
            "xgbInteractPerimAreaexc.rds"
          )
  )
} else {
  xgbInteractPerimAreaexc <- readRDS(here::here("ModelFiles", "xgbInteractPerimAreaexc.rds"))
}

xgbInteractPerimAreaexcPlot <- xgbInteractPerimAreaexc %>% plot() +
  theme_ipsum_rc(grid = "Y", ticks = F)

ggsave(filename = "xgbFeatInteractPerimAreaexc.png", plot = xgbInteractPerimAreaexcPlot,
       path = here::here("ResultsReports"),
       height = 80, width = 25, units = "cm"
)
