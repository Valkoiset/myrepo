

#SET WORKING DIRECTORY
setwd("~/Desktop/SGH/2 semester/Spatial Econometrics")

# clear the workspace, plots and console
rm(list = ls())
if(!is.null(dev.list())) dev.off()
cat("\014") 

### 1. PREPARE POINT DATA ###
#Input the dataset - sanitary inspection results in almost 2700 restaurants in San Francisco.
SF.rest <- read.csv("San_Francisco_Restauracje.csv", dec = ".", sep = ",")

#Impose a spatial interpretation by setting two variables as coordinates
library(sp)
coordinates(SF.rest) <- c("longitude", "latitude") # transforming data frame into spatial form data frame
plot(SF.rest, pch = 16)

#Remove 7 restaurants with multiple inspections
print("TOTAL"); nrow(SF.rest)
print("UNIQUE"); length(unique(SF.rest@data$business_id))
non.unique <- as.data.frame(table(SF.rest@data$business_id))
non.unique <- as.vector(non.unique[non.unique$Freq > 1, 1])
library(Hmisc)
SF.rest <- SF.rest[SF.rest@data$business_id %nin% non.unique, ]
plot(SF.rest, pch = 16)
rm(non.unique)

#Remove spatial outliers (far away from the city borders)
longitude.dim <- SF.rest@coords[, 1]
latitude.dim <- SF.rest@coords[, 2]
#The plots before help us to set the limiting observations: 
#cut off 4 observations from the East (highest longitude) and 2 from the South (lowest latitude)
#Compute cutoff points: 
cut.off.long <- sort(longitude.dim, decreasing = TRUE)[4]
cut.off.lat <- sort(latitude.dim, decreasing = FALSE)[2]
#Convert SPDF into DF:
SF.rest <- data.frame(SF.rest)
#Use only points below highest longitue and above lowest latitude:
SF.rest <- SF.rest[SF.rest$longitude < cut.off.long & SF.rest$latitude > cut.off.lat, ]
#Convert back DF into SPDF:
coordinates(SF.rest) <- c("longitude", "latitude")
plot(SF.rest, pch = 16)
rm(cut.off.lat, cut.off.long, latitude.dim, longitude.dim)

#Visualise
green_area <- rgb(24, 121, 104, 80, names = NULL, maxColorValue = 255)
pal <- colorRampPalette(c("red", "yellow", green_area), bias = 0.4)
spplot(SF.rest, zcol = "Score", colorkey = TRUE, col.regions = pal(100), cuts = 99, cex = 0.7,
       par.settings = list(axis.line = list(col =  'transparent')),
       main = "Restaurant inspection scores")

#Visualise with map background (map source: Stamen, ?get_map for alternatives); ggplot2 flavour
library(ggmap) 
gmap <- get_map(location = (bbox(SF.rest)), # bbox defines rectangle of map in terms of latitude and longitude
                source = "stamen", maptype = "toner", crop = TRUE)
gg <- ggmap(gmap)
gg
gg <- gg + geom_point(data = as.data.frame(SF.rest), 
                      aes(longitude, latitude, colour = Score), 
                      size = 2, 
                      shape = 20) +
           scale_colour_gradient2(low = "red", mid = "yellow", high = green_area, midpoint = 80, guide = "colourbar") + # midpoint here instead of bias indicating which color should stand behind the yellow
           labs(x = "longitude", y = "latitude")
gg



### 2a. RECTANGULAR GRID ###

library(raster)
raster_rect <- raster(SF.rest, ncol = 25, nrow = 25)
spol_rect <- as(raster_rect, "SpatialPolygonsDataFrame")
rm(raster_rect)

### 2b. HEXAGONAL GRID ###

library(rgeos)
spix_hex <- spsample(SF.rest, type = "hexagonal", n = 1000) # hexagonal - type of grrid we are using; n - number of hexagonals
spol_hex <- HexPoints2SpatialPolygons(spix_hex)
rm(spix_hex)

### 2c. Which grid do we choose?
spol <- spol_hex
# spol <- spol_rect

