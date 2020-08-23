

library(BCA)
library(relimp)
library(car)
library(RcmdrMisc)
library(nnet)


# Loading CCS dataset from BCA package

data(CCS, package="BCA")

# Creating validation and estimation subsets

CCS$Sample <- create.samples(CCS, est = 0.7, val = 0.3)

# showData(CCS)

# Creating numerical variable from factor variable MonthsGive

CCS <- within(CCS, {
  MonthGive.Num <- Recode(MonthGive, '"Yes"=1; "No"=0')
})

CCS <- within(CCS, {
  MonthGive.NF <- Recode(MonthGive, '"Yes"=1; "No"=0')
})

# Reorganizing levels of Region factor variable

CCS$NRegion <- relabel.factor(CCS$Region, new.labels=c('NR1','NR1','NR1',
                                                       'NR2','NR2','NR2'))


# Generalized linear model

GLM.2 <- glm(MonthGive ~ Age20t29 +Age20t39 + Age60pls + Age70pls + Age80pls + 
               AveDonAmt + AveIncEA + DonPerYear + EngPrmLang + FinUnivP + LastDonAmt + 
               NewDonor+NRegion, family=binomial(logit), data=CCS)
summary(GLM.2)

# R2 McFadden value
1 - (GLM.2$deviance/GLM.2$null.deviance) # McFadden R2

# Building non linear model

numSummary(CCS[,c("DonPerYear", "YearsGive","AveDonAmt","LastDonAmt" )])

# Logarithm of numerical variables: AveDonAmt, LastDonAmt, DonPerYear, YearsGive

# In case of variables DonPerYear i YearsGive we are using log(X+1)
CCS$LogDonPerYear <- with(CCS, log(DonPerYear+1))
CCS$LogYearsGive <- with(CCS, log(YearsGive+1))
CCS$LogAveDonAmt <- with(CCS, log(AveDonAmt))
CCS$LogLastDonAmt <- with(CCS, log(LastDonAmt))

# Building nnlinear model


LogCCS <- glm(MonthGive ~ LogAveDonAmt + LogDonPerYear + LogLastDonAmt + 
                LogYearsGive + Age20t29 + Age20t39 + Age60pls + Age70pls + 
                Age80pls + EngPrmLang + AveIncEA + FinUnivP+NRegion, family=binomial(logit), 
              data=CCS, subset=Sample=="Estimation")
summary(LogCCS)
1 - (LogCCS$deviance/LogCCS$null.deviance) # McFadden R2

# Checking p-values for factor variables

Anova(LogCCS)

#  Building mixed model


MixedCCS <- glm(MonthGive ~ AveIncEA + DonPerYear + LogAveDonAmt + 
                  LogLastDonAmt + NRegion, family=binomial(logit), data=CCS, 
                subset=Sample=="Estimation")
summary(MixedCCS)
1 - (MixedCCS$deviance/MixedCCS$null.deviance) # McFadden R2


# Classification trees

library(rpart)
library(rattle)


CCS.rpart <- rpart(MonthGive ~ AveIncEA + DonPerYear + AveDonAmt + LastDonAmt + NRegion,
                   data=CCS, cp=0.0065,subset=Sample=="Estimation")

plot(CCS.rpart)
text(CCS.rpart)
print(CCS.rpart)
printcp(CCS.rpart)
plotcp(CCS.rpart)
fancyRpartPlot(CCS.rpart)



RPART.1 <- rpart(MonthGive ~ NewDonor + NRegion + SomeUnivP + YearsGive + 
                   AdultAge + Age20t29 + Age20t39 + Age60pls + Age70pls + Age80pls + AveDonAmt + 
                   AveIncEA + DonPerYear+LastDonAmt, data=CCS, cp=0.0084, subset=Sample=="Estimation")

plotcp(RPART.1)
printcp(RPART.1) # Pruning Table
RPART.1 # Tree Leaf Summary
plot(RPART.1, extra = 4, uniform = TRUE, fallen.leaves = FALSE)
text(RPART.1)

fancyRpartPlot(RPART.1)

RPART.2 <- rpart(MonthGive ~ NewDonor + NRegion + SomeUnivP + YearsGive + 
                   AdultAge + Age20t29 + Age20t39 + Age60pls + Age70pls + Age80pls + 
                   AveIncEA + DonPerYear+LastDonAmt, data=CCS, cp=0.001, subset=Sample=="Estimation")

