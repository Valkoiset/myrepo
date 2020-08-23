




library(readxl)
library(tree)
rm(list = ls())

setwd("~/Desktop/SGH/2 semester/Big data/labs/6")
data <- read_excel("data.xls")
str(data)

# rename columns
names(data) <- c("size", "cost", "fited", "nearcity", "class")

# checking the number of each group occurences
length(data$class[data$class == 2])   # 51
length(data$class[data$class == 1])   # 49

# dividing data on training and validation datasets
set.seed(231)
rand <- sample(1:nrow(data), 0.7 * nrow(data))
train <- data[rand,]
valid <- data[-rand,]

# building tree
tree_data <- tree(class ~ ., data = train)
summary(tree_data)

# Functions plot and text draws graphical representation of the tree
plot(tree_data)
text(tree_data)

tree2_data <-
  prune.tree(tree_data, best = 3) # prune.tree determines a nested sequence of subtrees of the supplied tree by recursively “snipping” off the least important splits.
plot(tree2_data)
text(tree2_data)

# Function predict allow to input new data into tree
pred <- predict(tree_data, newdata = valid)
pred <- round(pred, 0)
result <- data.frame(pred, valid$class)
error <- sum(abs(pred - valid$class))
error

library(rattle) # package for GUI in R
library(rpart)

RPART.1 <-
  rpart(class ~ . , data = DATA, cp = 0.0001) # cp - complexity parameter. larger cp - simplier tree
plotcp(RPART.1)
printcp(RPART.1) # Pruning Table
RPART.1          # Tree Leaf Summary

# draw plot with text
plot(RPART.1)
text(RPART.1)

# To obtain more smart diagram the function fancyRpartPlot from rattle package can # be used.

fancyRpartPlot(RPART.1)

pred2 <- predict(RPART.1, newdata = data)
pred2 <- round(pred2, 0)
result2 <- data.frame(pred2, data$class)
error2 <- sum(abs(pred2 - data$class))



