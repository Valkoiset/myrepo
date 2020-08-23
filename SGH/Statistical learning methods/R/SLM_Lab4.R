# Statistical learning methods
# Lab 4 - Classical machine learning models: CART, random forest
# materials: www.e-sgh.waw.pl/bk48144/SLM
# mail: bk48144@sgh.waw.pl, konbeata@gmail.com

rm(list=ls())
setwd("~/Desktop/SGH/2 semester/Statistical learning methods/R")

library(MASS)
library(rpart)
library(party)
library(randomForest)
library(ROCR)
library(rpart.plot)
library(tree)

###TREE PACKAGE###
#Data
#https://cran.r-project.org/web/packages/MASS/MASS.pdf, p. 20 - data description
#For Boston data provide a model that will predict the median value of home
#Calculate MSE and MAE to chceck the quality of the model

data <- Boston
summary(data)

set.seed(0)
rand <- sample(1:nrow(data), 0.7*nrow(data))
train <- data[rand, ]
valid <- data[-rand, ]
str(train)
data$black <- NULL

tree_boston <- tree(medv ~ . , data = train)

plot(tree_boston) # going to the left means that condition is fullfilled
                  # leaf shows expected value of variable (dependent)
text(tree_boston)

pred <- predict(tree_boston, newdata = valid)
head(pred)

### table(pred, valid$medv) # no confusion matrix

#Quality of the model
# MAE or MSE
#MAE - mean absolute error
#1/n(sum(|y-y_hat|))
mae <- mean(abs(valid$medv - pred))

#MSE - mean square error
#1/n(sum((y-y_hat)^2))
mse <- mean((valid$medv - pred)^2)

#Is my model better than random model
randPred <- sample(seq(min(train$medv), 
                       max(train$medv),by = 0.1),
                   nrow(valid))

mse2 <- mean((valid$medv - randPred)^2)
mae2 <- mean(abs(valid$medv - randPred))

###RPART, CTREE###
##Bulid tree with rpart and ctree model and randomForest
#Divide dataset into train (70%) and validation set (30%)
#What % of observations was correctly classified? Calculate Accuracy, TPR, FPR
#Prune tree according to optimal complexity
#Is is better?

# ---------------------------------------------------------------
forest <- randomForest(medv ~ ., data = train, ntree = 100, do.trace = T,
                       importance = T) # importance adds 1 more plot with MSE
varImpPlot(forest)
predForest <- predict(forest, newdata = valid)

mseForest <- mean((valid$medv - predForest)^2) # value here is lower than in decision 
                                          # tree, then random forest gives better results


website <- "https://archive.ics.uci.edu/ml/machine-learning-databases/statlog/australian/australian.dat"
credits <- read.table(website, header=FALSE, sep = " ")
names(credits) <- c(paste("A", 1:14, sep = ""),"class")

set.seed(1)
rand <- sample(1:nrow(credits), 0.7 * nrow(credits))
credTrain <- credits[rand, ]
credValid <- credits[-rand, ]

ctree.model <- ctree(class ~ .,data = credTrain)
plot(ctree.model, type = "simple")

predCtree <- predict(ctree.model, newdata = credValid)
class(predCtree)
predCtree <- as.vector(predCtree)

Class <- ifelse(predCtree > 0.5, 1, 0)
conf <- table(Class, credValid$class)

# accuracy - % of correctly classified observations
acc <- (conf[1,1] + conf[2,2]) / sum(conf)
tpr <- conf[2,2] / (conf[2,2] + conf[1,2])  # true positive rate
fpr <- conf[2,1] / (sum(conf[,1]))          # false positive rate

# plotting roc curve
p <- prediction(predCtree, credValid$class)
plot(performance(p, "tpr", "fpr"), colorize = T) # colorize changes the color on cut-offs
attr(performance(p, "auc"), "y.values")          # area under the curve

rpart.model <- rpart(class ~ ., credTrain, minsplit = 2,
                     cp = .00000001) # cp - complexity of the model
plot(rpart.model)
text(rpart.model)

pdf("plot.pdf")
rpart.plot(rpart.model)
dev.off()

plotcp(rpart.model)

minimum.error <- which.min(rpart.model$cptable[,"xerror"])
minimum.error

optimal.complexity <- rpart.model$cptable[minimum.error,"CP"]
optimal.complexity

points(minimum.error, rpart.model$cptable[minimum.error,"xerror"], col = "red", pch = 19)

pruned.tree <- prune(rpart.model, cp = optimal.complexity)
plot(pruned.tree, compress = T, uniform = T,margin = 0.1, branch = 0.3, nspace = 2)
text(pruned.tree, use.n = TRUE, pretty = 0)

predictPrune <- predict(pruned.tree, newdata = credValid)
head(predictPrune)

p <- prediction(predictPrune, credValid$class)
plot(performance(p, "tpr", "fpr"))
attr(performance(p, "auc"), "y.values")

# 1
forestCred <- randomForest(factor(class) ~ ., data = credTrain)
pred2 <- predict(forestCred, newdata = credValid, type = "prob")
pred2 <- as.vector(pred2[, 2])

# 2
forestCred <- randomForest(class ~ ., data = credTrain)
pred2 <- predict(forestCred, newdata = credValid)

p2 <- prediction(pred2, credValid$class)
plot(performance(p2, "tpr", "fpr"))
attr(performance(p2, "auc"), "y.values")

###Random Forest###
MyForest <- randomForest(class~., data = TrainCredit, ntree = 100, importance = T)
varImpPlot(MyForest)

prognoza<-predict(MyForest, newdata = ValidCredit, type = "response")
