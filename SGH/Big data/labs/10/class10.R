


# bagging example
library(ipred)

SN <- read.csv("http://jolej.linuxpl.info/SN.csv", sep = ";")

DATA <- SN

names(DATA) <- c("size", "cost", "fited", "class")

mod <- bagging(class ~ ., data = DATA, nbagg = 1000)   # nbagg - number of iterations
a <- predict(mod, newdata = DATA)
a <- round(a, 0)
wynik <- data.frame(a, DATA$class)
b <- sum(abs(a - DATA$class))
b

# random forest example
library(randomForest)

SN <- read.csv("http://jolej.linuxpl.info/SN.csv", sep = ";")

DATA <- SN

names(DATA) <- c("size", "cost", "fited", "class")

# ntrees number of trees.

mod <- randomForest(class ~ ., data = DATA, ntrees = 100)
a <- predict(mod, newdata = DATA)
a <- round(a, 0)
result <- data.frame(a, DATA$class)

b <- sum(abs(a - DATA$class))
b

