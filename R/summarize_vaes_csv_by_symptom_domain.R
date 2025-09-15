# Purpose:  Read Vaes (2023) ME/CFS cluster symptom data, 
# calculate PEM and non-PEM severity means, and make it tidy (rotate)
#
# Plots are provided at the end for debugging and visual verification.
#
# Author: Erik K. Squires (c) 2025
#
#
library(tidyverse)
library(gtools)
library(hrbrthemes)

geo_pos <- function(v) exp(mean(log(v[v > 0]), na.rm = TRUE))
# geo_pos <- function(v) mean(v)


# Read and Rotate Data ####
input_file <- here::here("data", "vaes_clusters_severity.csv")

if (!file.exists(input_file)) {
  stop(paste("Input file", input_file, "not found. Please run process_excel.R first."))
}

vcs <- read_csv(input_file) %>%
  select(-any_of("type")) # Vestige from earlier versions


symptom_groups <- vcs %>% select(Symptomgroup, Symptoms)

# Simple file with symptom group and symptom
write_csv(symptom_groups, here::here("data", "symptom_groups.csv"))

vcs <- vcs %>% select(-Symptomgroup)



# Rotate vcs
vcs_long <- vcs %>%
  pivot_longer(cols = -Symptoms, names_to = "cluster", values_to = "Severity")

all_clusters <- vcs_long %>%
  distinct(cluster) %>%
  arrange(cluster) %>%
  pull(cluster)

# Convert cluster to an ordered factor using mixed sort
vcs_long$cluster <- factor(vcs_long$cluster, 
                           levels = mixedsort(unique(vcs_long$cluster)))


# We'll need this later after grouping
all <- vcs_long %>%
  group_by(cluster) %>%
  summarize(all_mean = mean(Severity)) %>%
  ungroup()


# Create new DF of geometric means per symptom group
vcs_grouped <- vcs_long %>%
  left_join(symptom_groups, by = "Symptoms") %>%
  group_by(cluster, Symptomgroup) %>%
  summarize(geom_mean = geo_pos(Severity), .groups = 'drop')

  
vcs_tidy <- vcs_grouped %>%
  pivot_wider(names_from = Symptomgroup, values_from = geom_mean) %>%
  left_join(all, by = "cluster")


# From visual inspection of charts, below, we identify members of each group ####
high_symptom_clusters <- mixedsort( c("C37", "C28", "C40", "C31", "C9", "C26", "C36", "C19"))
# low_symptom_clusters <- c( "C2", "C11", "C4", "C24", "C7")
low_symptom_clusters <- mixedsort(setdiff(all_clusters, high_symptom_clusters))


vcs_tidy <- vcs_tidy %>%
  mutate(intensity_group = case_when(
    cluster %in% high_symptom_clusters ~ "high",
    cluster %in% low_symptom_clusters ~ "low",
    TRUE ~ "out"
  )) %>%
  select(cluster, intensity_group, everything())

# write_rds(vcs_tidy, here::here("data", "cluster_grouped_tidy.rds"))
write_csv(vcs_tidy, here::here("data", "cluster_grouped_tidy.csv"))

#
# Data creation end
# 
# Plotting function ####
#
# Useful for debugging, but docs have their own plot functions. 
#
#
geo_plot_vs_pem <- function(yvar, ylabel) {
  # Not strictly needed, but makes reading and debugging nicer
  columns = c("cluster", "PEM", yvar, "intensity_group")
  df <- vcs_tidy %>% select(all_of(columns))
  
  ggplot(df, aes(x = PEM, y = !!sym(yvar))) +
    geom_point(aes(color = intensity_group, shape = intensity_group), size = 3) +
    ggrepel::geom_text_repel(aes(label = cluster), size = 3, show.legend = FALSE) +
    #   scale_shape_manual(values = c("high" = 16, "low" = 17, "out" = 4)) +
    scale_shape_manual(values = c("high" = 16, "low" = 17)) +
    scale_color_brewer(name = "Subgroup", type="qual", palette = "Set1",
                       labels = c("high" = "High", "low" = "Low")) +
    guides(color = guide_legend(override.aes = list(shape = c(16, 17))),
           shape = "none") +
    geom_smooth(aes(color = intensity_group, group = intensity_group), method = "lm", se = TRUE) +
    labs(title = paste(ylabel, "vs PEM"),
         x = "PEM",
         y = ylabel) +
    theme_ipsum() + 
    xlim(0, 3.5) + ylim(0, 3.5)
}

geo_plot_vs_pem('all_mean', "All Arithmetic Mean")
geo_plot_vs_pem('Sleep', 'Sleep Geometric Mean')
geo_plot_vs_pem('neurocognitive', 'Neurocognitive Geometric Mean')
geo_plot_vs_pem('neuroendocrine', 'Neuroendocrine Geometric Mean')
geo_plot_vs_pem('pain', 'Pain Geometric Mean')
geo_plot_vs_pem('Immune', 'Immune')
geo_plot_vs_pem('fatigue', 'Fatigue')
geo_plot_vs_pem('other', 'Other')
geo_plot_vs_pem('autonomic', 'Autonomic')

#
#
# End of File ####