#!/usr/bin/env Rscript
# Parallel slopes models
# Only useful for most parallel symptom domains. 
# For example, domains like all_mean, pain, other, 
# neuroendocrine, neurocognitive have:
#   very close slopes between high and low groups, and
# extremely small p-values for the Group offset 
# (many in the 10⁻³–10⁻⁵ range from earlier runs).

# t-test of intercept (offset) difference between high and low groups
# domain ~ PEM + Group
# Input CSV must have columns:
#   cluster, PEM, Group (high/low),
#   Immune, Sleep, autonomic, fatigue,
#   neurocognitive, neuroendocrine, other, pain, all_mean

suppressPackageStartupMessages({
  library(tidyverse)
  library(broom)
})

input_file  <- "cluster_grouped_tidy.csv"
output_file <- "offset_ttest_pvalues.csv"

domains <- c("Immune","Sleep","autonomic","fatigue",
             "neurocognitive","neuroendocrine","other","pain","all_mean")

# Read data
df <- read_csv(input_file, show_col_types = FALSE)

# Make sure Group is a factor
df <- df %>% mutate(Group = factor(Group, levels = c("high","low")))

offset_results <- map_df(domains, function(d) {
  fit <- lm(reformulate(c("PEM","Group"), response = d), data = df)
  coef_tab <- tidy(fit)
  # coefficient for Group = difference in intercept (offset)
  grp_row <- coef_tab %>% filter(term %in% c("Grouplow","Group[T.low]"))
  tibble(
    domain    = d,
    offset_est = grp_row$estimate,
    offset_se  = grp_row$std.error,
    offset_t   = grp_row$statistic,
    offset_p   = grp_row$p.value
  )
})

write_csv(offset_results, output_file)
print(offset_results, n = nrow(offset_results))
cat("\nSaved:", output_file, "\n")
