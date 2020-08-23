

library(sp)
library(rgdal)
library(spdep)
library(geospacom)

# Homework 2

rm(list = ls())
setwd("~/Desktop/SGH/2 semester/Spatial Econometrics/Spatial Econometrics")

# loading data
spatial_data <- readOGR(dsn="spatial_data", layer="spatial_final", stringsAsFactors = F)

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

