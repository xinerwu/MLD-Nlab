# Creates MAT models for sea ice variables from the n=1968 database
# Notes: to view source code eg: getAnywhere(reconPlot.predict.mat)
library(analogue)

dino <- read.delim('dino1968.txt',row.names = 1)
mld <- rio::import('SI.xlsx')
env_id <- 2:15
n.analogues <- 5

modern <- log(dino+1)

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

fossil <- modern
pred_list <- lapply(mat_models,function(model) predict(model,fossil)$predictions$model$predicted[n.analogues, ])
pred_matrix <- do.call(cbind,pred_list)
colnames(pred_matrix) <- names(mat_models)
write.csv(pred_matrix, file = "SIrecon.csv")