library('BCA')
library('car')
library('RcmdrMisc')
library('sandwich')
library('relimp')
data(Eggs, package="BCA")

# Analysis relations for all vaiables

pairs(Eggs, panel = panel.smooth, main = "Eggs")

# Check variables

variable.summary(Eggs)

# Scatterplot graph

scatterplot(Cases~Egg.Pr, reg.line=lm, smooth=TRUE, boxplots='xy', data=Eggs)


# Please build graphs for  variable "Cases" and other numeric variables.

# Line graph
with(Eggs, lineplot(Week, Cases))

# Analysis for weeks 40 and 90
showData(Eggs)
Boxplot(Cases~Easter, data=Eggs, id.method="n")

# Analysis relations for all numeric vaiables
scatterplotMatrix(~Beef.Pr+Cases+Cereal.Pr+Chicken.Pr+Egg.Pr+Pork.Pr+Week, reg.line=lm, smooth=TRUE, spread=FALSE, span=0.5, id.n=0, diagonal = 'boxplot', data=Eggs)

# Regression model
Eggs.model1 <- lm(Cases ~ Beef.Pr + Cereal.Pr + Chicken.Pr + Easter + Egg.Pr + First.Week + Month + Pork.Pr , data=Eggs)
summary(Eggs.model1)

# ANOVA Table - factor variables importance checking
# checking importance of factor variables
Anova(Eggs.model1)

# Please reduce non important variables using R square and p- values parameters

# Non linear model

# Logarithm of continuous variables
Eggs$log.Cases <- with(Eggs, log(Cases))
Eggs$log.Cereal.Pr <- with(Eggs, log(Cereal.Pr))
Eggs$log.Egg.Pr <- with(Eggs, log(Egg.Pr))
Eggs$log.Chicken.Pr <- with(Eggs, log(Chicken.Pr))
Eggs$log.Beef.Pr <- with(Eggs, log(Beef.Pr))
Eggs$log.Pork.Pr <- with(Eggs, log(Pork.Pr))

# Building non linear model
Non.LinearModel.2 <- lm(log.Cases ~ log.Beef.Pr + log.Cereal.Pr + log.Chicken.Pr + log.Pork.Pr+ log.Egg.Pr  + Month + Easter + First.Week, data=Eggs)
summary(Non.LinearModel.2)


# Exercise
# Please reduce variables for both models and choose the best one.










