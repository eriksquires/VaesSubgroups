# Purpose: Main script to run all analyses and generate the report
#
# Author: Erik K. Squires
# Date: 2025-09-20
#


source_here <- function(fname) {
  source(here::here("R", fname))
}

#
# Required to be first.
#
source_here("process_excel.R")
source_here("summarize_vaes_csv_by_symptom_domain.R")

#
# These can be rerun any time afterwards.
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
quarto::quarto_render(here::here("docs", "VaesSubgroups.qmd"))
