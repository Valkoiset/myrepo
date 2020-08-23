












# The winning of a pawn among good players of even strength often means the
# winning of the game. – Jose Capablanca

# The older I grow, the more I value pawns. – Paul Keres

library(rchess)
library(bigchess)
library(dplyr)
library(ggplot2)
library(readr)
library(plyr)
library(dplyr)
library(nnet)
library(MASS)
library(rpart)
library(caret)
library(randomForest)
library(reshape2)
library(rpart.plot)
library(rattle)
library(gbm)

# clear the workspace, plots and console
rm(list = ls())
if (!is.null(dev.list()))
  dev.off()
cat("\014")

setwd("~/Desktop/SGH/2 semester/Big data/Project/chess")

# Example of loading game directly from package "rchess"
data <-
  system.file("extdata/pgn/kasparov_vs_topalov.pgn", package = "rchess")
data <- readLines(data, warn = FALSE)
data <- paste(data, collapse = "\n")
cat(data)

# f <- system.file("extdata", "Kasparov.gz", package = "bigchess")
# con <- gzfile(f,encoding = "latin1")
# plot(f)

# data <- system.file("ficsgamesdb_200001_chess_nomovetimes_68569.pgn")
game <- Chess$new()
# file <- read.pgn("Hikaru Nakamura_vs_Alireza Firouzja_2019.04.06.pgn")
fen <- "5r1k/pp5p/2pq1bp1/P6n/3p2BQ/1P1N3P/2P2PP1/R5K1 w - - 7 29"
game$load(fen)
plot(game)

# ----- Prediction of a winner based on ELO rating and choice of openings -----
# FIDE World cups
data("chesswc")         # 1266 observations
count(chesswc, event)   # number of events in each World Cup
str(chesswc)
head(chesswc)

# ------------ Feature Engineering ------------
# create an elo_difference column
chesswc <- mutate(chesswc, elo_difference = whiteelo - blackelo)

# get rid of rows where the leo difference is greater than 800
chesswc <- chesswc %>% filter(elo_difference < 800)

# create new columns for adjusted elos
chesswc <- mutate(chesswc, adjusted_white_elo = 0)
chesswc <- mutate(chesswc, adjusted_black_elo = 0)
chesswc <- mutate(chesswc, adjusted_elo_difference = 0)

# create a dataframe with all the elos so we can find the mean and standard deviation
temp_all_elo <- data.frame(chesswc$whiteelo, chesswc$blackelo)
all_elo <- stack(temp_all_elo)
mean_elo <- mean(all_elo[, 1])
sd_elo <- sd(all_elo[, 1])

# find the z-scores and raise e to said z-scores
                               # pnorm - Normal Distribution
chesswc$adjusted_white_elo = exp(pnorm(chesswc$whiteelo, mean_elo, sd_elo))
chesswc$adjusted_black_elo = exp(pnorm(chesswc$blackelo, mean_elo, sd_elo))
chesswc$adjusted_elo_difference = chesswc$adjusted_white_elo - chesswc$adjusted_black_elo

# set win to 1-0, lose to 0-1
win = chesswc$result[1]
lose = chesswc$result[2]

# create a new column named winner that assigns 1-0 to white wins, 0-1 to black
# wins, and 1/2-1/2 to a draw
chesswc = mutate(chesswc,
                 winner = ifelse(result == "1-0", "white",
                                 ifelse(result =="0-1", "black", "draw")))

# make the column a factor
chesswc$winner = as.factor(chesswc$winner)

# a <- "gabella"
# substr(a, 1, 2)   ga

# categorize ECO
chesswc = mutate(chesswc, eco_cat = "A00 - A49")
chesswc$eco_cat[which(as.numeric(substring(chesswc$eco, 2, 4)) < 40 &
                        substring(chesswc$eco, 1, 1) == "A")] = "A00 - A39"
chesswc$eco_cat[which(
  as.numeric(substring(chesswc$eco, 2, 4)) < 45 &
    as.numeric(substring(chesswc$eco, 2, 4)) > 39 &
    substring(chesswc$eco, 1, 1) == "A"
)] = "A40 - A44"
chesswc$eco_cat[which(
  as.numeric(substring(chesswc$eco, 2, 4)) < 50 &
    as.numeric(substring(chesswc$eco, 2, 4)) > 44 &
    substring(chesswc$eco, 1, 1) == "A"
)] = "A45 - A49"
chesswc$eco_cat[which(
  as.numeric(substring(chesswc$eco, 2, 4)) < 80 &
    as.numeric(substring(chesswc$eco, 2, 4)) > 49 &
    substring(chesswc$eco, 1, 1) == "A"
)] = "A50 - A79"
chesswc$eco_cat[which(
  as.numeric(substring(chesswc$eco, 2, 4)) < 100 &
    as.numeric(substring(chesswc$eco, 2, 4)) > 79 &
    substring(chesswc$eco, 1, 1) == "A"
)] = "A80 - A99"
chesswc$eco_cat[which(as.numeric(substring(chesswc$eco, 2, 4)) < 10 &
                        substring(chesswc$eco, 1, 1) == "B")] = "B00 - B09"
