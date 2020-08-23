#INSTALLING PACKAGES (previously installed packages commented - please uncomment if necessary)
# install.packages("rgdal")
# install.packages("sp")
# install.packages("spdep")

#SET WORKING DIRECTORY
setwd("C:/Users/Oleksandr/Desktop/Spatial Econometrics/3 lesson")

# clear the workspace, plots and console
rm(list = ls())
if(!is.null(dev.list())) dev.off()
cat("\014") 

library(rgdal)
library(sp)
library(spdep)


#Re-run the code from the previous class
mapa <- readOGR(".", "powiaty")
mapa <- spTransform(mapa, "+proj=longlat")
dane <- read.csv("BDL_dane.csv", header = TRUE, sep = ";", dec = ",")
mapa@data$kod <- as.numeric(as.character(mapa@data$jpt_kod_je))
spatial_data <- merge(y = dane, x = mapa, by.y = "kod", by.x = "kod")
rm(mapa)
rm(dane)
sgh_green <- rgb(13, 85, 72, 160, names = NULL, maxColorValue = 255)

#LINEAR MODEL ESTIMATED VIA OLS
spatial_data$produkcja.pc <- spatial_data$produkcja / spatial_data$liczba_ludnosci
model.liniowy <- lm(spatial_data$bezrobocie ~ spatial_data$produkcja.pc)
summary(model.liniowy)

#GRAPHICAL EVALUATION
spatial_data$res <- model.liniowy$residuals
green_area <- rgb(24, 121, 104, 80, names = NULL, maxColorValue = 255)
pal <- colorRampPalette(c("red", "white", green_area), bias = 1.4)
#Put 3 colors into the map, "white" in the middle of the palette, play around with the bias other than 1 so as to plot the near-zero residuals as white
spplot(spatial_data, zcol = "res", colorkey = TRUE, col.regions = pal(100), cuts = 99,
       par.settings = list(axis.line = list(col =  'transparent')),
       main = "Unemployment")

#GLOBAL MORAN'S TEST FOR RESIDUALS
cont1 <- poly2nb(spatial_data, queen = T)
W1_list <- nb2listw(cont1, style = "W")
lm.morantest(model.liniowy, W1_list, alternative = "greater")
res <- model.liniowy$residuals
moran.plot(res, W1_list, ylab = "Spatial lag of residuals: W*e", xlab = "Residuals: e", pch = 20, main = "Moran's plot", col = sgh_green)

#The same vor a variable (not necessarily for residuals)
moran(res, W1_list, length(W1_list$neighbours), length(W1_list$neighbours)) #Only I statistic and kurtosis of residuals
moran.test(res, W1_list) #Test statistic with p-value

#Geary's C test
geary.test(res, W1_list)

#Local Moran's tests
localmoran(res, W1_list, p.adjust.method = "bonferroni")

#Join count tests
joincount.test(as.factor(res > 0), listw = W1_list)

#Tests with specified alternative hypotheses
lm.LMtests(model.liniowy, listw = W1_list, test = "all")