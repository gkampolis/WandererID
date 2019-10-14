# Intro Comments ----------------------------------------------------------

# Purpose: Script to extract evaluation results for tuned XGBoost.
# Author: Georgios Kampolis
# For: Marine Scotland Science
# Comments: As part of RGU MSc course in Data Science

# Details: This script is called by Main.R in the root folder of the project.



# Confusion matrices extraction -------------------------------------------


## with Max Accuracy hyperparameters
xgbMaxAccConfMat <- calculateConfusionMatrix(
  xgbEvalResultsMaxAccParams$pred,
  relative = TRUE, sums = TRUE
)

readr::write_csv(
  as.data.frame(xgbMaxAccConfMat$result) %>% tibble::rownames_to_column("True class"),
  here::here("ResultsReports", "xgbMaxAccConfMatAbsolute.csv")
)

readr::write_csv(
  as.data.frame(xgbMaxAccConfMat$relative.row) %>% tibble::rownames_to_column("True class"),
  here::here("ResultsReports", "xgbMaxAccConfMatRelative.csv")
)

## with Max Balanced Accuracy hyperparameters

xgbMaxBalAccConfMat <- calculateConfusionMatrix(
  xgbEvalResultsMaxBalAccParams$pred,
  relative = TRUE, sums = TRUE
)

readr::write_csv(
  as.data.frame(xgbMaxBalAccConfMat$result) %>% tibble::rownames_to_column("True class"),
  here::here("ResultsReports", "xgbMaxBalAccConfMatAbsolute.csv")
)

readr::write_csv(
  as.data.frame(xgbMaxBalAccConfMat$relative.row) %>% tibble::rownames_to_column("True class"),
  here::here("ResultsReports", "xgbMaxBalAccConfMatRelative.csv")
)

## with Min Logloss hyperparameters

xgbMinLoglossConfMat <- calculateConfusionMatrix(
  xgbEvalResultsMinLoglossParams$pred,
  relative = TRUE, sums = TRUE
)

readr::write_csv(
  as.data.frame(xgbMinLoglossConfMat$result) %>% tibble::rownames_to_column("True class"),
  here::here("ResultsReports", "xgbMinLoglossConfMatAbsolute.csv")
)

readr::write_csv(
  as.data.frame(xgbMaxBalAccConfMat$relative.row) %>% tibble::rownames_to_column("True class"),
  here::here("ResultsReports", "xgbMinLoglossConfMatRelative.csv")
)

# Per class error rates ---------------------------------------------------

xgbMaxAccErrorRates <- xgbMaxAccConfMat$relative.row %>%
  as.data.frame() %>%
  select(`-err-`) %>%
  t() %>% as.data.frame() %>% 
  dplyr::mutate(model = "XGBoost, Max Acc params") %>% 
  select(model, everything())  

xgbMaxBalAccErrorRates <- xgbMaxBalAccConfMat$relative.row %>%
  as.data.frame() %>%
  select(`-err-`) %>%
  t() %>% as.data.frame() %>% 
  dplyr::mutate(model = "XGBoost, Max Bal Acc params") %>% 
  select(model, everything())  

xgbMinLoglossErrorRates <- xgbMinLoglossConfMat$relative.row %>%
  as.data.frame() %>%
  select(`-err-`) %>%
  t() %>% as.data.frame() %>% 
  dplyr::mutate(model = "XGBoost, Min Logloss params") %>% 
  select(model, everything())  

xgbErrorRates <- bind_rows(
  xgbMaxAccErrorRates,
  xgbMaxBalAccErrorRates,
  xgbMinLoglossErrorRates
)

rm(xgbMaxAccErrorRates, xgbMaxBalAccErrorRates, xgbMinLoglossErrorRates)

# Plot: ranked error rates ------------------------------------------------

# The intention is to combine the xgbErrorRates later with results from all
# models. To show the error rates for XGBoost alone, xgbErrorRatesRanked is
# created below:

temp <- xgbErrorRates %>%
  select(-model) %>%
  t() %>% as.data.frame() %>%
  tibble::rownames_to_column() %>%
  rename(Class = rowname,
         `Max Acc` = V1,
         `Max Bal Acc` = V2,
         `Min Logloss` = V3
  ) %>%
  mutate(Class = as.factor(Class))

temp1 <- temp %>% select(Class, `Max Acc`) %>%
  mutate(Hyperparams = "Max Acc") %>% 
  rename(`Error Rate` = `Max Acc`)

temp2 <- temp %>% select(Class, `Max Bal Acc`) %>%
  mutate(Hyperparams = "Max Bal Acc") %>% 
  rename(`Error Rate` = `Max Bal Acc`)

