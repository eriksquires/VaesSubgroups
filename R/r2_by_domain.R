#!/usr/bin/env Rscript

# R^2 of domain ~ PEM for: Combined, High-only, Low-only
# Input CSV must have columns:
#   cluster, PEM, Immune, Sleep, autonomic, fatigue,
#   neurocognitive, neuroendocrine, other, pain, all_mean
# Optionally a 'Group' column ("high"/"low"); otherwise we derive it from IDs below.

suppressPackageStartupMessages({
  library(tidyverse)
})

# ----------------------------- Config -----------------------------
input_file  <-  here::here("data","cluster_grouped_tidy.csv")   # set your path
output_file <-  here::here("data","r2_by_domain_combined_high_low.csv")

# Domains to analyze
domains <- c("Immune","Sleep","autonomic","fatigue",
             "neurocognitive","neuroendocrine","other","pain","all_mean")

# If 'Group' is missing in the CSV, we’ll derive it from these IDs:
#high_clusters <- c("C9","C19","C26","C28","C31","C36","C37","C40")
#low_clusters  <- c("C2","C4","C7","C11","C24")

# Optionally restrict to exactly these 13 clusters (set to FALSE to use all in file)
restrict_to_13 <- FALSE
# -----------------------------------------------------------------

# Helper: R^2 for lm(domain ~ PEM)
r2_fit <- function(df, domain) {
  if (nrow(df) < 2) return(NA_real_)
  fit <- lm(reformulate("PEM", response = domain), data = df)
  summary(fit)$r.squared %||% NA_real_
}

# Read data
df <- read_csv(input_file, show_col_types = FALSE) %>%
  mutate(cluster = as.character(cluster)) %>%
  rename(Group = intensity_group)  # in case 'group' is used

# Optionally restrict to the 13 clusters
if (restrict_to_13) {
  df <- df %>% filter(cluster %in% c(high_clusters, low_clusters))
}

# Basic checks
stopifnot(all(c("cluster","PEM","Group") %in% names(df)))
stopifnot(all(domains %in% names(df)))

# Build three data frames: combined, high, low
df_all  <- df
df_high <- df %>% filter(Group == "high")
df_low  <- df %>% filter(Group == "low")

# Compute R^2 per domain for each subset
res <- tibble(domain = domains) %>%
  mutate(
    R2_combined = map_dbl(domain, ~ r2_fit(df_all,  .x)),
    R2_high     = map_dbl(domain, ~ r2_fit(df_high, .x)),
    R2_low      = map_dbl(domain, ~ r2_fit(df_low,  .x))
  ) %>%
  arrange(domain)

# Round all numeric values to 2 digits
res <- res %>%
  mutate(across(where(is.numeric), ~ round(.x, 2)))

# Write and print
write_csv(res, output_file)
print(res, n = nrow(res))
cat("\nSaved:", output_file, "\n")
