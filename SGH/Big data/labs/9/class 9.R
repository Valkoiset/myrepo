

library(foreign)
library(BCA)
library(relimp)
library(car)
library('RcmdrPlugin.BCA')
library(sqldf)


# Data import frm dbf dataset into R (please change directory)

Wesbrook <- read.dbf("D:/Jarek/Big Data Pol/LAB5/Wesbrook.dbf", as.is=FALSE)

# Creating validation and estimation datasets

Wesbrook$Sample <- create.samples(Wesbrook, est = 0.70, val = 0.30, rand.seed = 1)

# Calculating new variables : YRFDGR and YRLDGR
Wesbrook$YRFDGR <- with(Wesbrook, 1999-FRSTYEAR)
Wesbrook$YRLDGR <- with(Wesbrook, 1999-GRADYR1)

# Deleting variables FRSTYEAR and GRADYR1 from dataset

Wesbrook <- within(Wesbrook, {
  FRSTYEAR <- NULL 
})

Wesbrook <- within(Wesbrook, {
  GRADYR1 <- NULL 
})

# Deleting variable BIGBLOCK from dataset.

Wesbrook <- within(Wesbrook, {
  BIGBLOCK <- NULL 
})


# Data imputation. Replacing columns YRFDGR and YRLDGR with zeros and 
# DEPT1 and FACULTY1 with ND (no degree).

Wesbrook <- within(Wesbrook, {
  YRFDGR <- Recode(YRFDGR, 'NA=0', as.factor=FALSE)
})

Wesbrook <- within(Wesbrook, {
  YRLDGR <- Recode(YRLDGR, 'NA=0;', as.factor=FALSE)
})

Wesbrook <- within(Wesbrook, {
  DEPT1 <- Recode(DEPT1, 'NA="ND"', as.factor=TRUE)
})

Wesbrook <- within(Wesbrook, {
  FACULTY1 <- Recode(FACULTY1, 'NA="ND"', as.factor=TRUE)
})


# Deleting variable martial with a lot of missing values

Wesbrook <- within(Wesbrook, {
  MARITAL <- NULL 
})


# Variable TOTALGIVE has very strong corelation with dependent variable
# so should be removed from dataset

Wesbrook <- within(Wesbrook, {
  TOTLGIVE <- NULL 
})


# Variable ID is indentyfier and is not important to explain
# depended variable

row.names(Wesbrook) <- as.character(Wesbrook$ID)
Wesbrook$ID <- NULL

# Variable EA has the same properties as postal code
# Variable INDUPTD is internal variable
# Variable MAJOR1 has a lot of NA values
# Deleting variables MAJOR1,EA and INDYPTD

Wesbrook <- within(Wesbrook, {
  EA <- NULL 
})

Wesbrook <- within(Wesbrook, {
  INDUPDT <- NULL 
})

Wesbrook <- within(Wesbrook, {
  MAJOR1 <- NULL 
})

# Checking variables

variable.summary(Wesbrook)

# Example how to delete all variables with NA values from dataset and
# creating new dataset Wesbrook2

Wesbrook2 <- na.omit(Wesbrook)
variable.summary(Wesbrook2)
showData(Wesbrook2)

# Corelation matrix for all variables

cor(Wesbrook2[,c("AVE_INC","CNDN_PCT","DWEL_VAL","ENG_PCT","HH_1PER","HH_2PER",
                 "HH_3PER","HH_45PER","MOV_DWEL","OWN_PCT","SD_INC","YRFDGR","YRLDGR")], 
    use="complete")

# Creating maximum model

GLM.MAX <- glm(WESBROOK ~ ATHLTCS + AVE_INC + CHILD + CNDN_PCT + DEPT1 + DWEL_VAL + 
                 ENG_PCT + FACSTAFF + FACULTY1 + HH_1PER + HH_2PER + HH_3PER + HH_45PER + MOV_DWEL + 
                 OTHERACT + OWN_PCT + PARENT + PROV + SD_INC + SEX + SPOUSE + YRFDGR + YRLDGR, 
               family=binomial(logit), data=Wesbrook2, subset=Sample=="Estimation")
summary(GLM.MAX)
1 - (GLM.MAX$deviance/GLM.MAX$null.deviance) # McFadden R2

# Variable reduction using WesStep algorithm

WES.STEP <- step(GLM.MAX, direction="both", k=2)
summary(WES.STEP)
1 - (WES.STEP$deviance/WES.STEP$null.deviance) # McFadden R^2

# Models comparison using lift charts

lift.chart(c("GLM.MAX", "WES.STEP"), 
           Wesbrook2[Wesbrook2$Sample=="Validation",], "Y", 0.1, "cumulative")

variable.summary(Wesbrook2)

# Setting ActiveDataSet variable. Its importand for functions
# rankScore() i rawProbScore()

ActiveDataSet('Wesbrook2')

# Adding new variable Score allow ranking creation. 
# Functions rankScore and rawProbScore are defined in package RcmdrPlugin.BCA

Wesbrook2$Score <- rankScore("WES.STEP", Wesbrook2, "Y")

Wesbrook2$Pr <- rawProbScore("WES.STEP", Wesbrook2, "Y")

# data sorting

Wesbrook2<- sqldf('SELECT * FROM Wesbrook2 ORDER BY "Pr" DESC')