

library(xgboost)
library(readr)
library(stringr)
library(caret)
library(car)

rm(list=ls())
setwd("~/Desktop/SGH/2 semester/Statistical learning methods/R/PwC project")
PwC <- read.csv("PwC_Case_Study_phase_1.csv")
PwCm <- PwC
PwCm$Application_ID <- NULL
# ls(PwCm)

test_na <- PwCm[is.na(PwCm$DefFlag), ]
mydata <- PwCm[!is.na(PwCm$DefFlag), ]

set.seed(323)
rand <- sample(1:nrow(mydata), 0.7 * nrow(mydata))
df_train <- mydata[rand, ]
df_test <- mydata[-rand, ]

# Loading labels of train data
labels = df_train['DefFlag']
df_train = df_train[-grep('labels', colnames(df_train))]

# combine train and test data
df_all = rbind(df_train,df_test)

# one-hot-encoding categorical features
ohe_feats = c('Job_type', 'Marital_status', 'Home_status', 'Car_status', 'Household_children', 'Credit_purpose')
dummies <- dummyVars(~ Job_type +  Marital_status + Home_status + Car_status + Household_children + Credit_purpose, data = df_all)
df_all_ohe <- as.data.frame(predict(dummies, newdata = df_all))
df_all_combined <- cbind(df_all[,-c(which(colnames(df_all) %in% ohe_feats))],df_all_ohe)


