

library(readxl)
library(AMORE) # "A MORE flexible neural network package"

rm(list = ls())
setwd("~/Desktop/SGH/2 semester/Big data/labs/5")

# load data and check its structure
data <- read_excel("data.xls")
str(data)

# checking the number of each group occurences
length(data$`Group of preference`[data$`Group of preference` == 2])   # 51
length(data$`Group of preference`[data$`Group of preference` == 1])   # 49

# dividing data on training and validation datasets
set.seed(231)
rand <- sample(1:nrow(data), 0.7 * nrow(data))
train <- data[rand,]
valid <- data[-rand,]

# constructing matrices and vectors for model
WE = as.matrix(train[, 1:4])        # input data as matrix with 4 columns
WY = as.vector(train[, 5])          # output vector

VAL_WE = as.matrix(valid[, 1:4])
VAL_WY = as.vector(valid[, 5])

net <-
  newff(
    n.neurons = c(4, 10, 10, 1),
    learning.rate.global = 1e-2,
    momentum.global = 0.5,
    error.criterium = "TAO",
    Stao = NA,
    hidden.layer = "tansig",
    output.layer = "purelin",
    method = "ADAPTgdwm"           # this is backpropagation method
  )

# train function activate NN learning
result <-
  train(
    net,
    WE,
    WY,
    VAL_WE,
    VAL_WY,
    error.criterium = "LMS",
    report = T,               # Shows steps in console
    show.step = 100,          # Number of epochs to train non-stop until the training function allows to report.
    n.shows = 4               # Number of times to report (if report is TRUE). 
                              # The total number of training epochs is n.shows times show.step.
  )

# sim function generate ouput from NN
WYSN <- sim(result$net, VAL_WE)

# data frame result compare output from NN with original results
WYSN <- round(WYSN, 0)
result1 <- data.frame(VAL_WY, WYSN)
error <- sum(abs(WYSN - VAL_WY))         
error

# Ploting error function
matplot(
  result$Merror,
  pch = 21:23,
  bg = c("white",  "black"),
  type = "o",
  col = "black",
  xlim = c(1, 30),
  ylim = c(0, 0.2)
)