plotcp(RPART.2)
printcp(RPART.2) # Pruning Table
RPART.1 # Tree Leaf Summary
plot(RPART.2, extra = 4, uniform = TRUE, fallen.leaves = FALSE)
text(RPART.2)

RPART.3 <- rpart(MonthGive ~ NewDonor + NRegion + SomeUnivP + YearsGive + 
                   AdultAge + Age20t29 + Age20t39 + Age60pls + Age70pls + Age80pls + 
                   AveIncEA + DonPerYear+LastDonAmt, data=CCS, cp=0.0063, subset=Sample=="Estimation")
plotcp(RPART.3)
printcp(RPART.3) # Pruning Table
RPART.1 # Tree Leaf Summary
plot(RPART.3, extra = 4, uniform = TRUE, fallen.leaves = FALSE)
text(RPART.3)
print(RPART.3)

fancyRpartPlot(RPART.3)

lift.chart(c("GLM.2","MixedCCS","RPART.3" ), CCS[CCS$Sample=="Estimation",], "Yes", 0.01, 
           "cumulative", "Zbiór estymacyjny")

lift.chart(c("GLM.2","MixedCCS","RPART.3"), CCS[CCS$Sample=="Validation",], "Yes", 0.01, 
           "cumulative", "Zbiór walidacyjny")

# Neural networks

library(RcmdrPlugin.BCA)

NNET.2 <- Nnet(MonthGive ~ AdultAge + AveDonAmt + AveIncEA + DonPerYear + 
                 LastDonAmt + NewDonor + NRegion + YearsGive + SomeUnivP, data=CCS, decay=0.10, 
               size=4, subset='Sample=="Estimation"')
NNET.2$value # Final Objective Function Value
summary(NNET.2)

# Lift Charts
# Estimation subset

lift.chart(c("GLM.2","MixedCCS","RPART.3","NNET.2" ), CCS[CCS$Sample=="Estimation",], "Yes", 0.01, 
           "cumulative", "Zbiór estymacyjny")

# Validation subset

lift.chart(c("GLM.2","MixedCCS","RPART.3","NNET.2"), CCS[CCS$Sample=="Validation",], "Yes", 0.01, 
           "cumulative", "Zbiór walidacyjny")

# Building new network with 2 neurons in hidden layer

NNET.3 <- Nnet(MonthGive ~ AdultAge + AveDonAmt + AveIncEA + DonPerYear + 
                 LastDonAmt + NewDonor + NRegion + YearsGive + SomeUnivP, data=CCS, decay=0.10, 
               size=2, subset='Sample=="Estimation"')

# Lift charts - estimation subset

lift.chart(c("GLM.2","MixedCCS","RPART.3","NNET.2","NNET.3" ), CCS[CCS$Sample=="Estimation",], "Yes", 0.01, 
           "cumulative", "Zbiór estymacyjny")

# Lift charts - validation subset

lift.chart(c("GLM.2","MixedCCS","RPART.3","NNET.2","NNET.3"), CCS[CCS$Sample=="Validation",], "Yes", 0.01, 
           "cumulative", "Zbiór walidacyjny")

# Building neural network with 6 neurons in hidden layer

NNET.4 <- Nnet(MonthGive ~ AdultAge + AveDonAmt + AveIncEA + DonPerYear + 
                 LastDonAmt + NewDonor + NRegion + YearsGive + SomeUnivP, data=CCS, decay=0.10, 
               size=6, subset='Sample=="Estimation"')

# Lift charts - estimation subset

lift.chart(c("GLM.2","MixedCCS","RPART.3","NNET.2","NNET.3","NNET.4" ), CCS[CCS$Sample=="Estimation",], "Yes", 0.01, 
           "cumulative", "Zbiór estymacyjny")

# Lift charts - validation subset

lift.chart(c("GLM.2","MixedCCS","RPART.3","NNET.2","NNET.3","NNET.4"), CCS[CCS$Sample=="Validation",], "Yes", 0.01, 
           "cumulative", "Zbiór walidacyjny")

lift.chart(c("GLM.2","MixedCCS","RPART.3","NNET.4"), CCS[CCS$Sample=="Validation",], "Yes", 0.01, 
           "cumulative", "Zbiór walidacyjny")

wynik<-predict(NNET.4,data=CCS, subset='Sample=="Validation"')
wynik<-round(wynik,0)









