# Statistical learning methods
# Lab 3 - Nonparametric regression models: smoothing spline, LOESS, GAM
# materials: www.e-sgh.waw.pl/bk48144/SLM
# mail: bk48144@sgh.waw.pl, konbeata@gmail.com
rm(list=ls())

###
library(ISLR)
data("Wage")
head(Wage)
summary(Wage)
str(Wage)

#Plot distribution of wage variable
hist(Wage$wage)
library(ggplot2)

gg <- ggplot()
gg <- gg + geom_histogram(data = Wage, aes(wage, fill = age, group = age))
gg

hist(Wage$age)
# 0-20, 21-40, 41-60, 61-max()

# 1
Wage$age_group <- "0"
Wage$age_group[Wage$age >= 0 & Wage$age <= 20] <- "0-20"
Wage$age_group[Wage$age >= 21 & Wage$age <= 40] <- "21-40"
Wage$age_group[Wage$age >= 41 & Wage$age <= 60] <- "40-60"
Wage$age_group[Wage$age >= 61 & Wage$age <= max(Wage$age)] <- "61-max"

table(Wage$age_group)

# 2
Wage$age_group <- ifelse(Wage$age >0 & Wage$age <= 20, "0-20", 
                         ifelse(Wage$age >= 21 & Wage$age <= 40, "21-40", "41-max"))

# 3
Wage$age_group <- cut(Wage$age, breaks = c(0, 20, 40, 60, max(Wage$age)))
class(Wage$age_group)
levels(Wage$age_group)

#Check with OLS if age inlfuences wage
model <- lm(wage ~ age, data = Wage)
summary(model)

plot(Wage$age, Wage$wage)
abline(model, col = "red")

model2 <- lm(wage ~ age + I(age^2) + I(age^3), data = Wage)
summary(model2)

#orthogonal polynomials - each column is a linear orthogonal combination of the variables age, age^2, age^3 and age^4.
fit <- lm(wage ~ poly(age,4), data = Wage)
summary(fit)

fit2 <- lm(wage ~ poly(age, 3, raw = T), data = Wage)
summary(fit2)

#lets plot that
age.grid <- seq(from = min(Wage$age), to = max(Wage$age))
preds <- predict (fit ,newdata = list(age = age.grid), se = TRUE)
se.bands <- cbind(preds$fit +2*preds$se.fit , preds$fit -2* preds$se.fit)

par(mfrow = c(1,2) , mar = c(4.5 ,4.5 ,1 ,1) )
plot(Wage$age ,Wage$wage ,xlim = c(min(Wage$age), max(Wage$age)) ,cex  = .5, col = " darkgrey ")
title ("Degree - 4 Polynomial ", outer = T)
lines(age.grid, preds$fit ,lwd = 2, col = "blue")
matlines(age.grid, se.bands ,lwd = 1, col = "blue",lty = 3)

##Which degree of polynomial should I use?
fit1 <- lm(wage ~ age, data = Wage)
fit2 <- lm(wage ~ poly(age^2), data = Wage)
fit3 <- lm(wage ~ poly(age^3), data = Wage)
fit4 <- lm(wage ~ poly(age^4), data = Wage)
fit5 <- lm(wage ~ poly(age^5), data = Wage)

anova(fit1, fit2, fit3, fit4, fit5)

#LOESS
# Data
# http://archive.ics.uci.edu/ml/
# machine-learning-databases/housing/housing.data
set.seed(1)

GetSplitLabels <- function(data.length, proportions) {
  proportioned.labels <- rep(1:length(proportions), proportions)
  labels <- rep(proportioned.labels,len = data.length)
  return(sample(labels, data.length))
}

CV_FOLDS <- 10
SPAN_LEVELS <- seq(from = 0.01, to = 1, length.out = 30)

#read housingDATA.csv (separaptor: comma, decimal point: "." )
setwd("~/Desktop/SGH/2 semester/Statistical learning methods/R")
mydata <-  read.csv("housingDATA.csv")

#crete column with fold number
num <- rep(1:10, times = nrow(mydata))
num <- num[1:nrow(mydata)]
set.seed(0)
num <- sample(num ,size = length(num))

mydata$fold <- num

#create training and validation part

k <- 1
sse <- rep(0, times = length(SPAN_LEVELS))

for (k in 1:CV_FOLDS) {
  
training <- mydata[mydata$fold != k, ]
valid <- mydata[mydata$fold == k, ]

  for (s in 1: length(SPAN_LEVELS)) {
  
    model <- loess(MEDV ~ LSTAT, span = SPAN_LEVELS[s], data = training,
                   control = loess.control(surface = "direct"))
    prediction <- predict(model, newdata = valid)
    sse[s] <-  sse[s] + sum((prediction - valid$MEDV) ^ 2)
  
  }
}

plot(sse)
min(sse)
optimal.span <- SPAN_LEVELS[which.min(sse)]
model <- loess(MEDV ~ LSTAT, span = optimal.span, data = mydata)


#GAM model

library(mgcv)
library(ROCR)
library(Ecdat)

set.seed(1)

data(Participation)
LABELS <- factor(rep(c("train", "test"), length = nrow(Participation)))
set.seed(1)
random.labels <- sample(LABELS)
split.data <- split(Participation, random.labels)
train <- split.data$train
valid <- split.data$test


gam.model <- gam(lfp ~ s(lnnlinc) + s(age),
                 family = binomial, data = split.data$train)
glm.prediction <- predict(glm.model, newdata = split.data$test)
gam.prediction <- as.vector(predict(gam.model, newdata = split.data$test))

