

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

setwd("C:/Users/Oleksandr/Desktop/Spatial Econometrics")

# check available datasets in eurostats
x <- search_eurostat("")

# download the map
geodata <- get_eurostat_geospatial(resolution = "60", nuts_level = "3",
                                   year = 2016, output_class = "spdf")

# Data from Eurostat
current_pop <- get_eurostat("demo_r_d3dens", time_format = "raw", stringsAsFactors = FALSE) %>%
  filter(substr(time, 1, 4) == "2017") %>% 
  dplyr::mutate(cat = cut_to_classes(values, manual = T, decimals = 2,
                                     manual_breaks = c(1, 50, 100, 2000, 13000)))

# Save data to home folder
saveRDS(current_pop, "demo_r_d3dens.rds")

# join data and map
geodata@data <- left_join(geodata@data, current_pop, by = "geo")

# plot
spplot(geodata, zcol = "cat", color.regions = c("dim grey", brewer.pal(n = 5, name = "PiYG")),
       col = "white", usePolypath = FALSE,
       main = "Population density by NUTS 3 region
       (The ratio between the annual average 
       population and the land area, persons per km2)",
       xlim = c(-22, 34), ylim = c(35, 70))

# -------------------------------------------------------

# Loading data
# 1) Mean annual earnings by NUTS 1 regions (enterprises with 10 employees or more) - NACE Rev. 2, B-S excluding O
#    earn_ses14_rann
data1 <- get_eurostat("earn_ses14_rann", time_format = "raw", stringsAsFactors = FALSE) %>%
  filter(time == "2014")

# 2) Number of employees and hours worked, by working time, NACE Rev. 2 activity and NUTS 1 regions - LCS surveys 2008, 2012 and 2016
#    lc_rnum1_r2
data2 <- get_eurostat("lc_rnum1_r2", time_format = "raw", stringsAsFactors = FALSE) %>%
  filter(substr(time, 1, 4) == "2016")
data2 <- data2[1:416, ]

# 3) Average hours worked per employee, by working time, NACE Rev. 2 activity and NUTS 1 regions - LCS surveys 2008, 2012 and 2016
#    lc_rnum2_r2
data3 <- get_eurostat("lc_rnum2_r2", time_format = "raw", stringsAsFactors = FALSE) %>%
  filter(substr(time, 1, 4) == "2016")
data3 <- data3[1:416 ,]
geodata1 <- get_eurostat_geospatial(resolution = "60", nuts_level = "1",
                                   year = 2016, output_class = "spdf")

colnames(data1) [colnames(data1) == "values"] <- "values1"
colnames(data2) [colnames(data2) == "values"] <- "values2"
colnames(data3) [colnames(data3) == "values"] <- "values3"

# merging data
data_merged <- left_join(data1, data2, by = "geo")
data_merged <- left_join(data_merged, data3, by = "geo")
data_merged <- data.frame(data_merged$geo,
                          data_merged$values1,
                          data_merged$values2,
                          data_merged$values3)

colnames(data_merged)[colnames(data_merged) == "data_merged.geo"] <- "geo"

geodata1@data <- left_join(geodata1@data, data_merged, by = "geo")

centroids1 <- coordinates(geodata1)

par(mar = c(0, 0, 0, 0))
plot(geodata1, xlim = c (10, 12), ylim = c(35, 70))
color <- rgb(251, 155, 68, 160, names = NULL, maxColorValue = 255)
points(centroids1, pch = 16, col = color, cex = 1.1)

# For the spatial dataset considered in the first homework, build three
# additional W matrices:

# 1) neighbourhood (order 1), but normalised with the highest
#    eigenvalue (tip: you can do it with the matrix immediately, and then
#    transform it into listw without normalisation).
cont1 <- poly2nb(geodata1, queen = T)
W1_list <- nb2listw(cont1, style = "W", zero.policy=TRUE)
W1 <- listw2mat(W1_list)              
plot.nb(cont1, centroids1, col = color, pch = 16)
W1_list$weights

# 2) based on inverted squared distances, but only up to 200 km (above
#    that - no link at all).
library(geospacom)
distance <- DistanceMatrix(geodata1, "geo", unit = 200000) # unit 200 means kilometers
gamma <- 2
W3 <- 1 / (distance ^ gamma)
# W3 <- na.omit(W3)
# any(is.na(W3))
diag(W3) <- 0 # reset zero to diagonal to avoid infinity in computing inverse
W3 <- W3 / as.matrix(rowSums(W3)) %*% matrix(1, nrow = 1, ncol = N)
W3_list <- mat2listw(W3, style="W")

# 3) based on Euclidian distance between 3 standardised variables for
#    pairs of regions i, j

N <- nrow(geodata1)
distance <- matrix(0, nrow = N, ncol = N)
for(ii in 1:N) {
  for(jj in 1:N) {
    distance[ii, jj] <- sqrt(
      (geodata1@data$values1[ii] - geodata1@data$values1[jj])^2 +
      (geodata1@data$values2[ii] - geodata1@data$values2[jj])^2 +
      (geodata1@data$values3[ii] - geodata1@data$values3[jj])^2
                             )
  }
}
