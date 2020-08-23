#Egzamin KOT - 17012018SRD_zaliczenie
#ZAD 2:

#Wgraj dane
mydata <- read.csv("crx.data")

# 1. Chech if there are missing values
any(is.na(mydata))

# 2. Recode V16 '-' to 1, '+' - 0
mydata$X. <- ifelse(data$X. == '+' , 0,1)

# 3. Delete second and 14th variable
mydata <- mydata[,-c(2,14)]

# 4. What is the average for the 8th variable where V16=1
mean(mydata$X1.25[mydata$X.==1], na.rm = T)

# 5. Divide observation on the test and train set (15 and 85%)
set.seed(68044)
train_proportion <- 0.85
train_index <- runif(nrow(mydata)) < train_proportion
train <- mydata[train_index,]
test <- mydata[!train_index,]

# 6. Make decision tree using RPART, set CP = 0
library(rpart)
drzewo <- rpart(X. ~ ., data=mydata, cp=0)

# 7. Choose the best level of tree complexity
plotcp(drzewo)

drzewo <- rpart(X. ~ ., data=train, cp=0.037)


# 8. Write the final tree
# 9. Write one of the rules created by the tree
plot(drzewo,compress=T, uniform=T,margin=0.1,branch=0.3,nspace=2)
text(drzewo,use.n=TRUE,pretty=0)

# 10. Verify the accuracy, true positive, false positive for the cut off = 0.55 on the test set
cat("\nConfusion Matrix - rpart\n")
drzewo_test <-predict(drzewo,type="vector",newdata=test)
drzewo_test1 <- ifelse(drzewo_test > 0.55, 1,0)

drzewo_table <- table(drzewo_test1,test$X.)
drzewo_table

EvaluateModel <- function(classif_mx){
  true_positive <- classif_mx[1,1]
  true_negative <- classif_mx[2,2]
  condition_positive <- sum(classif_mx[ ,1])
  condition_negative <- sum(classif_mx[ ,2])
  accuracy <- (true_positive + true_negative) / sum(classif_mx)
  sensitivity <- true_positive / condition_positive
  specificity <- true_negative / condition_negative
  misclassification <- 1 - accuracy
  return(list(accuracy = accuracy,
              sensitivity = sensitivity,
              specificity = specificity,
              misclassification = misclassification))
}

EvaluateModel(drzewo_table)

# 11. Draw ROC curve, is this model better than random forest?
library(ROCR)
ROC <- plot(performance(prediction(drzewo_test1,test$X.),"tpr","fpr"),lwd=2,col="red")

# 12. Calculate AUC for the test set
auc.tmp <- performance(prediction(drzewo_test1,test$X.),"auc") ; auc <- as.numeric(auc.tmp@y.values)
auc


# Exercise 2

# Wczytaj  dane, no headers, tabulator, strigAsFacotr= False
mydata2 <- read.csv2('noise.dat', sep="\t", stringsAsFactors = F, header = F)


# 1. Check missing values, if so, delete them
sum(is.na(mydata2))

# 2. Histogram and density curve
mydata2$V6 <- as.numeric(mydata2$V6)
hist(mydata2$V6)

plot(density(mydata2$V6))


# 3. Plot scatter plot X - V6; Y- V1, include regression, is there any relation between those variables?
scatter.smooth(mydata2$V6, mydata2$V1, lpars =
                 list(col = "red", lwd = 3))

# 4. Divide in training and testing set (90/10) with seed set to 32
set.seed(32)
train_proportion <- 0.90
train_index <- runif(nrow(mydata2)) < train_proportion
train <- mydata2[train_index,]
test <- mydata2[!train_index,]

# 5. Prepare regression model (V6 - enodogonous variable), according to AIC criterium delete not important variables
mydata2$V2 <- as.numeric(mydata2$V2)
mydata2$V3 <- as.numeric(mydata2$V3)
mydata2$V4 <- as.numeric(mydata2$V4)
mydata2$V5 <- as.numeric(mydata2$V5)

lm<-lm(V6~ V1 + V2,data=train)
?lm
summary(lm)

# 6. Do GAM model on the training set, Y - V6, V1 and V5 use smoothing spine
library(mgcv)
library(ROCR)
library(Ecdat)
gam.model<-gam(V6 ~ s(V1) +  V2 + V3 + V4 + V5, data=train)
?gam
summary(gam.model)

7. Neural Networks
8. Comparision of those 3 methods