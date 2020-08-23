

library(readxl)
setwd("~/Desktop/SGH/2 semester/Big data/labs/10")

# clear the workspace, plots and console
rm(list = ls())
if(!is.null(dev.list())) dev.off()
cat("\014") 

DATA <- read_excel("data.xls")

# rename columns
names(DATA) <- c("size", "cost", "fited", "nearcity", "class")

# checking the number of each group occurences
length(DATA$class[DATA$class == 2])   # 51
length(DATA$class[DATA$class == 1])   # 49

# dividing data on training and validation datasets
set.seed(0)
rand <- sample(1:nrow(DATA), 0.7 * nrow(DATA))
train <- DATA[rand, ]
valid <- DATA[-rand, ]

# bagging
library(ipred)

mod <- bagging(class ~ ., data = train, nbagg = 1000)   # nbagg - number of iterations
a <- predict(mod, newdata = valid)
a <- round(a, 0)
wynik <- data.frame(a, valid$class)
error <- sum(abs(a - valid$class))
error

# random forest
library(randomForest)

forest <- randomForest(class ~ ., data = train, ntrees = 100)
a <- predict(forest, newdata = valid)
a <- round(a, 0)
result <- data.frame(a, valid$class)
error <- sum(abs(a - valid$class))
error
