Statistical Learning Methods - Practical test
Exercise 1 [20p] - Classification problem
You are quantitative analyst in medical center. You were asked to help medical staff in decision making
process to classify patients with breast cancer into two different therapies. For this purpose, build
three concurrent classification models (using Conditional Inference Tree method, Recursive
                                        Partitioning and Regression Trees method and Random Forest method) and choose the best one with
highest prediction accuracy.

Before You start:
#  1) Install and load package “mlbench” {install.packages(“mlbench”), library(mlbench)}.

install.packages("mlbench")
library(mlbench)

#2) Load dataset named “BreastCancer” {data(BreastCancer)}.

data("BreastCancer")

#3) Set the seed according to the number of your index.
set.seed(68044)

#4) Keep informed that the endogenous variable is labeled “Class”.
#5) Keep informed that if it is possible to show outcome for mini tasks, just copy (from console) it
#into MS Word. In case it is not possible, just copy the instruction to MS Word, which should
#lead to achieve results. Before you send the file to artur.pluska.sgh@gmail.com, save as PDF.
#Please, additionally enclose to email your R script.
#To get final results go through mini tasks:
 

# 1) [2p] How many exogenous variables and observations dataset have? What type of object this
#data set is?

data <- BreastCancer
summary(data)
class(data)

#Obs --> 699
#Variables --> 11 or 10? 
# 2) [2p] Does the dataset contains missing values? If yes, impute missing values with method, that
#you are free to choose (e.g. average, median, regression of other variables, removing these
#                       observations, coding as a separate value, etc.).

#It contains missing values
#Zamiana na œredni¹
sum(is.na(data))
summary(data)
data$Bare.nuclei <- is.numeric(data$Bare.nuclei)
data$Bare.nuclei[is.na(data$Bare.nuclei)] <- mean(data$Bare.nuclei, na.rm=T)

sum(is.na(data))

#Usuniêcie 


#3) [2p] Remove ID variable and check the percentage of observations for one chosen class.

drops <- c("Id")
data <- data[ , !(names(data) %in% drops)]

length(which(data$Class=='benign'))/nrow(data)



#4) [2p] Divide dataset into training subset and validation subset in relation 2:1.
set.seed(68044)
train_proportion <- 2/3
train_index <- runif(nrow(data)) < train_proportion
train <- data[train_index,]
test <- data[!train_index,]


#5) [2p] Build classification tree using Conditional Inference Tree (ctree) method with parameters
#mincriterion at the level of 0.99 and minsplit equal to 20. Plot obtained model.
ctree.model<-ctree(factor(class)~.,data=train,controls=ctree_control(mincriterion=0.99,minsplit=20))
plot(ctree.model,tnex=2,type="extended")
devAskNewPage(ask = TRUE)


#6) [2p] Build classification tree using Recursive Partitioning and Regression Trees (rpart) methods
#with parameters cp at the level of 0.00001 and minsplit equal to 5. Plot chart showing
#complexity parameter vs. misclassification error. Choose cp with lowest misclassification
#error.

rpart.model<-rpart(class~.,train,cp=0.00001,minsplit=5)
plotcp(rpart.model)  #Which complexity parmeter gives us the best results

minimum.error<-which.min(rpart.model$cptable[,"xerror"])
minimum.error

optimal.complexity<-rpart.model$cptable[minimum.error,"CP"]
optimal.complexity

points(minimum.error,rpart.model$cptable[minimum.error,"xerror"],col="red",pch=19)

#7) [2p] Prune previous classification tree with optimal cp.

pruned.tree<-prune(rpart.model,cp=optimal.complexity)
plot(pruned.tree,compress=T, uniform=T,margin=0.1,branch=0.3,nspace=2)
text(pruned.tree,use.n=TRUE,pretty=0)

#8) [2p] Build Random Forest model with number of trees at the level of 250.

forest<-randomForest(class~.,data=train,ntree=250,do.trace=T)
par(mfrow=c(3,1),mar=c(4,4,2,1))
plot(forest,col="black") #How the error changes when we increase the number of trees
varImpPlot(forest,bg=11) #What has the highest importance --> 
plot(margin(forest,sort=TRUE),ylim=c(-1,1),ylab="margin")


#9) [2p] For all classification trees make prediction on validation subset. Show confusion matrices
#for every model.

confusion.matrix<-list()
cat("Confusion Matrix - ctree")
print(confusion.matrix[[1]]<-table(predict(ctree.model,new=test),test$class))
ctree_table <- table(predict(ctree.model,new=test),test$class)
cat("\nConfusion Matrix - pruned rpart\n")
print(confusion.matrix[[2]]<-table(predict(pruned.tree,type="class",newdata=test),test$class))
rpart_table <- table(predict(pruned.tree,type="class",newdata=test),test$class)
cat("\nConfusion Matrix - random forest")
print(confusion.matrix[[3]]<-table(predict(forest,newdata= test),test$class))
rf_table <- table(predict(forest,newdata= test),test$class)
cat("\nAccuracy comparison\n")

#10) [2p] Print comparison table which show for every method misclassification error on validation
#subset. Which model is the best?

CalculateAccuracy<-function(confusion.matrix) {return(sum(diag(confusion.matrix))/sum(confusion.matrix))}
print(data.frame(model=c("ctree","pruned rpart","random forest"),dokladnosc=sapply(confusion.matrix,CalculateAccuracy)),row.names=FALSE)

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

  
#Statistical Learning Methods - Practical test
#Exercise 2 [20p] - Regression problem
#You are manager in baseball team. You are going to build dream team and win the league in the next
#season. The player transfer window is just opening and one determinant which can attract best players
#to your team is the salary. But you have budget limitations and you are going to adjust salaries
#according to player’s skills. For these purpose, build regression model with three regression methods
#(Linear Model, Forward Selection and Ridge Regression) and compare the results. Point the model
#with highest prediction accuracy.
#Before You start:
#1) Install and load package “ISLR” {install.packages(“ISLR”), library(ISLR)}.
library(ISLR)

