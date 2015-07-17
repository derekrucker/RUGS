library(foreach)
library(doParallel)
#library(doMC)
library(caret)
library(randomForest)

# Single core version
ptm <- proc.time()
top.param <- foreach(z=1:100, .combine=rbind, .packages='caret') %do% {
  require(randomForest)
  model <- randomForest(y ~ ., data=training, importance=TRUE, ntree=100)
  output <- as.data.frame(varImp(model, scale=F)[1])
  output[,2] <- output[,1]/max(output[,1])
  rownames(output)[which.max(output[,2])]
}
proc.time() - ptm

# Parallel processing version
cl <- makeCluster(4)
# NOTE - Adjust the value in makeCluster to reflect the number of cores your machine has available
registerDoParallel(cl)
#registerDoMC(cl)
ptm <- proc.time()
top.param <- foreach(z=1:100, .combine=rbind, .packages=c('caret','randomForest')) %dopar% {
  model <- randomForest(y ~ ., data=training, importance=TRUE, ntree=100)
  output <- as.data.frame(varImp(model, scale=F)[1])
  output[,2] <- output[,1]/max(output[,1])
  rownames(output)[which.max(output[,2])]
}
proc.time() - ptm
stopCluster(cl)
rm(cl)
