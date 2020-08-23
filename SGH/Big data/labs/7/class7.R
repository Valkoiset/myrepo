library(BCA)
library(relimp)
library(car)
library(RcmdrMisc)


# Loading CCS dataset from BCA package
data(CCS, package="BCA")


# Creating validation and estimation subsets
CCS$Sample <- create.samples(CCS, est = 0.7, val = 0.3)

View(CCS)

# Creating numerical variable from factor variable MonthsGive
CCS <- within(CCS, {
  MonthGive.Num <- Recode(MonthGive, '"Yes"=1; "No"=0', as.factor.result=FALSE)
})

# Variables distribution chart
scatterplot(MonthGive.Num~AveDonAmt, reg.line=lm, smooth=TRUE, 
            id.n = 2, boxplots='xy', span=0.5, data=CCS)

# Means chart for Region variable
with(CCS, plotMeans(MonthGive.Num, Region, error.bars="none"))


# Reorganizing levels of Region factor variable
CCS$NRegion <- relabel.factor(CCS$Region, new.labels=c('NR1','NR1','NR1',
                                                       'NR2','NR2','NR2'))

with(CCS, plotMeans(MonthGive.Num, NRegion))

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

#  Building mixed model

MixedCCS <- glm(MonthGive ~ AveIncEA + DonPerYear + LogAveDonAmt + 
                  LogLastDonAmt + NRegion, family=binomial(logit), data=CCS, 
                subset=Sample=="Estimation")
summary(MixedCCS)
1 - (MixedCCS$deviance/MixedCCS$null.deviance) # McFadden R2


# Lift Charts

# Creating cumulative liftcharts for estimation subset

lift.chart(c("GLM.2", "LogCCS", "MixedCCS"), CCS[CCS$Sample=="Estimation",], "Yes", 0.01, 
           "cumulative", "Estimation subset")


# Creating cumulative liftcharts for validation subset

lift.chart(c("GLM.2", "LogCCS", "MixedCCS"), CCS[CCS$Sample=="Validation",], "Yes", 0.01, 
           "cumulative", "Validation subset")

# Creating incremental lift chart

lift.chart(c("MixedCCS"), CCS[CCS$Sample=="Validation",], "Yes", 0.01, "incremental", 
           "Incremental lift chart - validation dataset")


