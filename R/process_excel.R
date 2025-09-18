# Purpose:  Reads Vaes (2023) ME/CFS cluster symptom data from Excel,
# cleans it up, and writes a CSV file with severity data only.
#
# Author: Erik K. Squires (c) 2025
#
#
# Data source:
#   Symptom-based clusters in people with ME/CFS: an illustration of clinical variety in a cross-sectional cohort
# by:
#   Vaes, A.W., Van Herck, M., Deng, Q. et al
#   https://doi.org/10.1186/s12967-023-03946-6
#

library(readxl)
library(dplyr)
library(stringr)


# Create a "data" folder in this project if it does not exist
if (!dir.exists(here::here("data"))) {
  dir.create(here::here("data"))
}

process_excel <- function(do_large = TRUE) {
  # Function to process the Excel file and extract severity data
  # do_large: if TRUE, process large clusters (size >= 10), else small clusters (mostly size 1)
  
  
  if (do_large == TRUE) {
    # Summarize top 13 clusters (size >= 10)
    # Per Vaes web page:  Additional file 3 table S1
    vaes_data_url <- "https://static-content.springer.com/esm/art%3A10.1186%2Fs12967-023-03946-6/MediaObjects/12967_2023_3946_MOESM3_ESM.xlsx"
    excel_file  <- here::here("data", "12967_2023_3946_MOESM3_ESM.xlsx")
    
    output_file <- here::here("data", "vaes_clusters_severity.csv")
    sizes_file  <- here::here("data", "vaes_cluster_sizes.csv")
    
  } else {
    # Summarize bottom 32 clusters (mostly size 1)
    # Per Vaes web page: Additional file 4 table S2
    vaes_data_url <- "https://static-content.springer.com/esm/art%3A10.1186%2Fs12967-023-03946-6/MediaObjects/12967_2023_3946_MOESM4_ESM.xlsx"
    excel_file  <- here::here("data", "12967_2023_3946_MOESM4_ESM.xlsx")
    
    output_file <- here::here("data", "vaes_clusters_severity_smallest.csv")
    sizes_file  <- here::here("data", "vaes_cluster_sizes_smallest.csv")
  }
  
  
  # Download the Excel file if it does not exist
  if (!file.exists(excel_file)) {
    download.file(vaes_data_url, excel_file, mode = "wb")
  }
  
  # Read the Excel file
  raw_data <- read_excel(excel_file, sheet = 1, col_names = FALSE)
  
  # Extract cluster IDs from row 3
  cluster_row <- raw_data[3, ]
  cluster_ids <- c()
  for (i in 1:ncol(cluster_row)) {
    val <- cluster_row[[1, i]]
    if (!is.na(val) && !is.null(val)) {
      # Convert to short format: Cluster2 -> C2
      cluster_num <- str_replace(as.character(val), "luster", "") # Shorten string
      if (!is.na(cluster_num)) {
        cluster_ids <- c(cluster_ids, cluster_num)
      }
    }
  }
  
  print("Extracted cluster numbers:")
  print(cluster_ids)
  
  # Get cluster sizes ####
  cluster_sizes <- as.character(raw_data[4, ])
  
  # Remove NA from cluster sizes
  cluster_sizes <- cluster_sizes[!is.na(cluster_sizes) &
                                   cluster_sizes != ""]
  
  # Remove first entry in cluster_sizes
  cluster_sizes <- cluster_sizes[-1]
  
  # Combine cluster_ids and cluster sizes into a new DF
  cluster_info <- data.frame(cluster = cluster_ids, size = as.numeric(cluster_sizes[seq_along(cluster_ids)]))
  
  write.csv(cluster_info, sizes_file, row.names = FALSE)
  
  
  # Identify mean and stdev columns from row 5 ####
  header_row <- as.character(raw_data[5, ])
  mean_cols <- which(header_row == "Mean")
  stdev_cols <- which(header_row == "stdev")
  
  print(paste("Mean columns:", paste(mean_cols, collapse = ", ")))
  print(paste("Stdev columns:", paste(stdev_cols, collapse = ", ")))
  
  # Create new column names for data columns (first 2 are Symptomgroup and Symptoms)
  new_colnames <- c("Symptomgroup", "Symptoms")
  
  # Add cluster numbers for mean columns
  for (i in seq_along(mean_cols)) {
    if (i <= length(cluster_ids)) {
      new_colnames <- c(new_colnames, cluster_ids[i])
    }
  }
  
  print("New column names:")
  print(new_colnames)
  
  # Keep only the columns we want (first 2 + mean columns + type column)
  cols_to_keep <- c(1, 2, mean_cols)
  
  # Get the actual data starting from row 6 (after headers)
  data_start_row <- 6
  data_rows <- raw_data[data_start_row:nrow(raw_data), cols_to_keep]
  
  # Set column names
  colnames(data_rows) <- new_colnames
  
  # Remove rows where first column is NA (empty rows)
  data_clean <- data_rows[!is.na(data_rows[[1]]), ]
  
  # Keep only severity rows (those ending with "- s")
  # Look at the original symptom column in raw data
  original_symptoms <- data_clean[[2]][1:nrow(data_clean)]
  
  
  severity_pattern <- ".*-\\s*s$"
  
  # Find rows that match severity pattern
  severity_row_indices <- which(str_detect(original_symptoms, severity_pattern))
  
  print(paste(
    "Found",
    length(severity_row_indices),
    "severity rows to keep"
  ))
  
  # Keep only severity rows
  data_clean <- data_clean[severity_row_indices, ]
  
  # Clean symptom names - remove only the " - s" suffix
  data_clean$Symptoms <- str_replace(data_clean$Symptoms, "\\s*-\\s*s$", "")
  
  # Round numeric columns to 4 decimal places to match target
  numeric_cols <- 3:(ncol(data_clean))  # Skip first 2 and last column
  for (col in numeric_cols) {
    data_clean[[col]] <- round(as.numeric(data_clean[[col]]), 4)
  }
  
  print("Final processed data:")
  print(head(data_clean, 10))
  
  # Write to CSV
  write.csv(data_clean, output_file, row.names = FALSE)
  print(paste0("File written to ", output_file))
}

process_excel(do_large = TRUE)  # Process large clusters
# process_excel(do_large = FALSE) # Process small clusters