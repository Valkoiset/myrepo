

library(rchess)
library(bigchess)
library(dplyr)
library(ggplot2)
library(readr)
library(plyr)
library(dplyr)
library(nnet)
library(MASS)
library(rpart)
library(caret)
library(randomForest)
library(reshape2)
library(rpart.plot)
library(rattle)
library(gbm)

# clear the workspace, plots and console
rm(list = ls())
if (!is.null(dev.list()))
  dev.off()
cat("\014")

setwd("~/Desktop/SGH/2 semester/Big data/Project/chess")

# load the data after check point
chess = read.csv("chess.csv")
head(chess)

# --------------------- Data Exploration ---------------------
library(ggplot2)
ggplot(data = chess, aes(x = adjusted_elo_difference, y = winner)) + geom_point()

# white wins percentage
length(which(chess$winner == "white")) / length(chess$winner) # 0.3061709

# draw percentage
length(which(chess$winner == "draw")) / length(chess$winner)  # 0.4992089

# black wins percentage
length(which(chess$winner == "black")) / length(chess$winner) # 0.1946203

# Now check out the distribution of adjusted_elo_differences and make sure
# it isn’t skewed so that white tends to be better. Looks normally distributed
# around 0.
hist(chess$elo_difference)

# does it really make sense???))
gg <- ggplot(chess)
gg + geom_histogram(data = chess, aes(elo_difference, fill = winner))

# ------------------------------------------------------------
# ------------------------ Modelling -------------------------
# ------------------------------------------------------------
# Since we have three levels in our outcome, we can’t use logistic regression,
# and instead have to use multinomial regression

# dividing data on training and validation datasets
set.seed(713)
rand <- sample(1:nrow(chess), 0.7 * nrow(chess))
train <- chess[rand, ]
valid <- chess[-rand, ]

# ------------ GBM ------------       it works!!!
# 5 folds cross validiation
fitControl <-
  trainControl(method = "repeatedcv",
               number = 5,
               repeats = 1)

# generate GBM model
fit <-
  train(
    winner ~ adjusted_elo_difference + eco_cat + adjusted_white_elo +
      adjusted_black_elo,
    data = train,
    method = "gbm",
    trControl = fitControl,
    verbose = FALSE
  )

# accuracy for training data
confusionMatrix(predict(fit, newdata = train), train$winner) # 55.4%

# use model to predict for test data
predict <- predict(fit, newdata = valid)

# find accuracy of test data
confusionMatrix(predict, valid$winner) # 55.3%
# Conclusion: 55.3% accuracy on validation data - not the best result,
# let's look at the next model
# -------------------------------------------------------
# valid$winner = ifelse(valid$winner == "black", 0,
#        ifelse(valid$winner == "white", 1, 0.5))

# ----------------- Neural Network ----------------- ???????????
# constructing matrices and vectors for model
    # input data as matrix with 4 columns
WE = as.matrix(train[, c("adjusted_elo_difference",
                         "adjusted_white_elo", "adjusted_black_elo")])
WY = as.vector(train[, train$winner])          # output vector

VAL_WE = as.matrix(valid[, c("adjusted_elo_difference",
                             "adjusted_white_elo", "adjusted_black_elo")])
VAL_WY = as.vector(valid[, valid$winner])

library(AMORE) # "A MORE flexible neural network package"
net <-
  newff(
    n.neurons = c(4, 10, 10, 1),
    learning.rate.global = 1e-2,
    momentum.global = 0.5,
    error.criterium = "TAO",
    Stao = NA,
    hidden.layer = "tansig",
    output.layer = "purelin",
    method = "ADAPTgdwm"           # this is backpropagation method
  )

# train function activate NN learning
result <-
  train(
    net,
    WE,
    WY,
    VAL_WE,
    VAL_WY,
    error.criterium = "LMS",
    report = T,               # Shows steps in console
    show.step = 100,          # Number of epochs to train non-stop until the training function is allow to report.
    n.shows = 4              # Number of times to report (if report is TRUE). 
    # The total number of training epochs is n.shows times show.step.
  )

# sim function generate ouput from NN
WYSN <- sim(result$net, VAL_WE)

# data frame result compare output from NN with original results
WYSN <- round(WYSN, 0)
result1 <- data.frame(VAL_WY, WYSN)
error <- sum(abs(WYSN - VAL_WY))          # b calculates number of errors
error

# plotting error function
matplot(
  result$Merror,
  pch = 21:23,
  bg = c("white",  "black"),
  type = "o",
  col = "black",
  xlim = c(1, 30),
  ylim = c(0, 0.2)
)

# ------------- Random Forest ------------- ????????????????
# random forest
library(randomForest)

forest <- randomForest(winner ~ adjusted_elo_difference + eco_cat +
                         adjusted_white_elo + adjusted_black_elo,
                       data = train, ntrees = 100)

a <- predict(forest, newdata = valid)
a <- as.data.frame(a)
a <- ifelse(a == "black", 0,
       ifelse(a == "white", 1, 0.5))
a <- as.data.frame(a)

result <- data.frame(a, valid$winner)
error <- sum(abs(a - valid$winner))
error

# ------------- Bagging ------------- ????????????
library(ipred)
                                      # nbagg - number of iterations
mod <- bagging(class ~ ., data = train, nbagg = 1000)   
a <- predict(mod, newdata = valid)
a <- round(a, 0)
wynik <- data.frame(a, valid$class)
error <- sum(abs(a - valid$class))
error

# ------------- Tree ------------- ????????
# dividing data on training and validation datasets
set.seed(713)
rand <- sample(1:nrow(chess), 0.7 * nrow(chess))
train <- chess[rand, ]
valid <- chess[-rand, ]

  
          # preparation  
            train$winner = ifelse(train$winner == "black", 0,
                      ifelse(train$winner == "white", 1, 0.5))

#We include adjusted_white_elo and adjusted_black_elo because we want it to be greedy, and because there's a small chance that they may influence the game outcome despite being captured in adjusted_elo_difference
#generate  model
fit <- rpart(winner~adjusted_elo_difference + eco_cat + adjusted_white_elo + adjusted_black_elo, method="class", data=train)

#generate predictions
predict_fit = predict(fit, train)
predicted_winner = data.frame(winner = predict_fit[,1])

#find column names for which probabilties is greatest
predicted_winner[,1] <- colnames(predict_fit)[apply(predict_fit,1,which.max)]
        
      # check and transform
      typeof(train$winner)
      typeof(predicted_winner)
      # predicted_winner = as.character(predicted_winner)
      # train$winner = as.character(train$winner)
      predicted_winner = as.data.frame(predicted_winner)
        pred = c()
        pred = predicted_winner
        typeof(pred)
      train$winner = as.list(train$winner)
      
        
#accuracy
confusionMatrix(predicted_winner[,1], train$winner, positive = "white")
      