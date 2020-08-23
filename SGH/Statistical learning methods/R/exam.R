

library(ROCR)
library(ISLR)
library(rpart)
library(randomForest)

setwd("~/Desktop/SGH/2 semester/Statistical learning methods/R")

# clear the workspace, plots and console
rm(list = ls())
if (!is.null(dev.list()))
  dev.off()
cat("\014")

# Exercise 1
# loading data
abalone <- read.csv2("abalone.csv")

str(abalone)

# 1. checking missing value
any(is.na(abalone)) # there are no NAs

# 2. percentage of observations where class equal to 1
length(abalone$class[abalone$class == 1]) / nrow(abalone) # 0.23%

# 3. plot with distribution of class variable
hist(abalone$class)

# 4. Mean value of variable ShellWeight where class = 1
mean(abalone$ShellWeight[abalone$class == 1])

# 5. Dividing data into training and validation (80 to 20)
rand <- sample(1:nrow(abalone), 0.8 * nrow(abalone))
train <- abalone[rand,]
valid <- abalone[-rand,]

# 6. decision tree with rpart package with cp = 0.0001
rpart <- rpart(class ~ ., train, cp = 0.0001)

# 7. checking the model quality with prediction with threshold at 0.2 and creating
#    confusion matrix
pred <- predict(rpart, newdata = valid)
pred <- ifelse(pred > 0.2, 1, 0)

# confusion matrix
tab <- table(pred, valid$class)
acc <- (tab[1,1] + tab[2,2]) / sum(tab) # Accuracy
tpr <- tab[2, 2] / sum(tab[, 2])        # True Positive rate
tnr <- tab[1, 1] / sum(tab[, 1])        # True Negative

# 8. draw a ROC and Lift curve
p <- prediction(pred, valid$class)
plot(performance(p,"tpr","fpr"), colorize = T)

# Lift curve
plot(performance(p,"lift","rpp"),lwd=2, colorize=T)

# 9. checking AUC and making conclusion
attr(performance(p, "auc"), "y.values") # AUC - area under the curve
# AUC = 0.731371. It is better than random model because random would be 0.5

# 10. Pruning decision tree from task 6 with cp = 0.005 and making conclusion
pruned.tree <- prune(rpart, cp = 0.005)

pred2 <- predict(pruned.tree, newdata = valid)
pred2 <- round(pred2, 0)
result2 <- data.frame(pred2, valid$class)
error2 <- sum(abs(pred2 - valid$class)) / nrow(valid)
error2   # 0.1937799
Acc2 <- 1 - error2
Acc2     # 0.8062201

# Exercise 3
data("Carseats")

data <- Carseats

# 1. plot with distribution of sales
hist(data$Sales)

# 2. dividing data on training and validation datasets
set.seed(0)
rand <- sample(1:nrow(data), 0.7 * nrow(data))
train <- data[rand,]
valid <- data[-rand,]

# 3. linear regression
linear <- lm(Sales ~ Age + Price + Income, data = train)

# 4. again regression but with Age polynomial 6
linear <- lm(Sales ~ poly(Age^6) + Price + Income, data = train)
