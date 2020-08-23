

# Statistical learning methods

# 9: What will happen and why if you run the following code in R programming 
#    language?:   “as.integer(2^50)” 
x = "as.integer(2^50)"
typeof(x)
print(x)

# in case it was meant in the task to write without quotes
y = as.integer(2^50)
typeof(y)
print(y)

a = 6
typeof(a)

b = "6"
typeof(b)

# 10: Explain why the following expression equals TRUE in R and why?
0.1+0.2 != 0.3 && 2^60+1 == 2^60
# it is true because comparison is preformed on a binary level


# 11: How will be the optimal model complexity changed in response of increasing 
#     the amount of training data twice?

# 13: What will happen to ROC curve, if all observations with value 0 will be 
#     duplicated, but all observations with 1 will stay the same. Why?

library(ROCR)
library(dplyr)

#reading data
setwd("~/Desktop/SGH/2 semester/Statistical learning methods/R")
mydata <- read.csv2("ticdata2000.csv")
summary(mydata)

set.seed(0) # a good practice - to set seed before sampling
rand <- sample(1:nrow(mydata), .7 * nrow(mydata))
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

# My model
tab <- table(klas, valid$CARAVAN) # Confusion Matrix
acc <- (tab[1,1] + tab[2,2]) / sum(tab) # Accuracy

p <- prediction(pred, valid$CARAVAN)

# ROC - X axis: FPR, Y axis: TPR
plot(performance(p,"tpr","fpr"), colorize = T)
attr(performance(p, "auc"), "y.values") # AUC - area under the curve


# doubling data of group 1 twice
length(train$CARAVAN[train$CARAVAN == 0])
length(train$CARAVAN[train$CARAVAN == 1])

train.0 <- train %>% filter(train$CARAVAN == 0)
train.1 <- train %>% filter(train$CARAVAN == 1)

train.1 <- rbind(train.1, train.1)
train2 <- rbind(train.0, train.1)

model2 <- glm(CARAVAN ~ . , family = "binomial", # building logistic model
             data = train2)
summary(model2)

pred2 <- predict(model2, newdata = valid, type = "response") # type response needed to show result in probabilities
head(pred)

klas2 <- ifelse(pred2 >= mean(mydata$CARAVAN), 1, 0) # if pred >= .5 we have 1, otherwise - 0
table(klas)

# My model
tab2 <- table(klas2, valid$CARAVAN) # Confusion Matrix
acc2 <- (tab2[1,1] + tab2[2,2]) / sum(tab2) # Accuracy

p2 <- prediction(pred2, valid$CARAVAN)

# ROC - X axis: FPR, Y axis: TPR
plot(performance(p2,"tpr","fpr"), colorize = T)
attr(performance(p2, "auc"), "y.values") # AUC - area under the curve

# Gain curve - true positive rate in relation to rate of positive predictions
# How many clients can I reach? 
plot(performance(p2,"tpr","rpp"), lwd = 2)

# Lift curve - how much can I gain thanks to model? 
# lift = TPR/RPP (Rate of positive predictions)
plot(performance(p2,"lift","rpp"),lwd=2, colorize=T)

length(train2$CARAVAN[train2$CARAVAN == 0])
length(train2$CARAVAN[train2$CARAVAN == 1])

proportion_1 <- length(train2$CARAVAN[train2$CARAVAN == 1]) / nrow(train2)
proportion_1

library(caret)
confusionMatrix(data = factor(klas2), reference = factor(valid$CARAVAN), mode = "everything")
