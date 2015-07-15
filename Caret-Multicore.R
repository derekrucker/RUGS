library(doParallel)
#library(doMC)
library(foreach)
library(caret)
library(randomForest)

# Create some random data
training <- foreach(z=1:20, .combine=cbind) %do% {
  runif(400,1,100)
}

colnames(training)[1] <- "y"

# Train a random forest - single core
ptm <- proc.time()
model <- train(y ~ ., data = training, method = "rf")
proc.time() - ptm

cl <- makeCluster(4)
# NOTE - Adjust the value in makeCluster to reflect the number of cores your machine has available
registerDoParallel(cl)

# Train a random forest - multicore
ptm <- proc.time()
model <- train(y ~ ., data = training, method = "rf")
proc.time() - ptm
stopCluster(cl)
