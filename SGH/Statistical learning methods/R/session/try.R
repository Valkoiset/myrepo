

              # Statistical Learning Methods - Practical test

# clear the workspace, plots and console
rm(list = ls())
if (!is.null(dev.list()))
  dev.off()
cat("\014")

# Exercise 1 [20p] - Classification problem
# You are quantitative analyst in medical center. You were asked to help medical staff in decision making process to classify patients with breast cancer into two different therapies. For this purpose, build three concurrent classification models (using Conditional Inference Tree method, Recursive Partitioning and Regression Trees method and Random Forest method) and choose the best one with highest prediction accuracy.
# Before You start:
#   1) Install and load package “mlbench” {install.packages(“mlbench”), library(mlbench)}.
# install.packages("mlbench")
library(mlbench)

# 2) Load dataset named “BreastCancer” {data(BreastCancer)}.
data(BreastCancer)
data <- BreastCancer
typeof(data)
# data <- as.data.frame(data)
# typeof(data)

# 3) Set the seed according to the number of your index.
set.seed(83459)

# 4) Keep informed that the endogenous variable is labeled “Class”.
# 5) Keep informed that if it is possible to show outcome for mini tasks, just copy it into MS Word. In case it is not possible, just copy the instruction to MS Word, which should lead to achieve results. Before you send the file to artur.pluska.sgh@gmail.com, save as PDF.
# To get final results go through mini tasks:
#   1) [2p] How many exogenous variables and observations dataset have? What type of object this data set is?
summary(data)
class(data)

#   2) [2p] Does the dataset contains missing values? If yes, impute missing values with method, that you are free to choose (e.g. average, median, regression of other variables, removing these observations, coding as a separate value, etc.).
any(is.na(data))
data[!complete.cases(data),] # show all columns with incomplete cases
summary(data) # checking which column exactly has NAs
data$Bare.nuclei <- as.numeric(as.character(data$Bare.nuclei))
data$Bare.nuclei[is.na(data$Bare.nuclei)] <- median(data$Bare.nuclei, na.rm = T)

     # may be needed (convert all factors to numeric)
     # is_num <- c("Cl.thickness","Cell.size","Cell.shape","Marg.adhesion","Epith.c.size",
     #           "Bl.cromatin", "Normal.nucleoli", "Mitoses", "Class")
     # data[ , is_num] <- lapply(data[, is_num], as.numeric)

# 3) [2p] Remove ID variable and check the percentage of observations for one chosen class.
data$Id <- NULL
length(data$Class[data$Class == "benign"]) / nrow(data)

# 4) [2p] Divide dataset into training subset and validation subset in relation 2:1.
rand <- sample(1:nrow(data), 2/3 * nrow(data))
train <- data[rand,]
valid <- data[-rand,]

# 5) [2p] Build classification tree using Conditional Inference Tree (ctree) method with parameters mincriterion at the level of 0.99 and minsplit equal to 20. Plot obtained model.
# library(partykit)
library(party)

# train <- as.matrix(train)
ctree.model <-
  ctree(
    Class ~ .,
    data = train,
    controls = ctree_control(mincriterion = 0.99, minsplit = 20)
  )
plot(ctree.model, tnex = 2, type = "extended")
# devAskNewPage(ask = TRUE)

# 6) [2p] Build classification tree using Recursive Partitioning and Regression Trees (rpart) methods with parameters cp at the level of 0.00001 and minsplit equal to 3. Plot chart showing complexity parameter vs. misclassification error. Choose cp with lowest misclassification error.
library(rpart)
rpart.model <- rpart(Class ~ ., train, cp = 0.00001, minsplit = 5)
plotcp(rpart.model)  # Which complexity parmeter gives us the best results

minimum.error <- which.min(rpart.model$cptable[, "xerror"])
minimum.error

optimal.complexity <- rpart.model$cptable[minimum.error, "CP"]
optimal.complexity

points(minimum.error, rpart.model$cptable[minimum.error, "xerror"], col = "red", 
       pch = 19)

#7) [2p] Prune previous classification tree with optimal cp.
pruned.tree <- prune(rpart.model, cp = optimal.complexity)
plot(pruned.tree, compress = T, uniform = T, margin = 0.1, branch = 0.3, nspace = 2)
text(pruned.tree, use.n = TRUE, pretty = 0)