chesswc$eco_cat[which(
  as.numeric(substring(chesswc$eco, 2, 4)) < 20 &
    as.numeric(substring(chesswc$eco, 2, 4)) > 9 &
    substring(chesswc$eco, 1, 1) == "B"
)] = "B10 - B19"
chesswc$eco_cat[which(
  as.numeric(substring(chesswc$eco, 2, 4)) < 100 &
    as.numeric(substring(chesswc$eco, 2, 4)) > 19 &
    substring(chesswc$eco, 1, 1) == "B"
)] = "B20 - B99"
chesswc$eco_cat[which(as.numeric(substring(chesswc$eco, 2, 4)) < 20 &
                        substring(chesswc$eco, 2, 2) == "C")] = "C00 - C19"
chesswc$eco_cat[which(
  as.numeric(substring(chesswc$eco, 2, 4)) < 100 &
    as.numeric(substring(chesswc$eco, 2, 4)) > 19 &
    substring(chesswc$eco, 1, 1) == "C"
)] = "C20 - C99"
chesswc$eco_cat[which(as.numeric(substring(chesswc$eco, 2, 4)) < 70 &
                        substring(chesswc$eco, 1, 1) == "D")] = "D00 - D69"
chesswc$eco_cat[which(
  as.numeric(substring(chesswc$eco, 2, 4)) < 100 &
    as.numeric(substring(chesswc$eco, 2, 4)) > 69 &
    substring(chesswc$eco, 1, 1) == "D"
)] = "D70 - D99"
chesswc$eco_cat[which(as.numeric(substring(chesswc$eco, 2, 4)) < 60 &
                        substring(chesswc$eco, 1, 1) == "E")] = "E00 - E59"
chesswc$eco_cat[which(
  as.numeric(substring(chesswc$eco, 2, 4)) < 100 &
    as.numeric(substring(chesswc$eco, 2, 4)) > 59 &
    substring(chesswc$eco, 1, 1) == "E"
)] = "E60 - E99"

# create our final save point, remove all the variables in the global environment
# (otherwise we’ll run out of memory), and take a look at what we’ve made.

# save point
write.csv(chesswc, file = "chess.csv", row.names = FALSE)

# clear memory
rm(list = ls())
# ---------------------------------------------------------------------------
# load the data after check point
chess = read.csv("chess.csv")
head(chess)

# --------------------- Data Exploration ---------------------
library(ggplot2)
ggplot(data = chess, aes(x = adjusted_elo_difference, y = winner)) + geom_point()

# white wins percentage
length(which(chess$winner == "white")) / length(chess$winner) # 0.3061709

# draw percentage
length(which(chess$winner == "draw")) / length(chess$winner)  # 0.4992089

# black wins percentage
length(which(chess$winner == "black")) / length(chess$winner) # 0.1946203

# Now check out the distribution of adjusted_elo_differences and make sure
# it isn’t skewed so that white tends to be better. Looks normally distributed
# around 0.
hist(chess$elo_difference)

  # does it really make sense???))
  gg <- ggplot(chess)
  gg + geom_histogram(data = chess, aes(elo_difference, fill = winner))
  
# ------------------------------------------------------------
# ------------------------ Modelling -------------------------
# ------------------------------------------------------------
# Since we have three levels in our outcome, we can’t use logistic regression,
# and instead have to use multinomial regression

# dividing data on training and validation datasets
set.seed(713)
rand <- sample(1:nrow(chess), 0.7 * nrow(chess))
train <- chess[rand, ]
valid <- chess[-rand, ]

# ----------- create Multinom model for training set -----------
# fit <-
#   multinom(
#     winner ~ adjusted_elo_difference + eco_cat + adjusted_white_elo +
#       adjusted_black_elo,
#     train
#   )
#
# # Get rid of variables that hurt the model, interestingly removed adjusted_white_elo but not black
# fit <- stepAIC(fit, direction = "both")
#
# # Create prediction
# prediction <- predict(fit, valid, "probs")
#
# # Since predict for multinom returns probabilities that each outcome occurs, we have to find the maximum value in each row, and figure out that value's column
# predicted_winner = data.frame(winner = prediction[, 1])
# predicted_winner[, 1] <-
#   colnames(prediction)[apply(prediction, 1, which.max)]
#
# # now we run a confusion matrix to figure out the accuracy for the training data set
# confusionMatrix(predicted_winner[, 1], valid$winner, positive = "white") # ???
#



