


library(BCA)
library(relimp)
library(car)
library(RcmdrMisc)
library(foreign)
library(corrplot)
library(dplyr)

rm(list = ls())            # clean environment
if (!is.null(dev.list()))
  dev.off()                # clean all plots
cat("\014")                # clean console

# Loading data
Wesbrook <-
  read.dbf("~/Desktop/SGH/2 semester/Big data/labs/4/Wesbrook.dbf",
           as.is = FALSE)
variable.summary(Wesbrook)

# Removing some variables
Wesbrook <- within(Wesbrook, {
  ID <- NULL
  INDUPDT <- NULL
  BIGBLOCK <- NULL # 1 level factor variable
  MARITAL <- NULL
  MAJOR1 <- NULL
})

# Creating numerical variable from factor variable WESBROOK
Wesbrook <- within(Wesbrook, {
  WESBROOK <- Recode(WESBROOK, '"Y"=1; "N"=0', as.factor = F)
})

# Creating estimation and validation subsets
set.seed(323)
Wesbrook$Sample <- create.samples(Wesbrook, est = 0.7, val = 0.3)

# Excluding all NA from Wesbrook
Wesbrook <- na.exclude(Wesbrook)

# Checking if there are still some NA values
any(is.na(Wesbrook))

# Generalized linear model after excluding some variables
GLM <- glm(WESBROOK ~ . , family = binomial(logit), data = Wesbrook)
summary(GLM)

# R2 McFadden value
1 - (GLM$deviance / GLM$null.deviance) # 0.7724513

# Selecting 70% of observations for training model
Wesbrook.est <- Wesbrook %>% filter(Sample == "Estimation")

# Selecting only statistically significant variables and dependent one
Wesbrook.est <-
  Wesbrook.est[, c("TOTLGIVE", "PARENT", "CHILD", "OTHERACT", "WESBROOK")]

# Generalized linear model after excluding all insignificant variables
GLM2 <-
  glm(WESBROOK ~ . , family = binomial(logit), data = Wesbrook.est)
summary(GLM2)
1 - (GLM2$deviance / GLM2$null.deviance) # 0.720267

# Creating Log columns
Wesbrook.est$LogTOTLGIVE <- with(Wesbrook.est, log(TOTLGIVE))

# Model after transforming numerical columns to logs
GLM3 <-
  glm(
    WESBROOK ~ LogTOTLGIVE + PARENT + CHILD + OTHERACT,
    family = binomial(logit),
    data = Wesbrook.est
  )
summary(GLM3)
1 - (GLM3$deviance / GLM3$null.deviance) # 0.7502665
