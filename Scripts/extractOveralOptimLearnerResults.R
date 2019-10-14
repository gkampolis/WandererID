# Intro Comments ----------------------------------------------------------

# Purpose: Script to gather overall resutls from optimized classifiers created
# previously.

# Author: Georgios Kampolis
# For: Marine Scotland Science
# Comments: As part of RGU MSc course in Data Science

# Details: This script is called by Main.R in the root folder of the project.


# Plot: error rates across classes and classifiers ------------------------

temp <- bind_rows(
  #knnErrorRates,
  rfErrorRates,
  xgbErrorRates
) %>%
  tidyr::gather(
    key = "Class",
    value = "Error Rate",
    -model
  ) %>% 
  mutate(
    model = as.factor(model),
    Class = as.factor(Class),
    `Error Rate` = 100 * `Error Rate`
  )

temp <- temp %>% 
  ggplot(aes(Class, `Error Rate`, group = model)) +
  geom_line(aes(colour = model), size = 1, alpha = 0.7) +
  geom_point(aes(colour = model, shape = model), alpha = 0.8) +
  # ggrepel::geom_text_repel(
  #   data = temp %>% filter(Class == "Annelida"),
  #   aes(label = model, colour = model),
  #   hjust = "right",
  #   fontface = "bold",
  #   size = 3,
  #   nudge_x = -.45,
  #   direction = "y"
  # ) +
  # ggrepel::geom_text_repel(
  #   data = temp %>% filter(Class == "Tomopteris"),
  #   aes(label = model, colour = model),
  #   hjust = "left",
  #   fontface = "bold",
  #   size = 3,
  #   nudge_x = .45,
  #   direction = "y"
  # ) +
  ggrepel::geom_label_repel(
    data = temp %>% filter(`Error Rate` > 5),
    aes(label = round(`Error Rate`, 2), colour = model),
    size = 3,
    label.padding = unit(0.5, "lines"),
    label.size = 0,
    show.legend = FALSE
  ) +
  ggsci::scale_colour_npg() +
  #Enforce y axis scale and shown values
  scale_y_continuous(limits = c(0, 12), breaks = seq(0, 12, by = 2)) +
  labs(
    title = "Error rates accross classes: RF vs XGBoost",
    subtitle = "Error rates above 5% are highlighted.",
    y = "Error Rate (%)",
    x = "Class",
    colour = "Models: ", shape = "Models: "
  ) +
  theme_ipsum_rc(grid = "Y", ticks = F) +
  theme(
    legend.position = c(0.25, 0.8),
    legend.background = element_rect(fill = "white", colour = "#cccccc"),
    axis.text.x = element_text(angle = 90, vjust = 0.2, hjust = 1)
  )

ggsave(filename = "rf_xgb_EvalResults.png", plot = temp,
       path = here::here("ResultsReports"),
       width = 28, height = 20, units = "cm"
)

rm(temp)

# Plot: Overall comparison of classifiers across metrics ------------------

## Function to get mean and confidence interval from the various measures:

getMeasuresStats <- function(testMeasuresDF, ci = 0.95){
  # Remove duplication of measures in the test set ue to using an aggregation
  # function when specifying measures (this enabled the retrieval of measures
  # from the training set as well.)
  testMeasuresDF <- testMeasuresDF[,seq(1, length(testMeasuresDF), by = 2)]
  
  # Initialize data frame to hold values
  results <- data.frame(
    "measures" = c("Accuracy", "Balanced Accuracy", "Logloss", "Kappa"),
    "mean" = seq(0,0.75, by = 0.25), # just numeric values
    "ciUpper" = seq(0,0.75, by = 0.25),
    "ciLower" = seq(0,0.75, by = 0.25),
    stringsAsFactors = FALSE
  )
  
  # Simple loop to iterate through the measures
  for (measure in 2:length(testMeasuresDF)) {
    # Use the output from a t.test to calculate mean and confidence intervals
    temp <- t.test(testMeasuresDF[measure], conf.level = ci)
    results[measure-1L,2] <- temp$estimate %>% as.numeric()
    results[measure-1L, 3] <- temp$conf.int[[1]] %>% as.numeric()
    results[measure-1L, 4] <- temp$conf.int[[2]] %>% as.numeric()
  }
  
  rm(temp, measure)
  
  return(results)
}

# Specify confidence interval:
ci <- 0.95

# Get statistics
xgbMeasureStatsMaxAcc <- getMeasuresStats(xgbEvalResultsMaxAccParams$measures.test, ci) %>% 
  mutate(model = "XGB Max Acc")

xgbMeasureStatsMaxBalAcc <- getMeasuresStats(xgbEvalResultsMaxBalAccParams$measures.test, ci) %>% 
  mutate(model = "XGB Max Bal Acc")

xgbMeasureStatsMinLogloss <- getMeasuresStats(xgbEvalResultsMinLoglossParams$measures.test, ci) %>% 
  mutate(model = "XGB Min Logloss")

