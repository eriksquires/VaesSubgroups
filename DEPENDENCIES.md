# Dependencies

This document lists the software dependencies required to run the code in this repository.

## Software Dependencies:

Tested with the following:

-   Ubuntu 22.04.5 LTS ("Jammy Jellyfish")
-   R - 4.5.1
-   quarto - 1.4 and 1.7
-   lualatex - 1.14.0 and 1.22.0

The statistics and spreadsheet manipulation packages are all pretty basic. The only place I can imagine an OSX or other Linux user having a problem is with Lualatex. If you are using OSX you might want to look at <https://tug.org/mactex/> or try:

``` bash
brew install --cask mactex
```

If you have insurmountable Quarto problems you will find test versions of the plots at the end of summarize_vaes_csv_by_symptom_domain.R

## Required R packages:

``` r
# Core data analysis
install.packages(c(
  "tidyverse",    # 2.0.0 - data manipulation and visualization
  "dplyr",        # 1.1.4 - data manipulation 
  "stringr",      # 1.5.1 - string manipulation
  "readxl",       # 1.4.5 - Excel file import
  "broom",        # 1.0.8 - statistical model tidying
  "gtools",       # 3.9.5 - various utilities
  
  # Visualization
  "ggrepel",      # 0.9.6 - text/label positioning
  "hrbrthemes",   # 0.8.7 - ggplot2 themes
  "patchwork",    # 1.3.2 - plot composition
  "showtext",     # 0.9.7 - font management
  
  # Tables and reporting
  "gt",           # 1.0.0 - table formatting
  "here",         # 1.0.1 - file path management
  "rmarkdown"     # 2.29  - document generation
  "quarto"        # 1.5.1 - document generation
))
```