### 2d. PUT A GRID OVER THE POINTS
if(exists("SF.rest.grid")) {rm(SF.rest.grid)}
SF.rest.grid <- SpatialPolygonsDataFrame(spol, data.frame(row.names = 1:length(spol), PolIDS = 1:length(spol)), match.ID = FALSE)
#rm(gt, grid, spix, spol)
plot(SF.rest.grid)
points(SF.rest)
#Merge the grid and the points
SF.rest.over <- over(SF.rest, SF.rest.grid) # put grid on sf.rest
SF.rest@data <- data.frame(SF.rest@data, SF.rest.over)
rm(SF.rest.over)
#Compute average inspection results for each polygon ID
SF.rest.poly <- SF.rest@data[, c("Score", "PolIDS")]
grid.avg.scores <- aggregate(SF.rest.poly, by = list(Polygon = SF.rest.poly$PolIDS), FUN = mean)
rm(SF.rest.poly)
#Merge the result into SpatialPolygonDataFrame
SF.rest.grid <- merge(x = SF.rest.grid, y = grid.avg.scores, by.x = "PolIDS", by.y = "PolIDS")
rm(grid.avg.scores)
#Remove empty cells from the grid
SF.rest.grid <- SF.rest.grid[!is.na(SF.rest.grid@data$Score), ]

### 2e. VISUALISATIONS

#Visualisation 1
plot(SF.rest.grid)
points(SF.rest, pch = 20)

#Visualisation 2
spplot(SF.rest, zcol = "Score", colorkey = TRUE, col.regions = pal(100), cuts = 99, cex = 0.5,
       par.settings = list(axis.line = list(col =  'transparent')),
       main = "Restaurant inspection scores", sp.layout = SF.rest.grid)

#Visualisation 3
spplot(SF.rest.grid, zcol = "Score", colorkey = TRUE, col.regions = pal(100), cuts = 99, cex = 0.5,
       par.settings = list(axis.line = list(col =  'transparent')),
       main = "Restaurant inspection scores")


### 3. ANALYSIS OF POINT DATA ###

#Define W: 5 nearest neighbours
library(spdep)
k_neigh_matrix <- knearneigh(SF.rest, k = 5, longlat = TRUE)
cont <- knn2nb(k_neigh_matrix)
W_list <- nb2listw(cont, style = "W")
rm(k_neigh_matrix, cont)

#Model of spatial autoregression
model.SAR.points <- spautolm(SF.rest$Score ~ 1, listw = W_list)
summary(model.SAR.points)
res.points <- model.SAR.points$fit$residuals
moran.test(res.points, W_list)

### 4. GRID DATA ANALYSIS ###

#Define W: neighbourhood + queen criterion (meaningful for a rectangular grid!)
cont2 <- poly2nb(SF.rest.grid, queen = T)
W2_list <- nb2listw(cont2, style = "W", zero.policy = TRUE)

#Spatial autoregression model
model.SAR.grid <- spautolm(SF.rest.grid$Score ~ 1, listw = W2_list)
summary(model.SAR.grid)
res.grid <- model.SAR.grid$fit$residuals
moran.test(res.grid, W2_list, zero.policy = TRUE)

#Set multipliers
W2 <- listw2mat(W2_list)
if (substr(rownames(W2), 1, 2)[1] == "ID") { rownames(W2) <- substr(rownames(W2), 3, 5) }
N <- dim(W2)[1]
sp.multiplier <- solve(diag(N) - model.SAR.grid$lambda * W2)
epsilon <- matrix(0, nrow = N, ncol = 1)
#Unit shock
epsilon[76, 1] <- 1
dY <- sp.multiplier %*% epsilon

#Merge into the spatial database
dY.regions <- data.frame(dY, as.integer(rownames(W2)), stringsAsFactors = FALSE)
colnames(dY.regions) <- c("dY", "region")
SF.rest.grid.impact <- merge(x = SF.rest.grid, y = dY.regions, by.x = "PolIDS", by.y = "region")

#Illustrate
pal <- colorRampPalette(c("white", green_area), bias = 1)
#Better use hand-made thresholds
thresholds <- c(0, 0.0001, 0.001, 0.01, 0.02, 0.03, 0.05, 0.10, 0.50, Inf)
SF.rest.grid.impact@data$cut_dY <- cut(SF.rest.grid.impact@data$dY, breaks = thresholds)
spplot(SF.rest.grid.impact, zcol = "cut_dY", 
       col.regions = pal(length(thresholds)), cuts = length(thresholds) - 1, 
       colorkey = list(labels = list(breaks = seq(0.5, length(thresholds) - 0.5), labels = thresholds)), #col.regions = pal(100), cuts = 99, cex = 0.5,
       par.settings = list(axis.line = list(col =  'transparent')),
       main = "Impact of unit shock in a single cell on the change in Y")