rfMeasureStats <- getMeasuresStats(rfEvalResults$measures.test, ci) %>% 
  mutate(model = "Random Forest")

knnMeasureStatsMaxAcc <- getMeasuresStats(knnEvalResultsMaxAccParams$measures.test, ci) %>% 
  mutate(model = "k-NN Max Acc")

knnMeasureStatsMaxBalAcc <- getMeasuresStats(knnEvalResultsMaxBalAccParams$measures.test, ci) %>% 
  mutate(model = "k-NN Max Bal Acc")

knnMeasureStatsMinLogloss <- getMeasuresStats(knnEvalResultsMinLoglossParams$measures.test, ci) %>% 
  mutate(model = "k-NN Min Logloss")

measureStats <- bind_rows(
  xgbMeasureStatsMaxAcc, xgbMeasureStatsMaxBalAcc, xgbMeasureStatsMinLogloss,
  rfMeasureStats,
  knnMeasureStatsMaxAcc,knnMeasureStatsMaxBalAcc, knnMeasureStatsMinLogloss
) %>% 
  mutate(measures = as.factor(measures),
         model = as.factor(model),)

rm(
  xgbMeasureStatsMaxAcc, xgbMeasureStatsMaxBalAcc, xgbMeasureStatsMinLogloss,
  rfMeasureStats,
  knnMeasureStatsMaxAcc,knnMeasureStatsMaxBalAcc, knnMeasureStatsMinLogloss
)

temp <- measureStats %>% filter(measures != "Logloss") %>% 
  ggplot(aes(measures, mean, group = model, fill = model)) +
  geom_col(position = "dodge") +
  geom_errorbar(aes(ymin = ciLower, ymax = ciUpper), position = "dodge") +
  geom_text(
    aes(label = model, y = mean - 0.05),
    colour = "black", size = 3,
    position = position_dodge(0.9), angle = 90
  ) +
  ggsci::scale_fill_npg() +
  labs(
    title = "Perfomance measures across classifiers",
    subtitle = "Confidence interval at 95%"
  ) +
  theme_ipsum_rc(grid = "Y", ticks = F) +
  theme(
    axis.title = element_blank(),
    legend.position = c(0.25, 0.25),
    legend.background = element_rect(fill = "white", colour = "#cccccc")
  ) + 
  coord_cartesian(ylim = c(0.75, 0.9))


ggsave(filename = "measuresEvalResults.png", plot = temp,
       path = here::here("ResultsReports"),
       width = 28, height = 20, units = "cm"
)

rm(temp)

tempMain <- measureStats %>% filter(measures == "Logloss") %>% 
  ggplot(aes(measures, mean, group = model, fill = model)) +
  geom_col(position = "dodge") +
  geom_errorbar(aes(ymin = ciLower, ymax = ciUpper), position = "dodge") +
  geom_text(
    aes(label = model, y = mean - 0.2),
    colour = "black", size = 3,
    position = position_dodge(0.9), angle = 0
  ) +
  ggsci::scale_fill_npg() +
  labs(
    title = "Perfomance in terms of logloss across classifiers",
    subtitle = "Confidence interval at 95%"
  ) +
  theme_ipsum_rc(grid = "Y", ticks = F) +
  theme(
    axis.title = element_blank(),
    legend.position = "bottom",
    legend.background = element_rect(fill = "white", colour = "#cccccc")
  )

tempInset <-  measureStats %>% filter(measures == "Logloss", !grepl("k-NN", model)) %>% 
  ggplot(aes(measures, mean, group = model, fill = model)) +
  geom_col(position = "dodge") +
  geom_errorbar(aes(ymin = ciLower, ymax = ciUpper), position = "dodge") +
  geom_text(
    aes(label = model, y = mean - 0.02),
    colour = "black", size = 3,
    position = position_dodge(0.9), angle = 0
  ) +
  guides(fill = FALSE) +
  scale_fill_manual(values = c("#3C5488FF", "#F39B7FFF", "#8491B4FF", "#91D1C2FF")) +
  theme_ipsum_rc(grid = "Y", ticks = F) +
  theme(
    axis.title = element_blank(),
    axis.text.x=element_blank(),
    axis.ticks.x=element_blank(),
    legend.background = element_rect(fill = "white", colour = "#cccccc"),
    panel.border = element_rect(colour = "#cccccc", fill = NA, size = 1)
  ) + 
  coord_cartesian(ylim = c(0.32, 0.42))
  

temp <- tempMain +
  annotation_custom(
    ggplotGrob(tempInset),
    xmin = 0.85, xmax = 1.6, ymin = 1.75, ymax = 3.3
  )

ggsave(filename = "measuresEvalResultsLogloss.png", plot = temp,
       path = here::here("ResultsReports"),
       width = 28, height = 20, units = "cm"
)

rm(temp, tempMain, tempInset)
