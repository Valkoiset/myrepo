
setwd("~/Desktop/SGH/2 semester/Big data/labs/1")

# 1 ------------------------------------------
library(readxl)

data <- read_excel("1.xlsx")
View(data)

data <- (data[-1])^2

library(openxlsx)
write.xlsx(data, "1.xlsx")

# 2 -----------------------------------------
data2 <- read.csv2("winequality-red.csv")
View(data2)
data2$volatile.acidity <- NULL
data2$chlorides <- NULL

colnames(data2) <- substr(colnames(data2), 1, 2)
View(data2)

library(sqldf)

selected <- sqldf('SELECT * FROM data2 where "qu" in (6, 7)')
View(selected)
