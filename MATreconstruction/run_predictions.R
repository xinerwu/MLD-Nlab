# Make predictions from a list of fossil files and the pre-made MAT models
library(analogue)
#output_dir <- "./predictions"
output_dir <- "./SI-predictions"

# Load 17 MAT models for 17 environmental variables
#load("C:/Users/wuxin/Desktop/scpfiles/PMIP-MLD/mat/mat-models-1968.RData")
load("C:/Users/wuxin/Desktop/scpfiles/PMIP-MLD/mat/SI-mat-models.RData")

# List fossil files
file_list <- list.files(path="./cores", pattern = "\\.txt$",full.names = TRUE)

# Loop through files
all_predictions <- list()
for (file in file_list) {
  core <- read.delim(file, row.names = 1)
  fossil <- log(core+1)
  # For CSV files: fossil <- read.csv(file, row.names = 1)
  pred_list <- lapply(mat_models, function(model) predict(model, fossil)$predictions$model$predicted[n.analogues, ])
  pred_matrix <- do.call(cbind, pred_list)
  colnames(pred_matrix) <- names(mat_models)
  file_name <- basename(file)  # Extract file name without path
  all_predictions[[file_name]] <- pred_matrix
  output_file_name <- sub("\\.txt$", "_predictions.csv", file_name)  # Adjust extension if needed
  output_file <- file.path(output_dir, output_file_name)
  write.csv(pred_matrix, output_file)#, row.names = FALSE)
}