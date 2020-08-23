library(shiny)
library(tidyverse)

gun.violence <- read.csv("/Users/Valkoiset/Desktop/SGH/Data Visualisation/R/Project/gunViolence/gun-violence-data_01-2013_03-2018.csv")
gun.violence <- as.tibble(gun.violence)
gun.violence

