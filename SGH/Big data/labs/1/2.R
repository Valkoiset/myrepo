setwd("~/Desktop/SGH/2 semester/Big data/labs/1")

a<-read.csv("crx.txt", header=FALSE)

library(relimp)

# Display dataframe (package relimp) , function showData

showData(a)

# Summarize variables, function variable.summary, package BCA

library(BCA)

variable.summary(a)

# Remove unnecessary variables (package dplyr), function select


library(dplyr)

b<-select(a, -c(V1:V2,V5))

showData(b)

# Input own labels to dataframe

names(b)<-c("Z1","Z2","Z3","Z4","Z5","Z6","Z7","Z8","Z9","Z10","Z11","Z12","Z13")

# Change values for factor variable, function Recode, package car


library(car)

b <- within(b, {
  Z13 <- Recode(Z13, '"+"="YES"', as.factor.result=TRUE)
})

b <- within(b, {
  Z13 <- Recode(Z13,'"-"="NO"', as.factor.result=TRUE)
})

# Filter data, function filter, package dplyr


c<-filter(b, Z1>10,Z1<20,Z13=="YES")  # , means "and"
d<-filter(c,Z8==7|Z8==17|Z8==11)      # | means "or"

#sqldf

library(sqldf)

sqldf('SELECT * FROM iris LIMIT 5')

sqldf('SELECT * FROM iris ORDER BY "Sepal.Length" ASC LIMIT 5')

sqldf('SELECT * FROM rock WHERE (peri > 5000 AND shape < .05) OR perm > 1000')

sqldf('SELECT * FROM BOD WHERE Time IN (1,7)')

sqldf('SELECT * FROM BOD WHERE Time NOT IN (1,7)')

sqldf('SELECT * FROM chickwts WHERE feed LIKE "%bean" LIMIT 5')

sqldf("SELECT tree, AVG(circumference) AS meancirc FROM Orange GROUP BY tree")

