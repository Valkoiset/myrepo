#INSTALLING PACKAGES (previously installed packages commented - please uncomment if necessary)
# install.packages("rgdal")
# install.packages("sp")
install.packages("spdep")
install.packages("geospacom")

#SET WORKING DIRECTORY
setwd("C:/Users/Oleksandr/Desktop/Spatial Econometrics")

# clear the workspace, plots and console
rm(list = ls())
if(!is.null(dev.list())) dev.off()
cat("\014") 

#Re-running code from previous class
library(rgdal)
library(sp)
mapa <- readOGR(".", "powiaty")
mapa <- spTransform(mapa, "+proj=longlat")
dane <- read.csv("BDL_dane.csv", header = TRUE, sep = ";", dec = ",")
mapa@data$kod <- as.numeric(as.character(mapa@data$jpt_kod_je))
spatial_data <- merge(y = dane, x = mapa, by.y = "kod", by.x = "kod")
rm(mapa)
rm(dane)

#Will also be useful...
sgh_green <- rgb(13, 85, 72, 160, names = NULL, maxColorValue = 255) # 160 - transparency
N <- nrow(spatial_data)
centroids <- coordinates(spatial_data)  # gets coordinates of center of each region
plot(spatial_data)
points(centroids, pch = 16, col = sgh_green)

#Way 1: Neighbourhood matrix with row normalisation
library(spdep)
cont1 <- poly2nb(spatial_data, queen = T) # poly2nb computes the list of neighbors.
                                          # queen stands for neighbors on diagonal
W1_list <- nb2listw(cont1, style = "W")   # style = w means that u perform row-wise normalization
W1 <- listw2mat(W1_list)                  # converting list to matrix type object
plot.nb(cont1, centroids, col = sgh_green, pch = 16)
W1_list$weights

#Way 2: Neighbourhood matrix with row normalisation - 2-nd order neighbourhood relationship included (neighbour of my neighbour is my neighbour)
cont2 <- nblag(cont1, 2)  # compute laged neighbor (the one who is neighbor to your neighbor)
cont2acum <- nblag_cumul(cont2)
W2 <- nb2mat(cont2acum)
plot.nb(cont2acum, centroids, col = sgh_green, pch = 16)
W2_list <- mat2listw(W2, style = "W")

#Way 3: Matrix of inverted distance
library(geospacom)
distance <- DistanceMatrix(spatial_data, "jpt_kod_je", unit = 1000) # unit 1000 means kilometers
gamma <- 1
W3 <- 1 / (distance ^ gamma)
diag(W3) <- 0 # reset zero to diagonal to avoid infinity in computing inverse
W3 <- W3 / as.matrix(rowSums(W3)) %*% matrix(1, nrow = 1, ncol = N)
W3_list <- mat2listw(W3, style="W")

#Way 4: neighbours in a predefined distance [km]
cont4 <- dnearneigh(centroids, 0.01, 60, row.names = spatial_data@data$kod, longlat = TRUE)
W4_list <- nb2listw(cont4, style = "W")
W4 <- listw2mat(W4_list)
plot.nb(cont4, centroids, col = sgh_green, pch = 16)

#Way 5: k nearest neighbours
k_neigh_matrix <- knearneigh(centroids, k = 5, longlat = TRUE)
cont5 <- knn2nb(k_neigh_matrix)
W5_list <- nb2listw(cont5, style = "W")
W5 <- listw2mat(W5_list)

#Way 6: "economic" distance (example: difference in mean salaries)
W6 <- matrix(0, nrow = N, ncol = N)
for(ii in 1:N) {
  for(jj in 1:N) {
    W6[ii, jj] <- abs(spatial_data@data$wynagrodzenie[ii] - spatial_data@data$wynagrodzenie[jj])
    #Could be replaced with Euclidian distance for >1 variables - see slides (formula)
  }
}
W6 <- W6 / (as.matrix(rowSums(W6)) %*% matrix(1, nrow = 1, ncol = N))
rm(ii, jj)
W6_list <- mat2listw(W6, style = "W")

#Way 7: all poviats in the same voivodship are neighbours
W7 <- matrix(0, nrow = N, ncol = N)
spatial_data@data$wojewodztwo <- substr(as.character(spatial_data@data$jpt_kod_je), 1, 2)
for(ii in 1:N) {
  for(jj in 1:N) {
    if (spatial_data@data$wojewodztwo[ii] == spatial_data@data$wojewodztwo[jj]) W7[ii, jj] <- 1
    if (ii == jj) W7[ii, jj] <- 0
  }
}
rm(ii, jj)
W7_list <- mat2listw(W7, style = "W")
plot.nb(W7_list$neighbours, centroids, col = sgh_green, pch = 16)

#Way 8: only respective capitals of voivodships are neighours (regional "hubs")
W8 <- matrix(0, nrow = N, ncol = N)
miasta_wojewodzkie <- c("0264", "0463", "1061", "0663", "0862", "1261", "1465", "1661", "1863", "2061", "2261", "2469", "2661", "2862", "3064", "3262")
for(ii in 1:nrow(spatial_data)) {
  for(jj in 1:nrow(spatial_data)) {
    if ( as.character(spatial_data@data$jpt_kod_je)[ii] %in% miasta_wojewodzkie & spatial_data@data$wojewodztwo[ii] == spatial_data@data$wojewodztwo[jj] 
         | as.character(spatial_data@data$jpt_kod_je)[jj] %in% miasta_wojewodzkie & spatial_data@data$wojewodztwo[ii] == spatial_data@data$wojewodztwo[jj] )
    { W8[ii, jj] <- 1 }
  }
}
rm(ii, jj)
W8_list <- mat2listw(W8, style = "W")
plot.nb(W8_list$neighbours, centroids, col = sgh_green, pch = 16)