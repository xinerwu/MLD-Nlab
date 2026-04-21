# Creates MAT models for sea ice variables from the n=1968 database
# Notes: to view source code eg: getAnywhere(reconPlot.predict.mat)
library(analogue)

dino <- read.delim('dino1968.txt',row.names = 1)
mld <- rio::import('SI.xlsx',row.names = 1)
env_id <- 2:17
n.analogues <- 5

modern <- log(dino+1)
# Remove duplicates in the dinocyst training database
dup <- c("1101","1102","1100","1105")
modern <- modern[ !rownames(modern) %in% dup, ]
mld <- mld[ !rownames(mld) %in% dup, ]

## Perform analogue matching
#result <- analog(modern,fossil,method="euclidean")

# Fit MAT model
mat_models <- vector("list",length=length(env_id))
names(mat_models) <- colnames(mld)[env_id]
# loop through each environmental variable
c=1
for (i in env_id) {
  env <- mld[, i]
  mat_model <- mat(modern,env,method="euclidean",k=n.analogues)
  mat_models[[c]] <- mat_model
  c=c+1
}

#fossil <- modern
#pred_list <- lapply(mat_models,function(model) predict(model,fossil)$predictions$model$predicted[n.analogues, ])
#pred_matrix <- do.call(cbind,pred_list)
pred_matrix <- sapply(mat_models,function(model) model$weighted$est[n.analogues, ])
colnames(pred_matrix) <- names(mat_models)
write.csv(pred_matrix, file = "SIrecon.csv")
save.image("./SI_mat_models.RData")
