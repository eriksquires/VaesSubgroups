library(readxl)
library(dplyr)
library(stringr)

# Read the Excel file
excel_file <- "12967_2023_3946_MOESM3_ESM.xlsx"

# Read the entire file without headers to examine structure
raw_data <- read_excel(here::here("data", excel_file), sheet = 1, col_names = FALSE)

# Extract cluster IDs from row 3
cluster_row <- raw_data[3, ]
cluster_ids <- c()
for (i in 1:ncol(cluster_row)) {
  val <- cluster_row[[1, i]]
  if (!is.na(val) && !is.null(val)) {
    # Convert to short format: Cluster2 -> 2
    cluster_num <- str_extract(as.character(val), "\\d+")
    if (!is.na(cluster_num)) {
      cluster_ids <- c(cluster_ids, cluster_num)
    }
  }
}

print("Extracted cluster numbers:")
print(cluster_ids)

# Identify mean and stdev columns from row 5
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

# Add type column
new_colnames <- c(new_colnames, "type")

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

print("First few rows of cleaned data:")
print(head(data_clean))

# Keep only severity rows (those ending with "- s")
# Look at the original symptom column in raw data
original_symptoms <- raw_data[[2]][data_start_row:nrow(raw_data)]
severity_pattern <- ".*-\\s*s$"

# Find rows that match severity pattern
severity_row_indices <- which(str_detect(original_symptoms, severity_pattern))

print(paste("Found", length(severity_row_indices), "severity rows to keep"))

# Keep only severity rows
data_clean <- data_clean[severity_row_indices, ]

# Clean symptom names - remove only the " - s" suffix
data_clean$Symptoms <- str_replace(data_clean$Symptoms, "\\s*-\\s*s$", "")

# Round numeric columns to 4 decimal places to match target
numeric_cols <- 3:(ncol(data_clean)-1)  # Skip first 2 and last column
for (col in numeric_cols) {
  data_clean[[col]] <- round(as.numeric(data_clean[[col]]), 4)
}

# Add type column (all severity data)
data_clean$type <- "s"

print("Final processed data:")
print(head(data_clean, 10))

# Write to CSV with quotes only where needed (like the original)
write.csv(data_clean, "vaes_clusters_severity_new.csv", row.names = FALSE)

print("File written to vaes_clusters_severity.csv")