# --- GBM ---
# 5 folds cross validiation
fitControl <-
  trainControl(method = "repeatedcv",
               number = 5,
               repeats = 1)

# generate GBM model
fit <-
  train(
    winner ~ adjusted_elo_difference + eco_cat  + adjusted_white_elo +
      adjusted_black_elo,
    data = train,
    method = "gbm",
    trControl = fitControl,
    verbose = FALSE
  )

# accuracy for training data
confusionMatrix(predict(fit, newdata = train), train$winner) # 55.4%

# use model to predict for our test data
predict <- predict(fit, newdata = valid)

# find accuracy of test data
confusionMatrix(predict, valid$winner) # 55.3%
# Conclusion: 55.3% accuracy on validation data - not the best result,
# let's look at the next model

# --- Decisioin tree ---

# cross validation      ???
fit <-
  train(
    winner ~ adjusted_elo_difference + eco_cat + adjusted_white_elo + adjusted_black_elo,
    data = chess,
    method = "rpart",
    trControl = trainControl(
      method = "repeatedcv",
      verboseIter = TRUE,
      number = 10
    )
  )
# once again, less than 1% variability in accuracy

# We include adjusted_white_elo and adjusted_black_elo because we want it to be
# greedy, and because there's a small chance that they may influence the game
# outcome despite being captured in adjusted_elo_difference

# generate  model
fit <-
  rpart(
    winner ~ adjusted_elo_difference + eco_cat + adjusted_white_elo + adjusted_black_elo,
    method = "class",
    data = train
  )

RPART.1 <-
  rpart(
    winner ~ adjusted_elo_difference + eco_cat +
      adjusted_white_elo + adjusted_black_elo,
    data = train,
    cp = 0.00001
  ) # cp - complexity parameter. larger cp - simplier tree
plotcp(RPART.1)
printcp(RPART.1)  # Pruning Table
RPART.1           # Tree Leaf Summary

# draw plot with text
par(mar = c(1, 1, 1, 1))
plot(RPART.1)
text(RPART.1)

# To obtain more smart diagram the function fancyRpartPlot from rattle package can be used
fancyRpartPlot(RPART.1)

pred2 <- predict(RPART.1, newdata = valid)
pred2 <- round(pred2, 0)
# typeof(valid$winner)
valid$winner[1]
# valid$winner = as.character(valid$winner)
valid$winner[1]
valid %>% (winner == "black") = 0
valid$winner[valid$winner == "black"] = 0
valid$winner[valid$winner == "white"] = 1
valid$winner[valid$winner == "draw"] = 0.5
ifelse(valid$winner[valid$winner == "black"], 0,
       ifelse(valid$winner[valid$winner == "black"], 1, 0.5))
typeof(valid$winner)
valid$winner = as.numeric(valid$winner)

result2 <- data.frame(pred2, valid$winner)
error2 <- sum(abs(pred2 - valid$winner))
error2

# -----------------------------------------------------

#same deal as the other two cross validiation models      ???
fit <-
  train(
    winner ~ adjusted_elo_difference + eco_cat + adjusted_white_elo + adjusted_black_elo,
    data = chess,
    method = "randomForest",
    trControl = trainControl(
      method = "repeatedcv",
      verboseIter = TRUE,
      number = 10
    )
  )

# Generate model, can't run because too large for Rmarkdown
fit <-
  randomForest(
    winner ~ adjusted_elo_difference + eco_cat + adjusted_white_elo + adjusted_black_elo,
    method = "class",
    data = train
  )

# generate predictions
predict_fit = predict(fit, train)
predicted_winner = data.frame(winner = predict_fit[, 1])

  # this part doesn't work((
  # #find column names for which probability of winning is greatest
  predicted_winner[, 1] = colnames(predict_fit)[apply(predict_fit, 1, which.max)]
  
  # accuracy for train data
  confusionMatrix(predicted_winner[, 1], train$winner, positive = "white")

# accuracy for test data
test_prediction <- predict(fit, valid)
test_predicted_winner = data.frame(winner = test_prediction[, 1])

  # this part doesn't work((
  test_predicted_winner[, 1] = colnames(test_prediction)[apply(test_prediction,
                                                               1, which.max)]
  confusionMatrix(test_predicted_winner[, 1], valid$winner, positive = "white")
  