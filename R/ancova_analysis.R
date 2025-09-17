# ANCOVA Analysis: All Symptom Domains vs. Group (controlling for PEM)
# Purpose: Generate statistical validation table for VaesSubgroups analysis
# Output: CSV file with ANCOVA results for all domains
#

library(tidyverse)

# Load data
input_file <- here::here("data", "cluster_grouped_tidy.csv")
if (!file.exists(input_file)) {
  stop("Input file not found. Please run summarize_vaes_csv_by_symptom_domain.R first.")
}

vcs_tidy <- read_csv(input_file, show_col_types = FALSE) %>%
  mutate(intensity_group = as.factor(str_trim(intensity_group))) %>%
  droplevels()

# Get all symptom domains (exclude cluster, intensity_group, PEM)
symptom_domains <- c("fatigue", "Immune", "Sleep", "autonomic", "neurocognitive", 
                     "neuroendocrine", "pain", "other", "all_mean")

# Store results
results <- data.frame()

for (domain in symptom_domains) {
  # Create formula dynamically
  formula_str <- paste(domain, "~ intensity_group + PEM")
  formula_obj <- as.formula(formula_str)
  
  # Fit model
  model <- aov(formula_obj, data = vcs_tidy)
  
  # Extract group effect statistics
  model_summary <- summary(model)
  group_p <- model_summary[[1]]["intensity_group", "Pr(>F)"]
  group_f <- model_summary[[1]]["intensity_group", "F value"]
  
  # Calculate adjusted means (controlling for PEM)
  grand_mean_pem <- mean(vcs_tidy$PEM)
  lm_model <- lm(formula_obj, data = vcs_tidy)
  adjusted_means <- predict(lm_model,
                           newdata = data.frame(
                             intensity_group = c("high", "low"),
                             PEM = c(grand_mean_pem, grand_mean_pem)
                           ))
  
  # Store result
  results <- rbind(results, data.frame(
    domain = domain,
    F_value = group_f,
    p_value = group_p,
    high_adj_mean = adjusted_means[1],
    low_adj_mean = adjusted_means[2],
    difference = adjusted_means[1] - adjusted_means[2]
  ))
}

# Sort by F-value (descending) and add significance indicators
results_final <- results %>%
  arrange(desc(F_value)) %>%
  mutate(
    F_value = round(F_value, 3),
    p_value = round(p_value, 6),
    high_adj_mean = round(high_adj_mean, 3),
    low_adj_mean = round(low_adj_mean, 3),
    difference = round(difference, 3),
    significant = p_value < 0.05,
    significance = case_when(
      p_value < 0.001 ~ "***",
      p_value < 0.01 ~ "**", 
      p_value < 0.05 ~ "*",
      p_value < 0.1 ~ ".",
      TRUE ~ ""
    )
  ) %>%
  rename(Domain = domain)

# Write to CSV
output_file <- here::here("data", "ancova_results.csv")
write_csv(results_final, output_file)

cat("ANCOVA analysis complete. Results saved to:", output_file, "\n")
cat("Domains with significant group differences (p < 0.05):", 
    sum(results_final$significant), "out of", nrow(results_final), "\n")