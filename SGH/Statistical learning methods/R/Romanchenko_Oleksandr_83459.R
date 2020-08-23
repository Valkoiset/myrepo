

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
# Conclusion: according to the final results we've got on silverdecisions it is 
#             adviced to invest

# Exercise 2
# loading data
abalone <- read.csv2("abalone.csv")
str(abalone)

# 1. checking missing value
any(is.na(abalone)) # there are no NAs

# 2. percentage of observations where class equal to 1
length(abalone$class[abalone$class == 1]) / nrow(abalone) # 0.23%

# 3. plot with distribution of class variable
gg <- ggplot(data = abalone)
gg + geom_bar(aes(x = class, fill = factor(class)))

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

Acc2 > acc # 0.8062201 > 0.8062201 = TRUE!. Yes, pruned tree provides better accuracy

# Exercise 3
data("Carseats")
data <- Carseats

# 1. plot with distribution of sales
gg <- ggplot(data = data)
gg + geom_histogram(aes(x = Sales))

# 2. dividing data on training and validation datasets
set.seed(0)
rand <- sample(1:nrow(data), 0.7 * nrow(data))
train <- data[rand,]
valid <- data[-rand,]

# 3. linear regression
linear <- lm(Sales ~ Age + Price + Income, data = train)

# 4. again regression but with Age polynomial 6
linear2 <- lm(Sales ~ poly(Age^6) + Price + Income, data = train)

# 5. random forest with 10 trees
forest <- randomForest(Sales ~ Age + Price + Income, data = train, ntree = 10,
                       do.trace = T)

# 6. comparing quality of models
confusion.matrix<-list()
cat("Confusion Matrix - linear")
print(confusion.matrix[[1]]<-table(predict(linear,new=valid),valid$Sales))
linear_table <- table(predict(linear,new=valid),valid$Sales)
cat("\nConfusion Matrix - linear2")
print(confusion.matrix[[2]]<-table(predict(linear2,newdata=valid),valid$Sales))
linear2_table <- table(predict(linear2, newdata=valid),valid$Sales)
cat("\nConfusion Matrix - random forest")
print(confusion.matrix[[3]]<-table(predict(forest,newdata=valid),valid$Sales))
rf_table <- table(predict(forest,newdata= valid),valid$Sales)
cat("\nAccuracy comparison\n")

CalculateAccuracy<-function(confusion.matrix) {return(sum(diag(confusion.matrix))/sum(confusion.matrix))}
print(data.frame(model=c("ctree","pruned rpart","random forest"),accuracy=sapply(confusion.matrix,CalculateAccuracy)),row.names=FALSE)

EvaluateModel <- function(classif_mx){
  true_positive <- classif_mx[1,1]
  true_negative <- classif_mx[2,2]
  condition_positive <- sum(classif_mx[ ,1])
  condition_negative <- sum(classif_mx[ ,2])
  accuracy <- (true_positive + true_negative) / sum(classif_mx)
  sensitivity <- true_positive / condition_positive
  specificity <- true_negative / condition_negative
  misclassification <- 1 - accuracy
  return(list(accuracy = accuracy,
              sensitivity = sensitivity,
              specificity = specificity,
              misclassification = misclassification))
}

EvaluateModel(linear_table)
EvaluateModel(linear2_table)
EvaluateModel(rf_table)


linear_pred <-as.vector(predict(linear,newdata=valid))
linear2_pred <-as.vector(predict(linear2,newdata=valid))
rf_predict <-as.vector(predict(forest,newdata=valid))

# calculating mse
mse_linear_pred <- mean((train$Sales - linear_pred)^2)
mse_linear2_pred <- mean((train$Sales - linear2_pred)^2)
mse_forest_pred <- mean((train$Sales - rf_predict)^2)
