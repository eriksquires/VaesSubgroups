# Purpose: Main script to run all analyses and generate the report
#
# Author: Erik K. Squires
# Date: 2025-09-20
#

# Run from project root. 
source_here <- function(fname) {
  source(here::here("R", fname))
}

# Delete intermediate CSV files in data/
unlink(here::here("data", "*.csv"))

#
# Required to be sequential.
#
source_here("process_excel.R")
source_here("summarize_vaes_csv_by_symptom_domain.R")

#
# These can be run any time afterwards.
#
source_here("ancova_analysis.R")
source_here("leave_one_out.R")
source_here("r2_by_domain.R")

#
# Intermediate data files finished.
#
########################################
#
# Render PDF report.
#
q_doc <- here::here("docs", "VaesSubgroups.qmd")
quarto::quarto_render(q_doc, output_format = "pdf")
quarto::quarto_render(q_doc, output_format = "html")

# Not usually needed.  
# quarto::quarto_render(here::here("docs", "VaesSubgroups.qmd"), cache_refresh = TRUE)
