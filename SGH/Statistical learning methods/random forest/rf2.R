

library(dplyr)

data_train <- read.csv("https://raw.githubusercontent.com/thomaspernet/data_csv_r/master/data/titanic_train.csv") %>%
  select(-1)
data_test <- read.csv("https://raw.githubusercontent.com/thomaspernet/data_csv_r/master/data/titanic_test.csv") %>%
  select(-1)

library(randomForest)
library(caret)
library(e1071)

# Define the control
trControl <- trainControl(method = "cv",
                          number = 10,
                          search = "grid")

set.seed(1234)
# Run the model
rf_default <- train(survived~.,
                    data = data_train,
                    method = "rf",
                    metric = "Accuracy",
                    trControl = trControl)
# Print the results
print(rf_default)
