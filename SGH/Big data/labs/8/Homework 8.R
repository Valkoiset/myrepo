
library(BCA)
library(relimp)
library(car)
library(RcmdrMisc)
library(nnet)
library(rpart)
library(rattle)
library(readxl)
library(tree)
library(dplyr)

# clear the workspace, plots and console
rm(list = ls())
if(!is.null(dev.list())) dev.off()
cat("\014") 

setwd("~/Desktop/SGH/2 semester/Big data/labs/8")

# Loading Wesbrook
Wesbrook <-
  read.dbf("Wesbrook.dbf",
           as.is = FALSE)
variable.summary(Wesbrook)

    # Wesbrook$WESBROOK <- as.character(Wesbrook$WESBROOK)
    # Wesbrook$WESBROOK <- as.factor(as.character(Wesbrook$WESBROOK))
    # typeof(Wesbrook$WESBROOK)
# Wesbrook$WESBROOK <- ifelse(Wesbrook$WESBROOK == 1, "Yes", "No")

# Removing some variables
Wesbrook <- within(Wesbrook, {
  ID <- NULL
  INDUPDT <- NULL
  BIGBLOCK <- NULL # 1 level factor variable
  MARITAL <- NULL
  MAJOR1 <- NULL
})

# dividing Wesbrook on training and validation Wesbrooksets
set.seed(0)
rand <- sample(1:nrow(Wesbrook), 0.7 * nrow(Wesbrook))
train <- Wesbrook[rand, ]
valid <- Wesbrook[-rand, ]

# Excluding all NA from Wesbrook
Wesbrook <- na.exclude(Wesbrook)

# Checking if there are still some NA values
any(is.na(Wesbrook))

# building tree
tree_Wesbrook <- tree(WESBROOK ~ ., data = train)
summary(tree_Wesbrook)

# Generalized linear model
GLM.2 <- glm(WESBROOK ~ ., family = binomial(logit), data = train)
summary(GLM.2)

# R2 McFadden value
1 - (GLM.2$deviance/GLM.2$null.deviance) # McFadden R2 = 0.7777173

# Building non linear model
# Creating Log columns
train$LogTOTLGIVE <- with(train, log(TOTLGIVE))

# Building nnlinear model
LogWesbrook <- glm(WESBROOK ~ LogTOTLGIVE + PARENT + CHILD + OTHERACT,
               family = binomial(logit), data = train)
summary(LogWesbrook)
1 - (LogWesbrook$deviance/LogWesbrook$null.deviance) # McFadden R2 = 0.7428967

# classification trees
Wesbrook.rpart <- rpart(WESBROOK ~ .,
                   data=train, cp=0.0065)

plot(Wesbrook.rpart)
text(Wesbrook.rpart)
print(Wesbrook.rpart)
printcp(Wesbrook.rpart)
plotcp(Wesbrook.rpart)
fancyRpartPlot(Wesbrook.rpart)

RPART.1 <- rpart(WESBROOK ~ .,
                 data=train, cp=0.0084)

plotcp(RPART.1)
printcp(RPART.1) # Pruning Table
RPART.1 # Tree Leaf Summary
plot(RPART.1, extra = 4, uniform = TRUE, fallen.leaves = FALSE)
text(RPART.1)

fancyRpartPlot(RPART.1)

RPART.2 <- rpart(WESBROOK ~ ., data=train, cp=0.001)

plotcp(RPART.2)
printcp(RPART.2) # Pruning Table
RPART.1          # Tree Leaf Summary
plot(RPART.2, extra = 4, uniform = TRUE, fallen.leaves = FALSE)
text(RPART.2)

RPART.3 <- rpart(WESBROOK ~ ., data=train, cp=0.0063)
plotcp(RPART.3)
printcp(RPART.3) # Pruning Table
RPART.1          # Tree Leaf Summary
plot(RPART.3, extra = 4, uniform = TRUE, fallen.leaves = FALSE)
text(RPART.3)
print(RPART.3)

fancyRpartPlot(RPART.3)
# ---------------------------------------------------------------------
    typeof(Wesbrook$WESBROOK)                  # ???? 
    class(Wesbrook$WESBROOK)
    
lift.chart(c("GLM.2","RPART.3" ), train, "Y", 0.01, 
           "cumulative", "Zbiór estymacyjny")

lift.chart(c("GLM.2","RPART.3"), train, "Y", 0.01, 
           "cumulative", "Zbiór walidacyjny")

# Neural networks

library(RcmdrPlugin.BCA)

NNET.2 <- Nnet(MonthGive ~ AdultAge + AveDonAmt + AveIncEA + DonPerYear + 
                 LastDonAmt + NewDonor + NRegion + YearsGive + SomeUnivP, Wesbrook=Wesbrook, decay=0.10, 
               size=4, subset='Sample=="Estimation"')
NNET.2$value # Final Objective Function Value
summary(NNET.2)

# Lift Charts
# Estimation subset

lift.chart(c("GLM.2","MixedWesbrook","RPART.3","NNET.2" ), Wesbrook[Wesbrook$Sample=="Estimation",], "Yes", 0.01, 
           "cumulative", "Zbiór estymacyjny")

# Validation subset

lift.chart(c("GLM.2","MixedWesbrook","RPART.3","NNET.2"), Wesbrook[Wesbrook$Sample=="Validation",], "Yes", 0.01, 
           "cumulative", "Zbiór walidacyjny")

# Building new network with 2 neurons in hidden layer

NNET.3 <- Nnet(MonthGive ~ AdultAge + AveDonAmt + AveIncEA + DonPerYear + 
                 LastDonAmt + NewDonor + NRegion + YearsGive + SomeUnivP, Wesbrook=Wesbrook, decay=0.10, 
               size=2, subset='Sample=="Estimation"')

# Lift charts - estimation subset

lift.chart(c("GLM.2","MixedWesbrook","RPART.3","NNET.2","NNET.3" ), Wesbrook[Wesbrook$Sample=="Estimation",], "Yes", 0.01, 
           "cumulative", "Zbiór estymacyjny")

# Lift charts - validation subset

lift.chart(c("GLM.2","MixedWesbrook","RPART.3","NNET.2","NNET.3"), Wesbrook[Wesbrook$Sample=="Validation",], "Yes", 0.01, 
           "cumulative", "Zbiór walidacyjny")

# Building neural network with 6 neurons in hidden layer

NNET.4 <- Nnet(MonthGive ~ AdultAge + AveDonAmt + AveIncEA + DonPerYear + 
                 LastDonAmt + NewDonor + NRegion + YearsGive + SomeUnivP, Wesbrook=Wesbrook, decay=0.10, 
               size=6, subset='Sample=="Estimation"')

# Lift charts - estimation subset

lift.chart(c("GLM.2","MixedWesbrook","RPART.3","NNET.2","NNET.3","NNET.4" ), Wesbrook[Wesbrook$Sample=="Estimation",], "Yes", 0.01, 
           "cumulative", "Zbiór estymacyjny")

# Lift charts - validation subset

lift.chart(c("GLM.2","MixedWesbrook","RPART.3","NNET.2","NNET.3","NNET.4"), Wesbrook[Wesbrook$Sample=="Validation",], "Yes", 0.01, 
           "cumulative", "Zbiór walidacyjny")

lift.chart(c("GLM.2","MixedWesbrook","RPART.3","NNET.4"), Wesbrook[Wesbrook$Sample=="Validation",], "Yes", 0.01, 
           "cumulative", "Zbiór walidacyjny")

wynik<-predict(NNET.4,Wesbrook=Wesbrook, subset='Sample=="Validation"')
wynik<-round(wynik,0)










