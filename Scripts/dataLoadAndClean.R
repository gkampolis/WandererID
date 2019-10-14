# Intro Comments ----------------------------------------------------------

# Purpose: Script to load and wrangle the data set & generate distribution and
# correlation plots.

# Author: Georgios Kampolis
# For: Marine Scotland Science
# Comments: As part of RGU MSc course in Data Science

# Details: This script is called by Main.R in the root folder of the project.

# Data loading & wrangling ------------------------------------------------

data <- read_tsv(here::here("Data","Data.txt"))


# Data cleaning & derived features ----------------------------------------

data <- data %>% 
  # Keep features of interest only
  select(-c(`!Item`, Label, BX, BY, Width, XMg5, YMg5,
            Height, Angle, XStart, YStart, Status,
            Compentropy, Compmean, Compslope, CompM1,
            CompM2, CompM3, Tag, Status)
  ) %>% 
  # Convert target label column to factor
  mutate(Ident = as.factor(Ident)) %>% 
  # Add additional derived features
  mutate(Mean_exc = IntDen / Area_exc,
         ESD = 2 * sqrt(Area / pi),
         Elongation = Major / Minor,
         Range = Max - Min,
         MeanPos = (Max - Mean)/Range,
         CentroidsD = sqrt((XM - X)^2 + (YM - Y)^2),
         CV = 100 * (StdDev / Mean),
         SR = 100 * (StdDev / Range),
         PerimAreaexc = Perim. / Area_exc,
         FeretAreaexc = Feret / Area_exc,
         PerimFeret = Perim. / Feret,
         PerimMaj = Perim. / Major,
         Circexc = (4*pi*Area_exc) / Perim.^2,
         CDexc = (CentroidsD^2)/Area_exc
  ) %>% 
  # Remove unneeded features
  select(-c(X, Y, XM, YM)) %>%
  # Rename feature to conform to R's and mlr's expectations
  rename(Area_perc = `%Area`) %>% 
  # Re-arrange so that ident is the first column
  select(Ident, everything()) %>% 
  # Specify dataframe rather than tibble, ensures compatibility w/ mlr
  as.data.frame()




# Get summary statistics --------------------------------------------------

dataSummary <- data %>% 
  mlr::summarizeColumns() %>% 
  select(name, type, mean, min, max, nlevs)

write_csv(dataSummary, here::here("ResultsReports", "dataFeatSummary.csv"))


# Plot distribution of target classes -------------------------------------

# Create vector of non-biological labels
nonBio <- c("badfocus", "detritus", "Fiber", "grey_line", "grey_surface")

temp <- data %>%
  group_by(Ident) %>%
  summarise(cases = n()) %>% 
  mutate(category = 
           if_else(Ident %in% nonBio, "non-Biological", "Biological")
  ) %>% 
  mutate_if(~ is.character(.), ~ as.factor(.)) %>% # convert characters to factors
  ggplot(aes(fct_reorder(Ident, cases, .desc = FALSE),
             cases, fill = category)) +
  geom_col() +
  geom_label(aes(label = cases, colour = category),
             fill = "white", show.legend = F) +
  theme_ipsum_rc(grid = "X", ticks = F) +
  theme(#axis.text.x = element_text(angle = 90, vjust = 0.2, hjust = 1),
        legend.position = c(0.77,0.2), legend.justification = c(0.05,0.8),
        legend.background = element_rect(fill = "white", colour = "#cccccc")) +
  ylim(0, 400) +
  ggsci::scale_fill_npg() +
  ggsci::scale_colour_npg() +
  labs(x = "", fill = "Category: ", y = "No. of observations",
       title = "Distribution of the data set",
       subtitle = "Across target labels and grouped by category"
  ) +
  coord_flip()

ggsave(filename = "dataDistr.png", plot = temp,
       path = here::here("ResultsReports"),
       width = 25, height = 20, units = "cm"
)

# Clean up
rm(nonBio, temp)


# Correlation plot --------------------------------------------------------

temp <- data %>%
  select(- Ident) %>% 
  cor() %>%   # calculate the corelation matrix
  ggcorrplot::ggcorrplot(., p.mat = cor_pmat(data[,2:ncol(data)]),
                         sig.level = 0.05, # signficance level threshold
                         insig = "blank",
                         method = "square", type = "full",
                         show.diag = FALSE, lab = FALSE
  ) +
  ggtitle("Correlation Matrix")

ggsave(filename = "dataCorrAll.png", plot = temp,
       path = here::here("ResultsReports"),
       width = 25, height = 25, units = "cm"
)

# Clean up
rm(temp)


# Correlation plot: only high correlations --------------------------------

temp <- data %>% select(-Ident) %>% cor()
temp[-0.8 <= temp & temp <= 0.8] <- NA

temp <- temp %>%
  ggcorrplot::ggcorrplot(
    ., method = "square", type = "lower", lab = TRUE
  ) +
  ggtitle("Correlation Matrix", subtitle = "|Correlations| >= 0.8")

ggsave(filename = "dataCorrHigh.png", plot = temp,
       path = here::here("ResultsReports"),
       width = 25, height = 25, units = "cm"
)

# Celan up
rm(temp)