#2) Load dataset named “Hitters” {data(Hitters)}.
data("Hitters")

#3) Set the seed according to the number of your index.
set.seed(68044)

#4) Keep informed that the endogenous variable is labeled “Salary”.
#5) Keep informed that if it is possible to show outcome for mini tasks, just copy (from th
# console) it into MS Word. In case it is not possible, just copy the instruction to MS Word, which
# should lead to achieve results. Before you send the file to artur.pluska.sgh@gmail.com, save
# as PDF. Please, additionally enclose to email your R script.

#To get final results go through mini tasks:

library(mgcv)
library(ROCR)
library(Ecdat)
install.packages("Ecdat")

#  1) [2p] Plot the chart showing the distribution of Salary variable? Does it have gaussian
# distribution (to determine the distribution use instruction: “shapiro.test”)?
  
hist(Hitters$Salary)
shapiro.test(Hitters$Salary)
?shapiro.test
#p value small so we reject H0 hipothesis that the distribution is normal

#2) [2p] Does the dataset contains missing values? If yes, impute missing values with average
#value for the given variable. Remove qualitative variables from dataset.

sum(is.na(Hitters))
summary(Hitters)
#Które zmienne maj¹ braki
which(apply(is.na(Hitters), 2, any)==T)

Hitters$Salary <- is.numeric(data$Bare.nuclei)
Hitters$Salary[is.na(Hitters$Salary)] <- mean(Hitters$Salary, na.rm=T)

sum(is.na(Hitters))

#Usuniêcie 

drops <- c("League", "Division", "NewLeague")
Hitters <- Hitters[ , !(names(Hitters) %in% drops)]

Hitters2<-data.frame(apply(Hitters[,-c(which(sapply(Hitters,is.factor)==T))],2,as.numeric))


#3) [2p] Divide equally dataset into training, validation and testing subset.

labels<-factor(rep(c("train","validate", "test"),length=nrow(Hitters)))
random.labels<-sample(labels)
head(random.labels)
table(random.labels)
split.data<-split(Hitters,random.labels)
train <- split.data$train
validate <-split.data$validate
test <- split.data$test


#4) [2p] Identify variables with correlation at least at 0.5 using correlation test (to determine the
#correlation and its significance use instruction: “cor.test”).

cor.test(Hitters$Salary, Hitters$AtBat) #NIE
cor.test(Hitters$Salary, Hitters$Hits) #NIE
cor.test(Hitters$Salary, Hitters$HmRun) #NIE
cor.test(Hitters$Salary, Hitters$Runs) #NIE
cor.test(Hitters$Salary, Hitters$RBI) #NIE
cor.test(Hitters$Salary, Hitters$Walks) #NIE
cor.test(Hitters$Salary, Hitters$Years) #NIE
cor.test(Hitters$Salary, Hitters$CAtBat) #NIE
cor.test(Hitters$Salary, Hitters$CHits) #NIE
cor.test(Hitters$Salary, Hitters$CHmRun) #NIE
cor.test(Hitters$Salary, Hitters$CRuns) #Tak
cor.test(Hitters$Salary, Hitters$CRBI) #NIE
cor.test(Hitters$Salary, Hitters$Walks) #NIE
cor.test(Hitters$Salary, Hitters$PutOuts) #NIE
cor.test(Hitters$Salary, Hitters$Assists) #NIE
cor.test(Hitters$Salary, Hitters$Errors) #NIE
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
#0,5. Which variables are statistically significant?
 
glm.model<-glm(Salary ~ CRuns,data=train)
summary(glm.model)

#Intercept and CRuns

# 6) [2p] Build regression with GAM method on training dataset with all variables.
?gam
gam.model<-glm(Salary ~ . ,data=train)
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

#8) [2p] Based on validation subset check, which model is the best. Show its summary.
summary(glm.pred_validate) 
summary(gam.pred_validate)


#9) [2p] Calculate Mean Squared Error on testing subset for two models. Which model is the best?

  mse_glm_test<-mean((test$Salary - glm.pred_test)^2)
  mse_gam_test<-mean((test$Salary - gam.pred_test)^2)
  
  
  
# 10) [2p] What the salary would you pay to average player (new exogenous variable is an average
# for every characteristics)? Use the best model, you have obtained.  

dane_prognoza<-data.frame(matrix(apply(Hitters[,-ncol(Hitters)] ,2, mean),ncol=16, nrow=1))
colnames(dane_prognoza)<-colnames(Hitters[,-17])
predict(glm.model, newdata = dane_prognoza, type='response', se=F)





#8. Na podstawie zbioru walidacyjnego sprawdz, który model jest lepszy, czy regresja GLM, czy regresja GAM. 
# Dla najlepszego modelu pokaz tabulogram. Jakie zmienne wchodza do najlepszego modelu?
#porownanie gam vs. glm
library(mgcv)

fmla <- as.formula(paste("Salary ~ .", paste('s(',colnames(train)[-ncol(train)], ')', collapse= "+")))

gam.model <- gam(fmla, data=train)
podsumowanie<-summary(mod_gam2)
fits = predict(mod_gam2, newdata=valid_hitters2, type='response', se=F)
mse_gam<-mean((valid_hitters2$Salary - fits)^2)
#lepszy jest model GAM  