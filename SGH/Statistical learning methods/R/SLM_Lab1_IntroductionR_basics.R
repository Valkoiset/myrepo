# Statistical learning methods
# Lab 1 - Introduction to R
# materials: www.e-sgh.waw.pl/bk48144/SLM
# e-mail: konbeata@gmail.com

# Plan
#   I. About R
#   II. Working R
#   III. Objects in R
#   IV. Data Export/Import 
#   V. Statistics in R
#   VI. Conditional instructions
#   VII. Loops
#   VIII. Functions

# I. About R -------------------------------------------------------------

# Where to find information?
# http://www.r-project.org/doc/bib/R-books.html
## manuals: 
# http://cran.r-project.org/manuals.html
## R for data analysis
##  Gareth James, Daniela Witten, Trevor Hastie and Robert Tibshirani
## An Introduction to Statistical Learning with Applications in R
#http://www-bcf.usc.edu/~gareth/ISL/

#Polish books, websites:
## Bogumi? Kami?ski, Mateusz Zawisza "Receptury w R - Podr?cznik dla ekonomist?w"
##K. Kopczewska, T. Kopczewski, P. W?jcik, Metody ilo?ciowe w R. Aplikacje ekonomiczne i finansowe, 2009, CeDeWu
## Eugeniusz Gatnar, Marek Walesiak "Analiza danych jako?ciowych i symbolicznych z wykorzystaniem programu R"
## Eugeniusz Gatnar, Marek Walesiak "Statystyczna analiza danych z wykorzystaniem programu R"
## Przemys?aw Biecek 'Przewodnik po pakiecie R'
# http://www.biecek.pl/R/R.pdf
## Przemys?aw Biecek 'Na przelaj przez Data Mining z pakietem R'
# http://www.biecek.pl/NaPrzelajPrzezDataMining/NaPrzelajPrzezDataMining.pdf

## Project website:
# http://www.r-project.org/

# What if I did't find there help?
# http://r.789695.n4.nabble.com/
# http://stackoverflow.com/

## Selected keyboard shortcuts in RSTUDIO
# CTRL+ENTER: running a instruction (R GUI - F5): active line or 
# TAB: hints for functions/objects
# TAB after opening bracket: function arguments
# F1 on function: help
# CTRL+1: switching to editor
# CTRL+2: switching to console
# CTRL+L: clear console

# II. Working with R -----------------------------------------------------------


# How works R:
# - console
# - scripts



# If we need documantation of function (or any other thing)
# help(<function_name>)
help()
help(plot)

# Similar to:
# ?function_name - looks for functions with identical name as given string
# ??"function_name" - looks for functions that have in name or in description given string
?plot
??"plot"

# Setting and changing working directory
getwd() 
setwd("D:/")
dir() #content of working directory

# We can also change it by menu and "session" tab


# Workspace
# keeps declared variables/functions/data
x <- 2
ls()            # list what we have in workspace
rm("x")         # remove element from workspace
rm(list=ls())   # remove ALL elements from workspace


## Additional packages

# Installing
# install.packages("package_name")
install.packages("randomForest")

# First you have to load package, before you use it
# library(<package_name>)
library(randomForest)
require(randomForest)

## Tyes of variables 
# There are no seperate types for letters and words
typeof()

#logical values
T == TRUE   
F == FALSE   

# Class is different from type. Type defines the way that object is kept
# Class is an attribute of the object (in the terms of object programming)
typeof(1)
class(1)

# Family of function checking and converting types 
is.numeric(1.5)
as.character(3)

# If we do not have data
NA           # Not Available
is.na(NA)

NaN     # Not a Number
is.na(NaN)

# III. Objects in R --------------------------------------------------------
# !!!  In R evertying is an object

### scalars

b <- 5
b

# arrows can be used in both ways
10 -> a
a

# multiassignement
a <- b <- c <- 20
a
b
c

# Mathematical functions
# square root
# absolute value
# logarithm

sqrt(5)     
abs(-99)    
log(56)
logb(56, base = 5.6)

#How do we round numbers?
ceiling(3.5)
floor(3.5)
trunc(5.99)

