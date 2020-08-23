# loading the required packages
require(randomForest)
require(MASS) #Package which contains the Boston housing dataset
attach(Boston)
set.seed(101)

View(Boston)
dim(Boston)

# Saperating Training and Test Sets
#training Sample with 300 observations
train=sample(1:nrow(Boston),300)
?Boston  #to search on the dataset

# We are going to use variable ′medv′ as the Response variable, which is the 
# Median Housing Value. We will fit 500 Trees.
# We will use all the Predictors in the dataset.

Boston.rf=randomForest(medv ~ . , data = Boston , subset = train)
Boston.rf

plot(Boston.rf)

# The above Random Forest model chose Randomly 4 variables to be considered at 
# each split. We could now try all possible 13 predictors which can be 
# found at each split.

oob.err=double(13)
test.err=double(13)
