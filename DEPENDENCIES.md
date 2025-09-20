# Dependencies

## Executables:

Tested with the following executables

- R - 4.5.1
- quarto - 1.4 and 1.7
- lualatex - 1.14.0 and 1.22.0

## Required R packages:

```r
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
  "rmarkdown"     # 2.29 - document generation
))
```

