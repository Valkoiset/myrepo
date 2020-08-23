

library(BCA)
library(relimp)
library(car)
library(RcmdrMisc)
library(foreign)
library(corrplot)
library(dplyr)

rm(list=ls())                      # clean environment
if(!is.null(dev.list())) dev.off() # clean all plots
cat("\014")                        # clean console

# Loading data
Wesbrook <- read.dbf("~/Desktop/SGH/2 semester/Big data/labs/4/Wesbrook.dbf", as.is=FALSE)

variable.summary(Wesbrook)

# Exclude some columns
Wesbrook$ID <- NULL
Wesbrook$INDUPDT <- NULL

# Removing variables which have too much NA values
Wesbrook <- within(Wesbrook, {
  BIGBLOCK <- NULL # 1 level factor variable
  GRADYR1 <- NULL
  FACULTY1 <- NULL
  DEPT1 <- NULL
  FRSTYEAR <- NULL
  MARITAL <- NULL
  MAJOR1 <- NULL
})

# Generalized linear model
GLM <- glm(WESBROOK ~ . , family=binomial(logit), data=Wesbrook)

# R2 McFadden value
1 - (GLM$deviance/GLM$null.deviance) # 0.7210275

# Excluding all NA from Wesbrook
Wesbrook <- na.exclude(Wesbrook)

# Checking if there are still some NA values
any(is.na(Wesbrook))

# Check correlations
corr <- cor(select_if(Wesbrook, is.numeric))
corrplot(corr, method = "number")

summary(GLM)

# Deleting collinear independent variables
Wesbrook <- within(Wesbrook, {
  SD_LINK <- NULL
  CNDN_PCT <- NULL
  HH_45PER <- NULL
})

# Generalized linear model after excluding 3 variables
GLM2 <- glm(WESBROOK ~ . , family=binomial(logit), data=Wesbrook)
summary(GLM2)
1 - (GLM2$deviance/GLM2$null.deviance) # 0.7209341

# Creating Log columns
Wesbrook$LogTOTLGIVE <- with(Wesbrook, log(TOTLGIVE))
Wesbrook$LogEA <- with(Wesbrook, log(EA))
Wesbrook$LogMOV_DWEL <- with(Wesbrook, log(MOV_DWEL))
Wesbrook$LogHH_3PER <- with(Wesbrook, log(HH_3PER))
Wesbrook$LogAVE_INC <- with(Wesbrook, log(AVE_INC))
Wesbrook$LogDWEL_VAL <- with(Wesbrook, log(DWEL_VAL))
Wesbrook$ENG_PCT <- with(Wesbrook, log(ENG_PCT))
Wesbrook$OWN_PCT <- with(Wesbrook, log(OWN_PCT))
Wesbrook$SD_INC <- with(Wesbrook, log(SD_INC))

# Model after excluding transforming to logs
GLM3<- glm(WESBROOK ~ LogTOTLGIVE, LogEA, LogMOV_DWEL, 
            family=binomial(logit), data=Wesbrook)
summary(GLM3)
1 - (GLM3$deviance/GLM3$null.deviance) # 0.7209341