# difference between 'trunc; and 'floor'
floor(-1.5)
trunc(-1.5)

round(6.592, digits = 2)

#factorial
#exponential
#sin
factorial(5)

exp(1)
sin(0)

### Vectors
# !!! Vector keeps elements of the same type 

# Vectors begin with 'c'
x <- c(1, 6, 9) 
x     
y <- c("a", "b", "c")
y
z <- c(TRUE, FALSE, TRUE)

#Sequences
1:10
x <- seq(1, 8, by = 2)     
x
x <- seq(1, 8, length = 5)
x

#Vectors with replicated values
rep(c(1, 3, 5), times = 3)
rep(c(1, 3, 5), each = 3)
rep(c(1, 3, 5), times = 3, each = 3)


# Different functions useful for vectors
#sample
#length
#rev
#unique
#sort
#order
#sum, cummulative sum
#product, cumulative prod
#difference

x <- sample(1:10, 10) 
length(x)      
rev(x)         
unique(x)      
sort(x)       
sort(x, decreasing = TRUE)
order(x)       
x[order(x)]    

sum(x)        
prod(x)       
cumsum(x)   
cumprod(x)  
diff(x)        

#to omit missing values use na.rm argument
x <- c(2,3,4, NA)
mean(x)
mean(x, na.rm = T)

#Generating random numbers
set.seed(1) #setting seed of generator
los <- rnorm(1000) #generating 1000 random numbers
hist(los, freq = 0) #plotting histogram
lines(density(los), col = "blue") #adding lines with density

x <- seq(from = min(los), to = max(los), by = 0.1)
mean(los)
sd(los) 
dens <- dnorm(x,mean = mean(los), sd = sd(los))
lines(x, dens, col = "red")

hist(x <- rnorm(100, mean = 10, sd = 3), freq = 0)
lines(density(x))

los <- runif(10^6)
hist(los, xlim = c(-1,2))

# Indexing, can be done be reffering to the position
y <- c(3, 5, 1, -0.9, 44, 17, 9)
y[5]      # 5th element of y
y[3:5]    # from 3rd to 5th elements
y[4] <- 1000
y
y[-4]     # vector y without 4th element

# indexes can be vectors
y[c(1, 5, 6)]
y[c(-2, -3, -7)]

# 'positive' and 'negative' indexes can not be mixed
y[c(-3, 1)]

# or by logical values
# & - and
# | - or
y <- rnorm(100)
y > 0 

y[y > 2]           # elements of vector greater than 2
y[y < -2 | y > 2]  # elements of vector smaller than -2 OR greater than 2 
y[y > 1 & y < 2]   # elements of vector greater than 1 AND smaller than 2 
y[y > mean(y)]

x <- y
x == y
all(x == y)
(x[6] <- 0)
!(x == y)
all(x == y)
any(x == y)

## Working on vectors
# working sperately on each element
# or we can use functions

(x <- 1:12)
x + 2
x * 5
x ^ 2

x <- 1:5
y <- 6:10
x + y
x^y

# Vector functions 
#several functions take vector as a argumnet and runs founction for each element
#returning vector of the same length as input vector

sin(x)
exp(x)


## Excercise
# Create vector named id that consints of numbers from your student number
# Check if its type is numeric or character
# Replace 3th element with 5
# Take 1st and 2nd element to the power of two
# Check which elements are greater than 8 and smaller or equal to 35
# Sort decreasingly
# Sum all elements, devide by 3 and round to integer value

id <- c(8, 3, 4, 5, 9)
is.numeric(id)
is.character(id)
id[3] <- 5
id[1:2] ^ 2
id[id > 8 & id <= 35]
sort(id, decreasing = TRUE)
round(sum(id) / 3)

## Matrix
# Matrixes keeps elements of the same type
x <- seq(1, 99, length = 8)
A <- matrix(x, ncol = 4, nrow = 2, byrow = FALSE)
A
A <- matrix(x, ncol = 4, nrow = 2, byrow = TRUE)  

# Indexing
A[3:4]
A[2, ]
A[, 4]
A

