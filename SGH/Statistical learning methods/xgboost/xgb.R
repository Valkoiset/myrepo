

# https://xgboost.readthedocs.io/en/latest/R-package/xgboostPresentation.html
# In this example, we are aiming to predict whether a mushroom can be eaten or not (like in many tutorials, example data are the same as you will use on in your every day life :-)

setwd("~/Desktop/SGH/2 semester/Statistical learning methods/xgboost")
rm(list=ls())
require(xgboost)

data(agaricus.train, package='xgboost')
data(agaricus.test, package='xgboost')
train <- agaricus.train
test <- agaricus.test

str(train)

dim(train$data) # [1] 6513  126
dim(test$data)  # [1] 1611  126

class(train$data)[1] # [1] "dgCMatrix"
class(train$label)   # [1] "numeric"

bstSparse <- xgboost(data = train$data, label = train$label, max.depth = 2, eta = 1, nthread = 2, nrounds = 2, objective = "binary:logistic")
# [0]	train-error:0.046522
# [1]	train-error:0.022263

bstDense <- xgboost(data = as.matrix(train$data), label = train$label, max.depth = 2, eta = 1, nthread = 2, nrounds = 2, objective = "binary:logistic")
# [0]	train-error:0.046522
# [1]	train-error:0.022263

dtrain <- xgb.DMatrix(data = train$data, label = train$label)
bstDMatrix <- xgboost(data = dtrain, max.depth = 2, eta = 1, nthread = 2, nrounds = 2, objective = "binary:logistic")

# [0]	train-error:0.046522
# [1]	train-error:0.022263

# verbose = 0, no message
bst <- xgboost(data = dtrain, max.depth = 2, eta = 1, nthread = 2, nrounds = 2, objective = "binary:logistic", verbose = 0)

# verbose = 1, print evaluation metric
bst <- xgboost(data = dtrain, max.depth = 2, eta = 1, nthread = 2, nrounds = 2, objective = "binary:logistic", verbose = 1)

# verbose = 2, also print information about tree
bst <- xgboost(data = dtrain, max.depth = 2, eta = 1, nthread = 2, nrounds = 2, objective = "binary:logistic", verbose = 2)

pred <- predict(bst, test$data)

# size of the prediction vector
print(length(pred))
# [1] 1611

# limit display of predictions to the first 10
print(head(pred))

prediction <- as.numeric(pred > 0.5)
print(head(prediction))

err <- mean(as.numeric(pred > 0.5) != test$label)
print(paste("test-error=", err))

dtrain <- xgb.DMatrix(data = train$data, label=train$label)
dtest <- xgb.DMatrix(data = test$data, label=test$label)

watchlist <- list(train=dtrain, test=dtest)

bst <- xgb.train(data=dtrain, max.depth=2, eta=1, nthread = 2, nrounds=2, watchlist=watchlist, objective = "binary:logistic")

bst <- xgb.train(data=dtrain, max.depth=2, eta=1, nthread = 2, nrounds=2, watchlist=watchlist, eval.metric = "error", eval.metric = "logloss", objective = "binary:logistic")

bst <- xgb.train(data=dtrain, booster = "gblinear", max.depth=2, nthread = 2, nrounds=2, watchlist=watchlist, eval.metric = "error", eval.metric = "logloss", objective = "binary:logistic")

xgb.DMatrix.save(dtrain, "dtrain.buffer")

# to load it in, simply call xgb.DMatrix
dtrain2 <- xgb.DMatrix("dtrain.buffer")

bst <- xgb.train(data=dtrain2, max.depth=2, eta=1, nthread = 2, nrounds=2, watchlist=watchlist, objective = "binary:logistic")

label = getinfo(dtest, "label")
pred <- predict(bst, dtest)
err <- as.numeric(sum(as.integer(pred > 0.5) != label))/length(label)
print(paste("test-error=", err))
## [1] "test-error= 0.0217256362507759"

importance_matrix <- xgb.importance(model = bst)
print(importance_matrix)
xgb.plot.importance(importance_matrix = importance_matrix)

xgb.dump(bst, with.stats = T)

xgb.plot.tree(model = bst)

# save model to binary local file
xgb.save(bst, "xgboost.model")

# load binary model to R
bst2 <- xgb.load("xgboost.model")
pred2 <- predict(bst2, test$data)

# And now the test
print(paste("sum(abs(pred2-pred))=", sum(abs(pred2-pred))))
## [1] "sum(abs(pred2-pred))= 0"

# save model to R's raw vector
rawVec <- xgb.save.raw(bst)

# print class
print(class(rawVec))
## [1] "raw"
# load binary model to R
bst3 <- xgb.load(rawVec)
pred3 <- predict(bst3, test$data)

# pred3 should be identical to pred
print(paste("sum(abs(pred3-pred))=", sum(abs(pred3-pred))))
## [1] "sum(abs(pred3-pred))= 0"