temp3 <- temp %>% select(Class, `Min Logloss`) %>%
  mutate(Hyperparams = "Min Logloss") %>% 
  rename(`Error Rate` = `Min Logloss`)

temp <- bind_rows(temp1, temp2, temp3) %>% 
  mutate(
    Class = as.factor(Class),
    Hyperparams = as.factor(Hyperparams),
    `Error Rate` = 100*`Error Rate`
  )

rm(temp1, temp2, temp3)

temp <- temp %>%
  ggplot(
    aes(
      x = forcats::fct_reorder(Class, `Error Rate`),
      y = `Error Rate`,
      fill = Hyperparams
    )
  ) +
  geom_col(position = "dodge") +
  theme_ipsum_rc(grid = "X", ticks = F) +
  ggsci::scale_fill_npg() +
  expand_limits(y = seq(0, 12, by = 2)) +
  coord_flip() +
  theme(
    legend.position = c(0.8, 0.3),
    legend.background = element_rect(fill = "white", colour = "#cccccc")
  ) +
  labs(
    x = " Class", y = "Error rate (%)", fill = "Hyperparameters set",
    title = "Error rates across classes",
    subtitle = "XGBoost models"
  )

ggsave(filename = "xgbEvalResults.png", plot = temp,
       path = here::here("ResultsReports"),
       height = 15, units = "cm"
)

rm(temp)


# Plot: Distribution of error for classes - Annelida ----------------------


## Max Accuracy set
temp <- xgbMaxAccConfMat$result %>%
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
  guides(fill = FALSE) +
  labs(title = "Missclassification errors",
       subtitle = 'True class: "Annelida" | XGBoost (Max Acc set)',
       caption = "Out of 1300 evaluations (52 observations from 25 repetitions)"
  ) + coord_flip()

ggsave(filename = "xgbMaxAccEvalAnnelidaMisclass.png", plot = temp,
       path = here::here("ResultsReports"),
       height = 15, units = "cm"
)

## Max Balanced Accuracy set
temp <- xgbMaxBalAccConfMat$result %>%
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
  guides(fill = FALSE) +
  labs(title = "Missclassification errors",
       subtitle = 'True class: "Annelida" | XGBoost (Max Bal Acc set)',
       caption = "Out of 1300 evaluations (52 observations from 25 repetitions)"
  ) + coord_flip()

ggsave(filename = "xgbMaxBalAccEvalAnnelidaMisclass.png", plot = temp,
       path = here::here("ResultsReports"),
       height = 15, units = "cm"
)

## Min Logloss Accuracy set
temp <- xgbMinLoglossConfMat$result %>%
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
  guides(fill = FALSE) +
  labs(title = "Missclassification errors",
       subtitle = 'True class: "Annelida" | XGBoost (Min Logloss set)',
       caption = "Out of 1300 evaluations (52 observations from 25 repetitions)"
  ) + coord_flip()

ggsave(filename = "xgbMinLoglossEvalAnnelidaMisclass.png", plot = temp,
       path = here::here("ResultsReports"),
       height = 15, units = "cm"
)


# Plot: Distribution of error for classes - small_crust -------------------

## Max Accuracy set
temp <- xgbMaxAccConfMat$result %>%
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
  guides(fill = FALSE) +
  labs(title = "Missclassification errors",
       subtitle = 'True class: "small_crust" | XGBoost (Max Acc set)',
       caption = "Out of 1325 evaluations (53 observations from 25 repetitions)"
  ) + coord_flip()

ggsave(filename = "xgbMaxAccEvalsmall_crustMisclass.png", plot = temp,
       path = here::here("ResultsReports"),
       height = 15, units = "cm"
)

## Max Balanced Accuracy set
temp <- xgbMaxBalAccConfMat$result %>%
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
  guides(fill = FALSE) +
  labs(title = "Missclassification errors",
       subtitle = 'True class: "small_crust" | XGBoost (Max Bal Acc set)',
       caption = "Out of 1325 evaluations (53 observations from 25 repetitions)"
  ) + coord_flip()

ggsave(filename = "xgbMaxBalAccEvalsmall_crustMisclass.png", plot = temp,
       path = here::here("ResultsReports"),
       height = 15, units = "cm"
)

## Min Logloss Accuracy set
temp <- xgbMinLoglossConfMat$result %>%
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
  guides(fill = FALSE) +
  labs(title = "Missclassification errors",
       subtitle = 'True class: "small_crust" | XGBoost (Min Logloss set)',
       caption = "Out of 1325 evaluations (53 observations from 25 repetitions)"
  ) + coord_flip()

ggsave(filename = "xgbMinLoglossEvalsmall_crustMisclass.png", plot = temp,
       path = here::here("ResultsReports"),
       height = 15, units = "cm"
)



rm(temp)