#8) [2p] Build Random Forest model with number of trees at the level of 250.
library(randomForest)
forest<-randomForest(Class ~ ., data = train, ntree = 250, do.trace = T)
par(mfrow = c(2, 1), mar = c(4, 4, 2, 1))
plot(forest,col = "black")
varImpPlot(forest, bg = 11)
# -------------------------------------------------------------

#9) [2p] For all classification trees make prediction on validation subset. Show confusion matrices
#   for every model.
confusion.matrix<-list()
cat("Confusion Matrix - ctree")
print(confusion.matrix[[1]]<-table(predict(ctree.model,new=valid),valid$Class))
ctree_table <- table(predict(ctree.model,new=valid),valid$Class)
cat("\nConfusion Matrix - pruned rpart\n")
print(confusion.matrix[[2]]<-table(predict(pruned.tree,type="class",newdata=valid),valid$Class))
rpart_table <- table(predict(pruned.tree,type="class",newdata=valid),valid$Class)
cat("\nConfusion Matrix - random forest")
print(confusion.matrix[[3]]<-table(predict(forest,newdata= valid),valid$Class))
rf_table <- table(predict(forest,newdata= valid),valid$Class)
cat("\nAccuracy comparison\n")

#10) [2p] Print comparison table which show for every method misclassification error on validation
#subset. Which model is the best?
CalculateAccuracy<-function(confusion.matrix) {return(sum(diag(confusion.matrix))/sum(confusion.matrix))}
print(data.frame(model=c("ctree","pruned rpart","random forest"),accuracy=sapply(confusion.matrix,CalculateAccuracy)),row.names=FALSE)

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

EvaluateModel(ctree_table)
EvaluateModel(rpart_table)
EvaluateModel(rf_table)


# Statistical Learning Methods - Practical test
# Exercise 2 [20p] - Regression problem
# You are manager in baseball team. You are going to build dream team and win the league in the next
# season. The player transfer window is just opening and one determinant which can attract best players
# to your team is the salary. But you have budget limitations and you are going to adjust salaries
# according to player?s skills. For these purpose, build regression model with three regression methods
# (Linear Model, Forward Selection and Ridge Regression) and compare the results. Point the model
# with highest prediction accuracy.
# Before You start:
# 1) Install and load package ?ISLR? {install.packages(?ISLR?), library(ISLR)}.
library(ISLR)

# 2) Load dataset named ?Hitters? {data(Hitters)}.
data("Hitters")
# data <- Hitters

# 3) Set the seed according to the number of your index.
set.seed(83459)

# 4) Keep informed that the endogenous variable is labeled ?Salary?.
# 5) Keep informed that if it is possible to show outcome for mini tasks, just copy (from th
# console) it into MS Word. In case it is not possible, just copy the instruction to MS Word, which
# should lead to achieve results. Before you send the file to artur.pluska.sgh@gmail.com, save
# as PDF. Please, additionally enclose to email your R script.

# To get final results go through mini tasks:
library(mgcv)
library(ROCR)
library(Ecdat)
# install.packages("Ecdat")

#  1) [2p] Plot the chart showing the distribution of Salary variable? Does it have gaussian
# distribution (to determine the distribution use instruction: ?shapiro.test?)?

# dev.off()
hist(Hitters$Salary)
shapiro.test(Hitters$Salary)
?shapiro.test
# p value small so we reject H0 hipothesis that the distribution is normal

# 2) [2p] Does the dataset contains missing values? If yes, impute missing values with average
# value for the given variable. Remove qualitative variables from dataset.

any(is.na(Hitters))
summary(Hitters)
# Kt?re zmienne maj? braki
which(apply(is.na(Hitters), 2, any)==T)

# Hitters$Salary <- as.numeric(data$Salary)
Hitters$Salary[is.na(Hitters$Salary)] <- median(Hitters$Salary, na.rm=T)

any(is.na(Hitters))

# Deleting columns
drops <- c("League", "Division", "NewLeague")
Hitters <- Hitters[ , !(names(Hitters) %in% drops)]

# Hitters<-data.frame(apply(Hitters[,-c(which(sapply(Hitters,is.factor)==T))],2,as.numeric))


