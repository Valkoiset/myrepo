

library('BCA')
library('car')
library('RcmdrMisc')
library('sandwich')
library('relimp')
library(corrplot)

setwd("~/Desktop/SGH/2 semester/Big data/labs/3")

hour <- read.csv("hour.csv")
day <- read.csv("day.csv")

                          # HOUR
hour$dteday <- NULL

# Check variables
variable.summary(hour)
corr <- cor(hour)
corrplot(corr, method = "number")

# Converting some variables into factor
hour$yr <- as.factor(hour$yr)
hour$season <- as.factor(hour$season)
hour$holiday <- as.factor(hour$holiday)
hour$mnth <- as.factor(hour$mnth)
hour$workingday <- as.factor(hour$workingday)
hour$weathersit <- as.factor(hour$weathersit)

# Regression model
# before excluding some variables
hour.model <- lm(cnt ~ season + yr + mnth + hr + holiday + weekday + workingday +
                   weathersit + atemp + temp + hum + windspeed + casual + registered, data = hour)
summary(hour.model)
Anova(hour.model)

# after excluding
hour.model <- lm(cnt ~ season + yr + mnth + hr + holiday + weekday +
                   weathersit + temp + hum + windspeed, data = hour)
summary(hour.model)
Anova(hour.model)

# Non linear model
# checking if there any values = 0
any(hour$temp == 0)
any(hour$hum == 0)
any(hour$cnt == 0)

# changing all 0 values to very close to 0
hour$hum[hour$hum == 0] <- 1*10^-10
hour$windspeed[hour$windspeed == 0] <- 1*10^-10

# Logarithm of continuous variables
hour$log.temp <- with(hour, log(temp))
hour$log.hum <- with(hour, log(hum))
hour$log.cnt <- with(hour, log(cnt))
hour$log.windspeed <- with(hour, log(windspeed))

# Building non linear model
Non.LinearModel <- lm(log.cnt ~ season + yr + mnth + hr + holiday + weekday +
                      weathersit + log.temp + log.hum + log.windspeed, data = hour)
summary(Non.LinearModel)

                            # DAY
day$dteday <- NULL

variable.summary(day)
corr <- cor(day)
corrplot(corr, method = "number")

# Converting some variables into factor
day$yr <- as.factor(day$yr)
day$season <- as.factor(day$season)
day$holiday <- as.factor(day$holiday)
day$mnth <- as.factor(day$mnth)
day$workingday <- as.factor(day$workingday)
day$weathersit <- as.factor(day$weathersit)

# Regression model
# before excluding some variables
day.model <- lm(cnt ~ season + yr + mnth + holiday + weekday + workingday +
                  weathersit + atemp  + hum + windspeed + casual + registered, data = day)
summary(day.model)

# after excluding
day.model <- lm(cnt ~ season + yr + mnth + holiday + weekday +
                  weathersit + temp + hum + windspeed, data = day)
summary(day.model)
Anova(day.model)

# Non linear model
# checking if there any values = 0
any(day$temp == 0)
any(day$hum == 0)
any(day$cnt == 0)

# changing all 0 values to very close to 0
day$hum[day$hum == 0] <- 1*10^-10
day$windspeed[day$windspeed == 0] <- 1*10^-10

# Logarithm of continuous variables
day$log.temp <- with(day, log(temp))
day$log.hum <- with(day, log(hum))
day$log.cnt <- with(day, log(cnt))
day$log.windspeed <- with(day, log(windspeed))

# Building non linear model
Non.LinearModel2 <- lm(log.cnt ~ season + yr + mnth + holiday + weekday +
                      weathersit + log.temp + log.hum + log.windspeed, data = day)
summary(Non.LinearModel2)
Anova(Non.LinearModel2)
