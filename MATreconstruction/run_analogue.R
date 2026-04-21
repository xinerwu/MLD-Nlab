# Creates MAT models for MLD variables from the n=1968 database
# Notes: to view source code eg: getAnywhere(reconPlot.predict.mat)
library(analogue)

dino <- read.delim('dino1968.txt',row.names = 1)
mld <- rio::import('MLD_ref10m2023.xlsx')
#core <- read.delim('SIP066P4.txt',row.name=1)
env_id <- 2:18
n.analogues <- 5

modern <- log(dino+1)
# Remove duplicates in the dinocyst training database
dup <- c("1101","1102","1100","1105")
modern <- modern[ !rownames(modern) %in% dup, ]
mld <- mld[ !rownames(mld) %in% dup, ]
#fossil <- log(core+1)

# Perform analogue matching
#analogues <- analog(modern,fossil,method="euclidean")

# Fit MAT model
mat_models <- vector("list",length=length(env_id))
names(mat_models) <- colnames(mld)[env_id]
# loop through each environmental variable
c=1
for (i in env_id) {
  env <- mld[, i]
  mat_model <- mat(modern,env,method="euclidean",k=n.analogues,weighted=TRUE)
  mat_models[[c]] <- mat_model
  c=c+1
}
#pred_list <- lapply(mat_models,function(model) predict(model,k=n.analogues,weighted=TRUE)$predictions$model$predicted[n.analogues, ])
#pred_matrix <- do.call(cbind,pred_list)
#pred <- predict(mat_model,fossil,k=5)
#write.csv(pred$predictions$model$predicted, file = "test1.csv")
pred_matrix <- sapply(mat_models,function(model) model$weighted$est[n.analogues, ])
colnames(pred_matrix) <- names(mat_models)
write.csv(pred_matrix, file = "BM23recon.csv")
save.image("./MLD_mat_models.RData")
