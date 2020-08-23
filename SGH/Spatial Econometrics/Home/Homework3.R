

library(sf)
library(rgdal)
library(spdep)

# Homework 3

setwd("~/Desktop/SGH/2 semester/Spatial Econometrics/Spatial Econometrics")

# loading data
spatial_data <- readOGR(dsn="spatial_data", layer="spatial_final", stringsAsFactors = F)

# For the variable illustrated in the first homework, run the following
# procedures and interpret their results:

sgh_green <- rgb(13, 85, 72, 160, names = NULL, maxColorValue = 255)

#LINEAR MODEL ESTIMATED VIA OLS
model.liniowy <- lm(spatial_data$Fertlty ~ spatial_data$Crimes)
summary(model.liniowy)

# 1) Visual assessment

#GRAPHICAL EVALUATION
spatial_data$res <- model.liniowy$residuals
green_area <- rgb(24, 121, 104, 80, names = NULL, maxColorValue = 255)
pal <- colorRampPalette(c("red", "white", green_area), bias = 1.0)

quartz()
spplot(spatial_data, zcol = "res", colorkey = TRUE, col.regions = pal(100), cuts = 99,
       par.settings = list(axis.line = list(col =  'transparent')),
       main = "Crimes to Fertility")

# 2) Global and local Moran's tests

#GLOBAL MORAN'S TEST FOR RESIDUALS
cont1 <- poly2nb(spatial_data, queen = T)
W1_list <- nb2listw(cont1, style = "W", zero.policy = T)
lm.morantest(model.liniowy, W1_list, alternative = "greater")
res <- model.liniowy$residuals
moran.plot(res, W1_list, ylab = "Spatial lag of residuals: W*e", xlab = "Residuals: e", pch = 20, main = "Moran's plot", col = sgh_green)

#Local Moran's tests
localmoran(res, W1_list, p.adjust.method = "bonferroni")

#The same for a variable (not necessarily for residuals)
moran(res, W1_list, length(W1_list$neighbours), length(W1_list$neighbours))
moran.test(res, W1_list, zero.policy = T)

# 3) Geary's test.

#Geary's C test
geary.test(res, W1_list, zero.policy = T)

# 4) Divide the values of the variable into two classes (choose some
#    sensible threshold), and run the join count test. Look at the
#    sensitivity to the choice of threshold value.

#Join count tests
joincount.test(as.factor(res > 0), listw = W1_list, zero.policy = T)

