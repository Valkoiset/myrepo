

setwd("~/Desktop/SGH/2 semester/Statistical learning methods/R")
rm(list=ls())

pwc <- read.csv("sample_data.csv")

pwc$DefFlag
unique(pwc$DefFlag)

# split dataset
test <- pwc[is.na(pwc$DefFlag), ]
mydata <- pwc[!is.na(pwc$DefFlag), ]

set.seed(0)
rand <- sample(1:nrow(mydata), 0.8 * nrow(mydata))
train <- mydata[rand, ]
valid <- mydata[-rand, ]

# model 1
mod <- glm(DefFlag ~ Age + Monthly_Income + Monthly_Spendings +
             Job_type, data = train, family = "binomial")
pred <- predict(mod, newdata = valid, type = "response")

# model 2
mod2 <- glm(DefFlag ~ Age, data = train, family = "binomial")
pred2 <- predict(mod2, newdata = valid, type = "response")

# Gini test

Gini_value(pred, valid$DefFlag)
Gini_value(pred2, valid$DefFlag)

# prepare model for the whole dataset
mod <- glm(DefFlag ~ Age + Monthly_Income + Monthly_Spendings +
             Job_type, data = train, family = "binomial")
mypredict <- predict(mod, newdata = test, type = "response")

# prepare data with final results
Prediction <- data.frame(Application_ID = test$Application_ID,
                         Score = mypredict)
Data <- data.frame(Application_ID = mydata$Application_ID, Score = mydata$DefFlag)

final <- rbind(Data, Prediction)

# check if scores are correct
sum(is.na(final$Score))

# save file
write.csv(final, "Output.csv", row.names = F)