# Multiplying matrixes
B <- matrix(1:16, nrow = 4)
A %*% B

# dimmensins have to be correct
B %*% A

dim(B)

#or check the number of rows
nrow(B)

#or columns
ncol(B)

# Multiplying elements by each other
A * A

# Important
# For matrixes and vectors we can use most mathematical functions
log(B)
sin(A)
A * 5
A + 10

# Binding matrixes
# by columns
cbind(B, t(B))

# or by rows
rbind(A, 2 * A)

# ! dimmensions must be correct
cbind(A, B)
rbind(A, B)

### Lists
# Lists are collection of vectors that can keep elements of different types (or other lists)

myList <- list(a = 1, b = "a", c = 1:4, d = list(), 6)
myList

#Indexing
# List is indexed simmilary to vectors, however: 
myList[3]           # returns list that has one element
class(myList[3])    
myList[[3]]         # returns elements of the list
myList[[3]][1]      # first element of list's third element

#or we can reffer to name
myList[["c"]]

# or use '$'
myList$c

##### DATA FRAME
Dane <- data.frame(aa = B[,1], bb = B[,2], B[,3])

# Vectors have to have the same length
Dane
Dane$aa  # reffering only to 'aa' column

#
attributes(Dane) 
head(Dane, 1)    
tail(Dane)
str(Dane)

# Most functions can be applied to data.frame
sin(Dane)
t(Dane)
rbind(Dane, Dane)

# Excercise
# 
# Create data frame "myData" with following records:
# ? name
# ? second name (NA if he/she does not have one)
# ? age
# ? sex (TRUE if woman, FALSE if man)
# containg data for 3 people
# order according to age
# choose 1st and 3rd record
# add new column named 'occup' that has value 'student' for all cases



#### Factors

eyeColor <- c('n', 'n', 'z', 'b', 'b', 'b', 'n', 'z', 'b', 'z')
eyeColor
eyeColor <- factor(eyeColor)
eyeColor
levels(eyeColor)
levels(eyeColor) <- c("brown", "blue", "green")

### Working with text value ###

# 'paste' -
text1 <- c("X","Y","Z")
numb <- c(1:12)
paste(text1, numb, sep = "")
paste(text1, numb, collapse = "")
paste0


# regular expressions 
sent <- c("Ala", "has", "a cat")	
grep("Ala", sent)     # returns index of expresion
grepl("has", sent)     # returs logical value
gsub("has", "does not have", sent)	# replacement

	

# IV. Data export/import ---------------------------------------------------

?read.table
?read.csv
?read.csv2

ORLEN <- read.csv("/Users/Desktop/SGH/2 semester/Statistics/R/orlen.csv", sep = ";", dec = ",")

# V. Statistics in R -------------------------------------------------

require(moments)
require(MASS)

#1. Statistics decribing data set

head(ORLEN) # look at few first records and column names
tail(ORLEN) # look at few last records and column names
colnames(ORLEN) #column names
ORLEN$Closing_rate #Dataset name combined with dollar sign and column name returns that column
ORLEN[,2] #returns the same as previous line
sum(is.na(ORLEN)) #counts missing values

summary(ORLEN) #calculates basic statistics for each column

#Analysis: 'Change' variable

# A) Mean, median, quantiles
mean(ORLEN$Change)
mean(ORLEN$Change, trim = 0.10) #trims extremal values - 10% of highest and lowest values and calculates mean from remaining
quantile(ORLEN$Change, 0.1) #10th percentile
median(ORLEN$Change) #the same as 50th percentile

plot(ORLEN$Change, pch = 20 , xlab = "Observations", ylab = "RM", type = "p") 
# pch - point type - 20 is filled dot,  xlab - x axis label, ylab - y axis label, type: type of plot (here: p-points)

abline(h = mean(ORLEN$Change), col = "red", lwd = 2, lty = 2 ) 
# line with mean value, h - value for horizontal line, v - value for vertical line, lty - line type, lwd - line width


# B) Variance and standard deviation

