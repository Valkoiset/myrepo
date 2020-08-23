

# In first example to build classification tree using Quinlan algorithm we 
# will use package tree.
# Package RODBC is used to import external data from MS Excel file.
# We will use the same data as in the previous module with Neural Network 
# (flat classification problem).

library(tree)
SN <- read.csv("http://jolej.linuxpl.info/SN.csv", sep=";")
DATA<-SN

names(DATA)<-c("size","cost","fited","class")

tk<-table(DATA)

# To create classification tree the function tree from package tree is used.
# First argument is name of dependent variable , after sign ~ the independent # variables are sepcified ( if the all other variables in the dataset are 
# independent variables we can use mask ".").

drzewo.DATA <- tree(class~.,data=DATA)

# Function summary displays descriptive statistics of tree.
sd <- summary(drzewo.DATA)

# Functions plot and text draws graphical representation of the tree
plot(drzewo.DATA)
text(drzewo.DATA)
drzewo2.DATA<-prune.tree(drzewo.DATA, best=3)
plot(drzewo2.DATA)
text(drzewo2.DATA)

# Function predict allow to input new data into tree
a<-predict(drzewo.DATA, newdata=DATA)
a<-round(a,0)
wynik<- data.frame(a,DATA$class)
b<-sum(abs(a-DATA$class))
b

# rattle
# In the second example package rpart will be used, aditionaly please install and 
# load into working area package rattle (we will use fancyRpartPlot function from 
# this package to draw the final result.

library(rattle) # package for GUI in R
library(rpart)

# To create the tree function rpart from packages rpart was used, argument are 
# similar to function tree. In rpart aditionally parameter cp is used (complexity 
# parameter) it regulates the depth of the tree.

RPART.1 <- rpart(class ~. , data=DATA, cp=0.0001) # cp - complexity parameter. larger cp - simplier tree
plotcp(RPART.1)
printcp(RPART.1) # Pruning Table
RPART.1 # Tree Leaf Summary

# To draw the tree in the traditional way functions plot and text can be used.
plot(RPART.1)
text(RPART.1)

# To obtain more smart diagram the function fancyRpartPlot from rattle package can # be used.

fancyRpartPlot(RPART.1)

a<-predict(RPART.1, newdata=DATA)
a<-round(a,0)
wynik<- data.frame(a,DATA$class)
b<-sum(abs(a-DATA$class))
b
