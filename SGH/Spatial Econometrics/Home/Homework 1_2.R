

library(eurostat)
library(dplyr)
library(ggplot2)
library(stringr)
library(rgdal)
library(sp)
library(sf)
library(RColorBrewer)
library(spdep)

rm(list = ls())
if(!is.null(dev.list())) dev.off()
cat("\014") 

setwd("~/Desktop/SGH/2 semester/Spatial Econometrics/Spatial Econometrics")

# Homework 1

# data1: Live births (total) by NUTS 3 region. Live births are the births of children
# that showed any sign of life
data <- read.csv("demo_r_births_1_Data.csv")

#import map 2 - many levels and countries at a time
# Since its reunification in 1990, the new Germany has consisted of 16 federal states. 
map <- readOGR(".", "NUTS_RG_01M_2013")
map <- spTransform(map, "+proj=longlat")

#select Germany
map@data$NUTS_ID_char <- as.character(map@data$NUTS_ID)
map@data$country <- substr(map@data$NUTS_ID_char, 1, 2) 
map <- map[map@data$country == "DE", ]

# merge
map@data$GEO <- map@data$NUTS_ID
spatial_data <- merge(y = data, x = map, by.y = "GEO", by.x = "GEO")
color <- rgb(251, 155, 68, 160, names = NULL, maxColorValue = 255)
pal <- colorRampPalette(c("white", color), bias = 1)
spatial_data@data$Value <- as.numeric(spatial_data@data$Value)
# rm(map)
# rm(data)

quartz()
spplot(spatial_data, zcol = "Value", colorkey = TRUE, col.regions = pal(100), cuts = 99,
       par.settings = list(axis.line = list(col =  'transparent')),
       main = "Live births (total) by NUTS 3 region")
# ---------------------------------------------------------------------

# Homework 2

# data2: Crimes recorded by the police by NUTS 3 regions (crim_gen_reg)
data2 <- read.csv("crim_gen_reg_1_Data.csv")

# data3: Population density by NUTS 3 region
data3 <- read.csv("demo_r_d3dens_1_Data.csv")

# data4: Deaths (total) by NUTS 3 region
data4 <- read.csv("demo_r_deaths_1_Data.csv")

# gathering all data together
colnames(data2) [colnames(data2) == "Value"] <- "Value2"
colnames(data3) [colnames(data3) == "Value"] <- "Value3"
colnames(data4) [colnames(data4) == "Value"] <- "Value4"

data_merged <- left_join(data, data2, by = "GEO")
data_merged <- left_join(data_merged, data3, by = "GEO")
data_merged <- left_join(data_merged, data4, by = "GEO")
data_merged <- data.frame(data_merged$GEO,
                          data_merged$Value,
                          data_merged$Value2,
                          data_merged$Value3,
                          data_merged$Value4)

colnames(data_merged) <- c("GEO", "Value", "Value2", "Value3", "Value4")

map@data <- left_join(map@data, data_merged, by = "GEO")
spatial_data <- map
spatial_data@data$Value <- as.numeric(spatial_data@data$Value)
spatial_data@data$Value2 <- as.numeric(spatial_data@data$Value2)
spatial_data@data$Value3 <- as.numeric(spatial_data@data$Value3)
spatial_data@data$Value4 <- as.numeric(spatial_data@data$Value4)

# Remove all NA's in rows (and associated points)
sp.na.omit <- function(spatial_data, margin=1) {
  if (!inherits(spatial_data, "SpatialPointsDataFrame") & 
      !inherits(spatial_data, "SpatialPolygonsDataFrame")) 
    stop("MUST BE sp SpatialPointsDataFrame OR SpatialPolygonsDataFrame CLASS OBJECT") 
  na.index <- unique(as.data.frame(which(is.na(spatial_data@data),
                                         arr.ind=TRUE))[,margin])
  if(margin == 1) {  
    cat("DELETING ROWS: ", na.index, "\n") 
    return( spatial_data[-na.index,]  ) 
  }
  if(margin == 2) {  
    cat("DELETING COLUMNS: ", na.index, "\n") 
    return( spatial_data[,-na.index]  ) 
  }
}
spatial_data <- sp.na.omit(spatial_data)

# preparing variables
centroids <- coordinates(spatial_data)
N <- nrow(spatial_data)
par(mar = c(0, 0, 0, 0))
plot(spatial_data)
points(centroids, pch = 16, col = color, cex = .8)

# For the spatial dataset considered in the first homework, build three
# additional W matrices:

# 1) neighbourhood (order 1), but normalised with the highest
#    eigenvalue (tip: you can do it with the matrix immediately, and then
#    transform it into listw without normalisation).
cont1 <- poly2nb(spatial_data, queen = T)
W1_list <- nb2listw(cont1, style = "C", zero.policy = TRUE)
W1 <- listw2mat(W1_list)
plot.nb(cont1, centroids, col = color, pch = 16, add = TRUE)

# 2) based on inverted squared distances, but only up to 200 km (above
#    that - no link at all).
library(geospacom)
distance <- DistanceMatrix(spatial_data, "GEO", unit = 1000)
gamma <- 2
W3 <- 1 / (distance ^ gamma)
diag(W3) <- 0 # reset zero to diagonal to avoid infinity in computing inverse
for(ii in 1:N) {
  for(jj in 1:N) {
    if (W3[ii,jj] <= 1/(200^2)) W3[ii,jj] <- 0
  }
}
W3 <- W3 / as.matrix(rowSums(W3)) %*% matrix(1, nrow = 1, ncol = N)
W3[is.na(W3)] <- 0
W3_list <- mat2listw(W3, style="W")
plot(spatial_data)
plot.nb(W3_list$neighbours, centroids, col = color, pch = 16, cex = 0.8)

# 3) based on Euclidian distance between 3 standardised variables for
#    pairs of regions i, j
distance3 <- matrix(0, nrow = N, ncol = N)
for(ii in 1:N) {
  for(jj in 1:N) {
    distance3[ii, jj] <- sqrt(
      (spatial_data@data$Values2[ii] - spatial_data@data$Values2[jj])^2 +
      (spatial_data@data$Values3[ii] - spatial_data@data$Values3[jj])^2 +
      (spatial_data@data$Values4[ii] - spatial_data@data$Values4[jj])^2
    )
  }
}
gamma <- 1
W6 <- 1 / (distance3 ^ gamma)
diag(W6) <- 0
W6 <- W6 /as.matrix(rowSums(W6)) %*% 
  matrix(1, nrow = 1, ncol = N)
W6[is.na(W3)] <-0
W6_list <- mat2listw(W6, style = "W")

# -------------------------------------------------------------
# Homework 3

# For the variable illustrated in the first homework, run the following
# procedures and interpret their results:
# 1) Visual assessment.
# 2) Global and local Moran's tests.
# 3) Geary's test.
# 4) Divide the values of the variable into two classes (choose some
#    sensible threshold), and run the join count test. Look at the
#    sensitivity to the choice of threshold value.

#LINEAR MODEL ESTIMATED VIA OLS
spatial_data$produkcja.pc <- spatial_data$produkcja / spatial_data$liczba_ludnosci
model.liniowy <- lm(spatial_data$bezrobocie ~ spatial_data$produkcja.pc)
summary(model.liniowy)

#GRAPHICAL EVALUATION
spatial_data$res <- model.liniowy$residuals
green_area <- rgb(24, 121, 104, 80, names = NULL, maxColorValue = 255)
pal <- colorRampPalette(c("red", "white", green_area), bias = 1.4)
quartz()

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



