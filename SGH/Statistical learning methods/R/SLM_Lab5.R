# Statistical learning methods
# Lab 5 - neural networks, deep learning
# materials: www.e-sgh.waw.pl/bk48144/SLM
# mail: bk48144@sgh.waw.pl, konbeata@gmail.com

rm(list=ls())

library(nnet)
library(deepnet)
library(mlbench)
library(neuralnet)
library(h2o)

############

# Data:
# http://archive.ics.uci.edu/ml/machine-learning-databases/housing/housing.data

setwd("~/Desktop/SGH/2 semester/Statistical learning methods/R")

#read data
DATA_SET <- read.table("housing.data")
names(DATA_SET) <- c("CRIM", "ZN", "INDUS", "CHAS", "NOX", "RM", "AGE",
                     "DIS", "RAD", "TAX", "PTRATIO", "B", "LSTAT", "MEDV")

#scale data (Used in methods with penalty on parameters) -
a <- which(colnames(DATA_SET) == "MEDV")

SCALED_DATA <- scale(DATA_SET[, -ncol(DATA_SET)]) #centers (subtracting the column mean) and scales (dividing the (centered) columns of x by their standard deviations) 
SCALED_DATA <- scale(DATA_SET[, -a])

FINAL_DATA <- cbind(SCALED_DATA, DATA_SET$MEDV)
colnames(FINAL_DATA) [a] <- "MEDV"

  #divide dataset 
  set.seed(0)
  rand <- sample(1:nrow(FINAL_DATA), 0.8*nrow(FINAL_DATA))
  
  TRAIN <- FINAL_DATA[rand, ]
  VALID <- FINAL_DATA[-rand, ]
  TRAIN <- as.data.frame(TRAIN)
  VALID <- as.data.frame(VALID)
  
  #decay - weigths quadratic regularization term and prevents the weights from growing too large
  #decay: the bigger value, the greater penaly on parameters, 
         #the less complex the model. To small: overtrained model
  
NEURONS <- 5
DECAYS <- 20

wts.parameter <-  2 * runif(5 * ncol(FINAL_DATA) + NEURONS + 1) - 1 #starting weights 

neural.nets <- nnet(MEDV ~ ., data = TRAIN, size = NEURONS, 
                    decay = DECAYS, linout = T, maxit = 10000,
                    trace = T, Wts = wts.parameter)

train.error <- mean(neural.nets$residuals ^ 2)
prediction <- predict(neural.nets, newdata = VALID)
valid.error <- mean((VALID$MEDV - prediction) ^ 2) #as MSE

  #with loop build nets for 100 different decay parameter from 0 to 40
  
  DECAYS <- seq(0, 40, length.out = 100)
  
  train.error <- valid.error <- numeric(length(DECAYS))
  neural.nets <- list()

  progress.bar <- winProgressBar("Progess in %", "0% completed", 0, 1, 0)

  for (i in 1:length(DECAYS)) {
    
    neural.nets[[i]] <- nnet(MEDV ~ ., data = TRAIN, size = NEURONS, 
                        decay = DECAYS[i], linout = T, maxit = 10000,
                        trace = T, Wts = wts.parameter)
    
    train.error[i] <- mean(neural.nets[[i]]$residuals ^ 2)
    prediction <- predict(neural.nets[[i]], newdata = VALID)
    valid.error[i] <- mean((VALID$MEDV - prediction) ^ 2) #as MSE
    
  }
  
  


# percentage <- d / length(DECAYS)
# setWinProgressBar(progress.bar, percentage, "Progess in %",
#                  sprintf("%d%% completed", round(100 * percentage)))


#close(progress.bar)
which.min(valid.error)
  
best.neural.net <- neural.nets[[which.min(valid.error)]]

#build OLS
ols <- lm(MEDV ~ ., data = TRAIN)
ols.train.error <- mean(ols$residuals ^ 2) #calculate train error
prediction <- predict(ols, newdata = VALID)
ols.valid.error <- mean((VALID$MEDV - prediction) ^ 2) #MSE
min(valid.error) # ???

pdf("plot.pdf")
plot(DECAYS, train.error, "l", ylim = range(c(train.error, ols.valid.error)),
     lwd = 2, col = "red", xlab = "Parametr decay", ylab = "MSE")
