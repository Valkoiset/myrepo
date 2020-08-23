# Statistical learning methods
# Lab 2 - Methods of evaluation of classifiers
# materials: www.e-sgh.waw.pl/bk48144/SLM
# mail: bk48144@sgh.waw.pl, konbeata@gmail.com


#Ex 1
# Data:
# http://kdd.ics.uci.edu/databases/tic/dictionary.txt
# http://kdd.ics.uci.edu/databases/tic/ticdata2000.txt

rm(list=ls())
library(ROCR)

#reading data
setwd("~/Desktop/SGH/2 semester/Statistical learning methods/R")
mydata <- read.csv2("ticdata2000.csv")
summary(mydata)
plot(mydata$CARAVAN)
hist(mydata$CARAVAN)
barplot(table(mydata$CARAVAN))
table(mydata$CARAVAN)
unique(mydata$CARAVAN)
sum(is.na(mydata$CARAVAN))
sum(is.na(mydata))

library(ggplot2)
gg <- ggplot()
gg <- gg + geom_bar(data = mydata, aes(x = factor(CARAVAN)))
gg

#What do I know about my data set? 

set.seed(0) # a good practice - to set seed before sampling

rand <- sample(1:nrow(mydata), .8 * nrow(mydata))
head(rand)

train <- mydata[rand,]
valid <- mydata[-rand,]

model <- glm(CARAVAN ~ . , family = "binomial", # building logistic model
             data = train)
summary(model)

pred <- predict(model, newdata = valid, type = "response") # type response needed to show result in probabilities
head(pred)

klas <- ifelse(pred >= mean(mydata$CARAVAN), 1, 0) # if pred >= .5 we have 1, otherwise - 0
table(klas)


#To evaluate my classifier I need to have validation and training set 

SplitDataSet <- function(data.set, training.fraction){
  random.numbers <- sample.int(nrow(data.set))
  quantiles <- quantile(random.numbers, probs = c(0, training.fraction, 1))
  split.labels <- cut(random.numbers, quantiles, include.lowest = T,
                      labels = c("training", "validation"))
  return(split(data.set, split.labels))
}

splitted.data.set <- SplitDataSet(mydata, 0.7)
training.set <- splitted.data.set$training
validation.set <- splitted.data.set$validation

# My model
tab <- table(klas, valid$CARAVAN) # Confusion Matrix
acc <- (tab[1,1] + tab[2,2]) / sum(tab) # Accuracy
tpr <- tab[2, 2] / sum(tab[, 2]) # True Positive rate
tnr <- tab[1, 1] / sum(tab[, 1]) # True Negative


# Model evaluation
# sensitivity
# TPR = TP/P

# specificity
# TNR = TN/N = TN/(FP+TN)

# 1 - specificity
# FPR = FP/N = 1 - TNR

# FP - type I error
# FN - type II error

p <- prediction(pred, valid$CARAVAN)

# ROC - X axis: FPR, Y axis: TPR
plot(performance(p,"tpr","fpr"), colorize = T)
attr(performance(p, "auc"), "y.values") # AUC - area under the curve


# Gain curve - true positive rate in relation to rate of positive predictions
# How many clients can I reach? 
plot(performance(p,"tpr","rpp"), lwd = 2)

# Lift curve - how much can I gain thanks to model? 
# lift = TPR/RPP
plot(performance(p,"lift","rpp"),lwd=2, colorize=T)

length(train$CARAVAN[train$CARAVAN == 0])
length(train$CARAVAN[train$CARAVAN == 1])

proportion_1 <- length(train$CARAVAN[train$CARAVAN == 1]) / nrow(train)

# Ex 2
DATA_SET <- read.fwf("http://archive.ics.uci.edu/ml/machine-learning-databases/statlog/german/german.data-numeric",widths = rep(4, 25), header = FALSE)
names(DATA_SET)[25] <- "target"
DATA_SET$target <- 2 - DATA_SET$target


CUT_OFFS <- seq(0.5, 1, by = 0.01) 
BAD_CREDIT_COST <- 5
LOST_CLIENT_COST <- 1
COST_MATRIX <- matrix(c(0, BAD_CREDIT_COST, LOST_CLIENT_COST, 0), 2)

