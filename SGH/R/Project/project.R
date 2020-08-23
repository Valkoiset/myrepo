
library(tidyverse)
library(psych)

loan <- read.csv("/Users/Valkoiset/Desktop/SGH/Data Visualisation/R/Project/loan.csv")
loan
loan <- as.tibble(loan)
loan
describe(loan)
