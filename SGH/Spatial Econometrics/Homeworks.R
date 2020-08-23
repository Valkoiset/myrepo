

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
colnames(data2) [colnames(data2) == "Value"] <- "Crimes"
colnames(data3) [colnames(data3) == "Value"] <- "Population"
colnames(data4) [colnames(data4) == "Value"] <- "Deaths"

data_merged <- left_join(data, data2, by = "GEO")
data_merged <- left_join(data_merged, data3, by = "GEO")
data_merged <- left_join(data_merged, data4, by = "GEO")
data_merged <- data.frame(data_merged$GEO,
                          data_merged$Value,
                          data_merged$Crimes,
                          data_merged$Population,
                          data_merged$Deaths)

colnames(data_merged) <- c("GEO", "Fertility", "Crimes", "Population", "Deaths")

map@data <- left_join(map@data, data_merged, by = "GEO")
spatial_data <- map
spatial_data@data$Fertility <- as.numeric(spatial_data@data$Fertility)
spatial_data@data$Crimes <- as.numeric(spatial_data@data$Crimes)
spatial_data@data$Population <- as.numeric(spatial_data@data$Population)
spatial_data@data$Deaths <- as.numeric(spatial_data@data$Deaths)

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

writeOGR(obj=spatial_data, dsn="spatial_data", layer="spatial_final", 
         driver="ESRI Shapefile")

# preparing variables
centroids <- coordinates(spatial_data)
N <- nrow(spatial_data)
color <- rgb(251, 155, 68, 160, names = NULL, maxColorValue = 255)

# For the spatial dataset considered in the first homework, build three
# additional W matrices:

# 1) neighbourhood (order 1), but normalised with the highest
#    eigenvalue (tip: you can do it with the matrix immediately, and then
#    transform it into listw without normalisation).
cont1 <- poly2nb(spatial_data, queen = T)
W1_list <- nb2listw(cont1, style = "C", zero.policy = TRUE)
W1 <- listw2mat(W1_list)
# Plot
par(mar = c(0, 0, 0, 0))
plot(spatial_data)
plot.nb(cont1, centroids, col = color, pch = 16, add = TRUE)

# 2) based on inverted squared distances, but only up to 200 km (above
#    that - no link at all).
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
      (spatial_data@data$Fertlty[ii] - spatial_data@data$Fertlty[jj])^2 +
        (spatial_data@data$Crimes[ii] - spatial_data@data$Crimes[jj])^2 +
        (spatial_data@data$Deaths[ii] - spatial_data@data$Deaths[jj])^2
    )
  }
}
gamma <- 1
W6 <- 1 / (distance3 ^ gamma)
diag(W6) <- 0
W6 <- W6 /as.matrix(rowSums(W6)) %*% 
  matrix(1, nrow = 1, ncol = N)
W6[is.na(W6)] <-0
W6_list <- mat2listw(W6, style = "W")

# plot
plot(spatial_data)
plot.nb(W6_list$neighbours, centroids, col = color, pch = 16, cex = 0.8)

# -------------------------------------------------------------
# Homework 3

setwd("~/Desktop/SGH/2 semester/Spatial Econometrics/Spatial Econometrics")
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
lm.morantest(model.liniowy, W1_list, alternative = "greater", zero.policy = T)
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

mean(res) # -4.224224e-15

#Join count tests
joincount.test(as.factor(res > 0), listw = W1_list, zero.policy = T)