# 3) [2p] Divide equally dataset into training, validation and testing subset.
labels<-factor(rep(c("train","validate", "test"),length=nrow(Hitters)))
random.labels<-sample(labels)
head(random.labels)
table(random.labels)
split.data<-split(Hitters,random.labels)
train <- split.data$train
validate <-split.data$validate
test <- split.data$test


# 4) [2p] Identify variables with correlation at least at 0.5 using correlation test (to determine the
# correlation and its significance use instruction: ?cor.test?).
cor.test(Hitters$Salary, Hitters$AtBat) # Y
cor.test(Hitters$Salary, Hitters$Hits) # Y
cor.test(Hitters$Salary, Hitters$HmRun) # Y
cor.test(Hitters$Salary, Hitters$Runs) # Y
cor.test(Hitters$Salary, Hitters$RBI) # Y
cor.test(Hitters$Salary, Hitters$Walks) # Y
cor.test(Hitters$Salary, Hitters$Years) # Y
cor.test(Hitters$Salary, Hitters$CAtBat) # Y
cor.test(Hitters$Salary, Hitters$CHits) # Y
cor.test(Hitters$Salary, Hitters$CHmRun) # Y
cor.test(Hitters$Salary, Hitters$CRuns) # N
cor.test(Hitters$Salary, Hitters$CRBI) # Y
cor.test(Hitters$Salary, Hitters$Walks) # Y
cor.test(Hitters$Salary, Hitters$PutOuts) # Y
cor.test(Hitters$Salary, Hitters$Assists) # Y
cor.test(Hitters$Salary, Hitters$Errors) # Y
?cor.test

#Z tego drugiego pliku
cor(Hitters)
y<-c()

for (i in 1:ncol(Hitters)){
  y[i]<-ifelse(cor.test(Hitters$Salary,Hitters[,i])$p.value<0.05 & as.numeric(cor.test(Hitters$Salary,Hitters[,i])[[4]])!=1,1,0)
  
}

for (i in 1:ncol(Hitters)){
  print(cor.test(Hitters$Salary,Hitters[,i]))
}


#5) [2p] Build regression with GLM on training subset with variables, which have correlation over
# 0,5. Which variables are statistically significant?
glm.model <-
  glm(
    Salary ~ CRuns + Hits + HmRun + Runs + Walks + Years + CAtBat +
      CHits + CHmRun + CRuns + CRBI + CWalks,
    data = train
  )
summary(glm.model)

# Intercept and CRuns
# 6) [2p] Build regression with GAM method on training dataset with all variables.
?gam
gam.model<-glm(Salary ~ ., data=train)
summary(gam.model)


#7) [2p] Visualize (bart chart) the Mean Squared Error on training and validation subsets for
#obtained GLM and GAM regression.
glm.pred_train<-as.vector(predict(glm.model,newdata=train))
glm.pred_validate<-as.vector(predict(glm.model,newdata=validate))
glm.pred_test<-as.vector(predict(glm.model,newdata=test))

gam.pred_train<-as.vector(predict(gam.model,newdata=train))
gam.pred_validate<-as.vector(predict(gam.model,newdata=validate))
gam.pred_test<-as.vector(predict(gam.model,newdata=test))

mse_glm_train<-mean((train$Salary - glm.pred_train)^2)
mse_gam_train<-mean((train$Salary - gam.pred_train)^2)


mse_glm_valid<-mean((validate$Salary - glm.pred_validate)^2)
mse_gam_valid<-mean((validate$Salary - gam.pred_validate)^2)

wykres <-cbind(mse_glm_train, mse_glm_valid, mse_gam_train, mse_gam_valid)
wykres
barplot(wykres)

# 8) [2p] Based on validation subset check, which model is the best. Show its summary.
summary(glm.pred_validate) 
# summary(gam.pred_validate)


#9) [2p] Calculate Mean Squared Error on testing subset for two models. Which model is the best?
mse_glm_test<-mean((test$Salary - glm.pred_test)^2)
mse_gam_test<-mean((test$Salary - gam.pred_test)^2)



# 10) [2p] What the salary would you pay to average player (new exogenous variable is an average
# for every characteristics)? Use the best model, you have obtained.  
prediction<-data.frame(matrix(apply(Hitters[,-ncol(Hitters)] ,2, mean),ncol=16, nrow=1))
colnames(prediction)<-colnames(Hitters[,-17])
predict(glm.model, newdata = prediction, type='response')



