# Intro Comments ----------------------------------------------------------

# Purpose: Script to extract evaluation results for tuned Random Forest (rf).
# Author: Georgios Kampolis
# For: Marine Scotland Science
# Comments: As part of RGU MSc course in Data Science

# Details: This script is called by Main.R in the root folder of the project.


# Results extraction ------------------------------------------------------

rfConfMat <- calculateConfusionMatrix(
  rfEvalResults$pred,
  relative = TRUE, sums = TRUE
)

readr::write_csv(
  as.data.frame(rfConfMat$result) %>% tibble::rownames_to_column("True class"),
  here::here("ResultsReports", "rfConfMatAbsolute.csv")
)

readr::write_csv(
  as.data.frame(rfConfMat$relative.row) %>% tibble::rownames_to_column("True class"),
  here::here("ResultsReports", "rfConfMatRelative.csv")
)

rfErrorRates <- rfConfMat$relative.row %>%
  as.data.frame() %>%
  select(`-err-`) %>%
  t() %>% as.data.frame() %>% 
  dplyr::mutate(model = "Random Forest") %>% 
  select(model, everything())  


# Plot: ranked error rates ------------------------------------------------

# The intention is to combine the rfErrorRates later with results from all
# models. To show the error rates for RF alone, rfErrorRatesRanked is created
# below:

temp <- rfErrorRates %>%
  select(-model) %>%
  t() %>% as.data.frame() %>%
  tibble::rownames_to_column() %>%
  arrange(desc(V1)) %>% 
  rename(Class = rowname,
         `Error Rate` = V1
  ) %>%
  mutate(
    `Error Rate` = 100 * `Error Rate`,
    Class = as.factor(Class),
    Class = forcats::fct_reorder(Class, `Error Rate`)
  ) %>% 
  ggplot(aes(Class, `Error Rate`)) +
  geom_col() + 
  theme_ipsum_rc(grid = "X", ticks = F) +
  expand_limits(y = seq(0, 12, by = 2)) +
  coord_flip() +
  labs(
    y = "Error Rate (%)",
    title = "Error rates across classes",
    subtitle = "Random Forest"
  )

ggsave(filename = "rfEvalResults.png", plot = temp,
       path = here::here("ResultsReports"),
       height = 15, units = "cm"
      )

rm(temp)




# Plot: Distribution of error for classes - Annelida ----------------------

temp <- rfConfMat$result %>%
  as.data.frame() %>% 
  tibble::rownames_to_column("true") %>% 
  filter(true == "Annelida") %>% 
  select(- c(`-err.-`, `-n-`)) %>% 
  tidyr::gather(prediction, no , -true) %>% 
  mutate(
    true = as.factor(true),
    prediction = as.factor(prediction)
  ) %>%
  filter(prediction != "Annelida",
         no > 0) %>% 
  select(- `true`) %>% 
  mutate(prediction = forcats::fct_reorder(prediction, no, .desc = FALSE)) %>% 
  ggplot(aes(prediction, no)) +
  geom_col() + 
  theme_ipsum_rc(grid = "X", ticks = F) +
  #theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1)) +
  labs(title = "Missclassification errors",
       subtitle = 'True class: "Annelida" | Random Forest',
       caption = "Out of 1300 evaluations (52 observations from 25 repetitions)"
  ) + coord_flip()

ggsave(filename = "rfEvalAnnelidaMisclass.png", plot = temp,
       path = here::here("ResultsReports"),
       height = 15, units = "cm"
)


# Plot: Distribution of error for classes - small_crust -------------------

temp <- rfConfMat$result %>%
  as.data.frame() %>% 
  tibble::rownames_to_column("true") %>% 
  filter(true == "small_crust") %>% 
  select(- c(`-err.-`, `-n-`)) %>% 
  tidyr::gather(prediction, no , -true) %>% 
  mutate(
    true = as.factor(true),
    prediction = as.factor(prediction)
  ) %>%
  filter(prediction != "small_crust",
         no > 0) %>% 
  select(- `true`) %>% 
  mutate(prediction = forcats::fct_reorder(prediction, no, .desc = FALSE)) %>% 
  ggplot(aes(prediction, no)) +
  geom_col() + 
  theme_ipsum_rc(grid = "X", ticks = F) +
  #theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1)) +
  labs(title = "Missclassification errors",
       subtitle = 'True class: "small_crust" | Random Forest',
       caption = "Out of 1325 evaluations (53 observations from 25 repetitions)"
  ) + coord_flip()

ggsave(filename = "rfEvalsmall_crustMisclass.png", plot = temp,
       path = here::here("ResultsReports"),
       height = 15, units = "cm"
)


rm(temp)