lines(DECAYS, valid.error, "l", col = "blue", lwd = 2)
points(DECAYS[which.min(valid.error)], min(valid.error),
       pch = 19, col = "blue", cex = 1.5)

points(DECAYS[which.min(train.error)], min(train.error),
       pch = 19, col = "red", cex = 1.5)

abline(h = ols.train.error, col = "red", lty = 2)
abline(h = ols.valid.error, col = "blue", lty = 2)
legend("top", lty = c(1, 1,  2, 2), lwd = c(2, 2,  1, 1),
       col = c("red", "blue"), pch = c(NA, NA,NA, NA, NA),
       y.intersp = 0.7, ncol = 2,
       legend = c("Net train", "Net valid",
                  "OLS train", "OLS valid"))                                                    

dev.off()


##############
#Data - breast cancer
data("BreastCancer")
str(BreastCancer)

#remove column 'Id'
nrow(BreastCancer)
length(unique(BreastCancer$Id))
BreastCancer$Id <- NULL

#change each column (excluding column 'Class') to numeric
cols <- which(colnames(BreastCancer) != "class")

for (k in cols) {
  BreastCancer[, k] <- as.numeric(BreastCancer[, k])
}

#omit missing values
BreastCancer <- na.omit(BreastCancer)

#change 'Class' variable to character  
BreastCancer$Class <- as.character(BreastCancer$Class)

#replace 'benign' value in 'Class' variable to 0 and 'malignant' to 1
    # 1
BreastCancer$Class <- ifelse(BreastCancer$Class == "benign", 0, 1)

    # 2
BreastCancer$Class[BreastCancer$Class == "benign"] <- 0
BreastCancer$Class[BreastCancer$Class == "malignant"] <- 1
BreastCancer$Class <- as.numeric(BreastCancer$Class)

# assign column 'Class" vector 'y'
y <- BreastCancer$Class

#assign remaining column to x and convert it to matrix   
x <- BreastCancer[, -which(colnames(BreastCancer) == "Class")]
x <- as.matrix(x)

#biblioteka deepnet
nn <- nn.train(x, y, hidden = c(2,5))
yy <- nn.predict(nn, x)
yy <- as.numeric(yy)
head(yy)

cat <- ifelse(yy > mean(yy), 1, 0)
cm <- table(cat,y)

print(sum(diag(cm))/sum(cm))

# neuralnet library

#full MNIST dataset: 
#https://www.kaggle.com/c/digit-recognizer/ 

#read file "MNIST_train1000.csv", ',' as separator, '.' as decimal point
mnist <- read.csv("MNIST_train1000.csv")
  
xx <- data.frame(class.ind(as.factor(mnist$label)))
mnist <- cbind(mnist[, -1], xx) 

#divide dataset

train <- 
valid <- 

#prepare formula with Y's and X's  
y <- paste0("X", c(0:9))
x <- setdiff(colnames(mnist), y)
x <- paste(x, collapse = "+")
y <- paste(y, collapse = "+")

nn = neuralnet(as.formula(paste0(x," ~ ", y)), data = train, hidden = c(2,3),  act.fct = "logistic", linear.output = FALSE)
plot(nn)

yy <- compute(nn, valid[, -which(colnames(valid)%in%paste0("X", 0:9))])
yy = yy$net.result

original_values <- max.col(valid[, which(colnames(valid)%in%paste0("X", 0:9))])
pr.nn_2 <- max.col(yy)
outs <- mean(pr.nn_2 == original_values)



# h20

#define variable 'label'as factor


localH2O = h2o.init(ip="localhost", port = 54321, 
                    startH2O = TRUE, nthreads=-1)

#divide dataset

train <- 
  valid <- 
  
  h2o.train <- as.h2o(train)
h2o.valid <- as.h2o(valid)

h2o.model <- h2o.deeplearning(x = setdiff(names(train), c("label")),
                              y = "label",
                              training_frame = h2o.train,
                              validation_frame = h2o.valid,
                              standardize = TRUE,         # standardize data
                              hidden = c(100, 100),       # 2 layers of 100 nodes each
                              rate = 0.05,                # learning rate
                              epochs = 10,                # iterations/runs over data
                              seed = 1234                 # reproducability seed
)


h2o.predictions <- as.data.frame(h2o.predict(h2o.model, h2o.valid))
print(h2o.cm <- table(h2o.predictions$predict, valid$label))
