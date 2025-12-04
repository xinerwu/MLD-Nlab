# Computes Cohen's kappa with the vcd package for a proxy-model comparison
library(vcd)

# load binary data
dino <- read.csv('./Stats/binary_dino_anom.csv')
dino <- dino$binary_dino
all_model <- read.csv('./Stats/binary_model_anom.csv')

# loop through 15 models
for (i in 1:15) {
  model <- all_model[, i]
  
  # Create contingency table
  cont_table <- table(dino, model)
  
  # Compute Cohen’s kappa
  kappa_result <- Kappa(cont_table)
  
  # Print results
  print(kappa_result,CI=TRUE,level=0.95)
}