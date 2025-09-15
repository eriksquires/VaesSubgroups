#!/usr/bin/env Rscript

# Leave-one-out ΔR² per domain vs PEM
# Input: cluster_grouped_tidy.csv with columns:
#   cluster, PEM, Immune, Sleep, autonomic, fatigue,
#   neurocognitive, neuroendocrine, other, pain, all_mean, (optionally Group)
# Output: a CSV with ΔR² by domain for removing each cluster, plus summary columns.

suppressPackageStartupMessages({
  library(tidyverse)
})

# ---------------------- Config ----------------------
input_file <- here::here("data", "cluster_grouped_tidy.csv")  # set path as needed
output_file <- here::here("data","loo_delta_r2_by_cluster.csv")

# Domains to analyze
domains <- c("Immune","Sleep","autonomic","fatigue",
             "neurocognitive","neuroendocrine","other","pain","all_mean")

# Use only these 13 clusters by default (edit or set to NULL to include all)
#chosen_clusters <- c("C9","C19","C26","C28","C31","C36","C37","C40",
#                     "C2","C4","C7","C11","C24")

chosen_clusters <- NULL
# ----------------------------------------------------

# Helper: get R^2 for lm(domain ~ PEM)
r2_fit <- function(df, domain) {
  fit <- lm(reformulate("PEM", response = domain), data = df)
  summary(fit)$r.squared %||% NA_real_
}

# Read
df <- read_csv(input_file, show_col_types = FALSE) %>%
  mutate(cluster = as.character(cluster))

# Subset to chosen clusters (if specified)
if (!is.null(chosen_clusters)) {
  df <- df %>% filter(cluster %in% chosen_clusters)
}

# Basic checks
stopifnot(all(c("cluster","PEM") %in% names(df)))
stopifnot(all(domains %in% names(df)))

# Baseline pooled R^2 per domain (all clusters)
baseline <- tibble(
  domain = domains,
  r2_all = map_dbl(domains, ~ r2_fit(df, .x))
)

# Leave-one-out ΔR²
clusters <- unique(df$cluster)

loo_rows <- map_df(clusters, function(cl) {
  df_loo <- df %>% filter(cluster != cl)
  r2_loo <- map_dbl(domains, ~ r2_fit(df_loo, .x))
  tibble(cluster = cl, domain = domains, r2_loo = r2_loo)
}) %>%
  left_join(baseline, by = "domain") %>%
  mutate(delta_r2 = r2_loo - r2_all)

# Wide table with per-domain ΔR² columns
wide <- loo_rows %>%
  select(cluster, domain, delta_r2) %>%
  mutate(col = paste0("dR2_", domain)) %>%
  select(-domain) %>%
  pivot_wider(names_from = col, values_from = delta_r2)

# Add summary columns: count of domains with improvement, mean ΔR²
summary_cols <- loo_rows %>%
  group_by(cluster) %>%
  summarise(
    domains_improved = sum(delta_r2 > 0, na.rm = TRUE),
    mean_dR2 = mean(delta_r2, na.rm = TRUE),
    .groups = "drop"
  )

result <- wide %>%
  left_join(summary_cols, by = "cluster") %>%
  arrange(desc(domains_improved), desc(mean_dR2))

# Write CSV and also print to console
write_csv(result, output_file)
print(result, n = nrow(result))
cat("\nSaved:", output_file, "\n")
