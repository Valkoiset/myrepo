

library(BCA)
library(relimp)
library(car)
library(RcmdrMisc)
library(nnet)
library(rpart)
library(rattle)
library(readxl)
library(tree)
library(dplyr)

# clear the workspace, plots and console
rm(list = ls())
if (!is.null(dev.list()))
  dev.off()
cat("\014")

setwd("~/Desktop/SGH/2 semester/Big data/labs/9")
# Loading churn
churn <- read.csv("churn.csv")
variable.summary(churn)

              # Data preparation 
churn$customerID <- NULL
churn$Churn <- ifelse(churn$Churn == "Yes", 1, 0)

# Excluding all NA from churn
churn <- na.exclude(churn)

# Checking if there are still some NA values
any(is.na(churn))

# dividing data on training and validation datasets
set.seed(0)
rand <- sample(1:nrow(churn), 0.7 * nrow(churn))
train <- churn[rand,]
valid <- churn[-rand,]

# -------- tree --------
tree <- tree(Churn ~ ., data = train)
summary(tree)
plot(tree)
text(tree)

# predicting and computing accuracy
t_pred = predict(tree, valid, type = "vector") # it is a vector by default,
# so no no need to type it
t_pred = round(t_pred, 0)
confMat <- table(valid$Churn, t_pred)
accuracy <- sum(diag(confMat)) / sum(confMat)
accuracy  # 0.8461538

# -------- GLM --------
GLM <- glm(Churn ~ ., family = binomial(logit), data = train)
summary(GLM)

# R2 McFadden value
1 - (GLM$deviance / GLM$null.deviance)  # 0.7762173

# -------- rpart --------
RPART <- rpart(Churn ~ .,
               data = train,
               parms = 4,
               cp = 0.0093)

plotcp(RPART)
printcp(RPART)   # Pruning Table
RPART.1          # Tree Leaf Summary
plot(RPART,
     extra = 4,
     uniform = TRUE,
     fallen.leaves = FALSE)
text(RPART)
fancyRpartPlot(RPART)

# predicting and computing Accuracy
pred = predict(RPART, valid)
pred = round(pred, 0)
ConfMat <- table(valid$Churn, pred)
Accuracy <- sum(diag(ConfMat)) / sum(ConfMat)
Accuracy   # 0.7819905

# Neural networks
library(RcmdrPlugin.BCA)

# -------- Neural Network --------
NNET.2 <-
  Nnet(Churn ~ .,
       data = train,
       decay = 0.00001, # decay is a regularization to avoid over-fitting
       size = 9)        # size - number of hidden units in the neural network
NNET.2$value  # Final Objective Function Value
summary(NNET.2)
prediction <- predict(NNET.2, newdata = valid)
prediction <- round(prediction, 0)
result <- data.frame(prediction, valid$Churn)
error <- sum(abs(prediction - valid$Churn)) / nrow(valid)
error   # 0.2109005
Acc3 <- 1 - error
Acc3    # 0.7890995

# ---------------------------------------------------------------------
lift.chart(c("GLM", "NNEt", "RPART"),
           train,
           "Y",
           0.01,
           "cumulative",
           "Zbiór estymacyjny")

lift.chart(c("GLM.2", "RPART.3"),
           train,
           "Y",
           0.01,
           "cumulative",
           "Zbiór walidacyjny")

# Variable reduction using WesStep algorithm
WES.STEP <- step(GLM, direction = "both", k = 2)
summary(WES.STEP)
1 - (WES.STEP$deviance / WES.STEP$null.deviance) # McFadden R^2

# Setting ActiveDataSet variable. It's important for functions
# rankScore() and rawProbScore()
ActiveDataSet('churn')

# Adding new variable Score allow ranking creation.
# Functions rankScore and rawProbScore are defined in package RcmdrPlugin.BCA
churn$Score <- rankScore("WES.STEP", churn, "Y")
churn$Pr <- rawProbScore("WES.STEP", churn, "Y")

# data sorting
library(sqldf)
churn <- sqldf('SELECT * FROM churn ORDER BY "Pr" DESC')