var(ORLEN$Change)
sd(ORLEN$Change) # standard deviation 
abline(h = c(mean(ORLEN$Change)+3*sd(ORLEN$Change), mean(ORLEN$Change)-3*sd(ORLEN$Change)), lwd = 2, lty = "dashed", col = "yellow")

# C) Max and Min
max(ORLEN$Change)
min(ORLEN$Change)

# D) Quantiles
quantile(ORLEN$Change)

# E) Range
range(ORLEN$Change)

# F)Interquartile range 
IQR(ORLEN$Change)

# G) Length
length(ORLEN$Change)

# H) Skewness
skewness(ORLEN$Change)

# I) Correlation
cor(ORLEN$Change, ORLEN$Turnover)
cor(ORLEN$Change, ORLEN$Transactions)
cor.test(ORLEN$Change, ORLEN$Transactions)# with p-value

# J) All-in-One
summary(ORLEN$Change)

#cross tables
str(ORLEN)
ORLEN$Date <- as.Date(ORLEN$Date, format = '%d.%m.%Y')
ORLEN$year <- format(ORLEN$Date,format = '%Y')
ORLEN$trans <- ifelse(ORLEN$Transactions >= mean(ORLEN$Transactions),"bigger or equal to mean","below mean")

table(ORLEN$year)
tablica <- table(ORLEN$year, ORLEN$trans)

prop.table(tablica,1)
prop.table(tablica,2)


margin.table(tablica,1)
margin.table(tablica,2)

#Excercise
# Load dataset 'trees' 
# Check number of observations
# Check tha value of variable in the last line
# Calculate mean, median, standard deviation for variable 'Hight'. Chcek the skewness
# Draw a scatterplot for variable 'Hight". With red line indicate the mean value, change axis nammes

# VI. Conditional instructions  ----

(zmienna <- rnorm(1))

#if the condition is fullfilled then run a commend
if (zmienna < 0){
  cat("below zero \n")
}

#if the condition is fullfilled then run a commend, otherwise run another commend
if (zmienna < 0){
  cat("below zero \n")
}else{
  cat("greater or equal to zero")
}

# condition has to be described with single value

if (c(-1,0,1) > 0){
  cat("greater\n")
}


# or you can bulid combined conditions

zmienna <- 1.2
if (zmienna < 0 & zmienna^2 > 0.5){
  cat("OK\n")
  }else{ cat("Not OK\n")
}

if (zmienna < 0 | zmienna^2 > 0.5){
  cat("OK\n") 
}else{
  cat("Not OK\n")
}

### IFELSE - vector version of of function

(zmienna <- rnorm(5))

d <- ifelse(zmienna < 0, "smaller", "bigger or equal")
# commend is ran for each value
d

# returned values can also be vectors
x <- 1:5
y <- -(1:5)

ifelse(zmienna < 0, x, y)


# VII. Loops ---------------------------------------------------------------

### FOR

for(i in 1:5){
  cat("value i equals to", i, "\n")
}


(macierz <- matrix(1:20, 5, 4))
for(i in 1:nrow(macierz)) {
  print(mean(macierz[i,]))
}

# loops are quite slow in R. It is recommended to use vector functions

rowMeans(macierz)


# next goes skips the step and goes to the next value of i 
## 'next' i 'break'
for(i in 1:5){
  if (i == 3) next
  cat("value i equals to", i, "\n")
}


#break stopsloop
for(i in 1:5){
  cat("value i equals to", i, "\n")
  if (i == 3) break
}


for(i in 1:4){
  for (j in 1:4){
    if (j == i) break
    cat(paste("value i equals to", i, "an j to ", j, "\n"))
  }
}

#VIII. Functions ----

myFunction <- function(argumentsNames){
  instructions
}

sayHello<-function(i){
  cat(rep("say hello\n",i))
}

sayHello(3)

jedynka <- function(x, y){
  z1 <- sin(x)
  z2 <- cos(y)
  z1^2 + z2^2
}
jedynka(2,1)
# by default it returns last value 

#it can be defined what is returned
jedynka <- function(x, y){
  z1 <- sin(x)
  z2 <- cos(y)
  wynik <- z1^2+z2^2
  return(wynik)
  
}
jedynka(2,1)