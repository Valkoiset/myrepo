

# For the country covered in Your previous homeworks (or part thereof) browse
# the available GIS information from the OpenStreetMap service.

# Use the example code 4...homework.R, reading the comments.

# Select the type of objects whose count can be potentially connected with the
# analysed dependent variable for the country of Your choice.
# In the example code, these are convenience stores.

# Construct the potential explanatory variable for Your model, aggregating the
# objects in regions in line with the previously selected regional breakdown.

# In our case, one could consider the count of convenience stores in
# individual poviats of Mazowieckie voivodship or, after merging with
# further data, the number of such stores per capita, per km2 etc.

# Present this variable on the map (and remember to attempt to use it in future
#                                   tasks).

library(sp)
library(rgdal)
library(spdep)
library(geospacom)
library(RColorBrewer)

rm(list=ls())

# LOAD PREVIOUS DATA
# spatial_data <- readOGR(dsn="spatial_data", layer="spatial_final", stringsAsFactors = F)

# -------------------------------------------------------------------------------------
# SELECT THE DESIRED SPATIAL OBJECTS (kindergartens from all germany regions)
        # Germany:
  # Baden-Württemberg
setwd("~/Desktop/SGH/2 semester/Spatial Econometrics/Home/Home4/shp files/Baden-Württemberg")
BadenWürttemberg <- readOGR(".", "gis_osm_pois_a_free_1")
BadenWürttemberg <- spTransform(BadenWürttemberg, "+proj=longlat")
BadenWürttemberg <- BadenWürttemberg[BadenWürttemberg@data$fclass == "kindergarten",]

  # Bayern
setwd("~/Desktop/SGH/2 semester/Spatial Econometrics/Home/Home4/shp files/Bayern")
Bayern <- readOGR(".", "gis_osm_pois_a_free_1")
Bayern <- spTransform(Bayern, "+proj=longlat")
Bayern <- Bayern[Bayern@data$fclass == "kindergarten",]

  # Berlin
setwd("~/Desktop/SGH/2 semester/Spatial Econometrics/Home/Home4/shp files/Berlin")
Berlin <- readOGR(".", "gis_osm_pois_a_free_1")
Berlin <- spTransform(Berlin, "+proj=longlat")
Berlin <- Berlin[Berlin@data$fclass == "kindergarten",]

  # Brandenburg (mit Berlin)
setwd("~/Desktop/SGH/2 semester/Spatial Econometrics/Home/Home4/shp files/Brandenburg (mit Berlin)")
Brandenburg <- readOGR(".", "gis_osm_pois_a_free_1")
Brandenburg <- spTransform(Brandenburg, "+proj=longlat")
Brandenburg <- Brandenburg[Brandenburg@data$fclass == "kindergarten",]

  # Bremen
setwd("~/Desktop/SGH/2 semester/Spatial Econometrics/Home/Home4/shp files/Bremen")
Bremen <- readOGR(".", "gis_osm_pois_a_free_1")
Bremen <- spTransform(Bremen, "+proj=longlat")
Bremen <- Bremen[Bremen@data$fclass == "kindergarten",]

  # Hamburg
setwd("~/Desktop/SGH/2 semester/Spatial Econometrics/Home/Home4/shp files/Hamburg")
Hamburg <- readOGR(".", "gis_osm_pois_a_free_1")
Hamburg <- spTransform(Hamburg, "+proj=longlat")
Hamburg <- Hamburg[Hamburg@data$fclass == "kindergarten",]

  # Hessen
setwd("~/Desktop/SGH/2 semester/Spatial Econometrics/Home/Home4/shp files/Hessen")
Hessen <- readOGR(".", "gis_osm_pois_a_free_1")
Hessen <- spTransform(Hessen, "+proj=longlat")
Hessen <- Hessen[Hessen@data$fclass == "kindergarten",]

  # Mecklenburg-Vorpommern
setwd("~/Desktop/SGH/2 semester/Spatial Econometrics/Home/Home4/shp files/Mecklenburg-Vorpommern")
MecklenburgVorpommern <- readOGR(".", "gis_osm_pois_a_free_1")
MecklenburgVorpommern <- spTransform(MecklenburgVorpommern, "+proj=longlat")
MecklenburgVorpommern <- MecklenburgVorpommern[MecklenburgVorpommern@data$fclass == "kindergarten",]

  # Niedersachsen
setwd("~/Desktop/SGH/2 semester/Spatial Econometrics/Home/Home4/shp files/Niedersachsen")
Niedersachsen <- readOGR(".", "gis_osm_pois_a_free_1")
Niedersachsen <- spTransform(Niedersachsen, "+proj=longlat")
Niedersachsen <- Niedersachsen[Niedersachsen@data$fclass == "kindergarten",]

  # Nordrhein-Westfalen
setwd("~/Desktop/SGH/2 semester/Spatial Econometrics/Home/Home4/shp files/Nordrhein-Westfalen")
NordrheinWestfalen <- readOGR(".", "gis_osm_pois_a_free_1")
NordrheinWestfalen <- spTransform(NordrheinWestfalen, "+proj=longlat")
NordrheinWestfalen <- NordrheinWestfalen[NordrheinWestfalen@data$fclass == "kindergarten",]

  # Rheinland-Pfalz
setwd("~/Desktop/SGH/2 semester/Spatial Econometrics/Home/Home4/shp files/Rheinland-Pfalz")
RheinlandPfalz <- readOGR(".", "gis_osm_pois_a_free_1")
RheinlandPfalz <- spTransform(RheinlandPfalz, "+proj=longlat")
RheinlandPfalz <- RheinlandPfalz[RheinlandPfalz@data$fclass == "kindergarten",]

  # Saarland
setwd("~/Desktop/SGH/2 semester/Spatial Econometrics/Home/Home4/shp files/Saarland")
Saarland <- readOGR(".", "gis_osm_pois_a_free_1")
Saarland <- spTransform(Saarland, "+proj=longlat")
Saarland <- Saarland[Saarland@data$fclass == "kindergarten",]

  # Sachsen
setwd("~/Desktop/SGH/2 semester/Spatial Econometrics/Home/Home4/shp files/Sachsen")
Sachsen <- readOGR(".", "gis_osm_pois_a_free_1")
Sachsen <- spTransform(Sachsen, "+proj=longlat")
Sachsen <- Sachsen[Sachsen@data$fclass == "kindergarten",]

  # Sachsen-Anhalt
setwd("~/Desktop/SGH/2 semester/Spatial Econometrics/Home/Home4/shp files/Sachsen-Anhalt")
SachsenAnhalt <- readOGR(".", "gis_osm_pois_a_free_1")
SachsenAnhalt <- spTransform(SachsenAnhalt, "+proj=longlat")
SachsenAnhalt <- SachsenAnhalt[SachsenAnhalt@data$fclass == "kindergarten",]

  # Schleswig-Holstein
setwd("~/Desktop/SGH/2 semester/Spatial Econometrics/Home/Home4/shp files/Schleswig-Holstein")
SchleswigHolstein <- readOGR(".", "gis_osm_pois_a_free_1")
SchleswigHolstein <- spTransform(SchleswigHolstein, "+proj=longlat")
SchleswigHolstein <- SchleswigHolstein[SchleswigHolstein@data$fclass == "kindergarten",]

  # Thüringen
setwd("~/Desktop/SGH/2 semester/Spatial Econometrics/Home/Home4/shp files/Thüringen")
Thüringen <- readOGR(".", "gis_osm_pois_a_free_1")
Thüringen <- spTransform(Thüringen, "+proj=longlat")
Thüringen <- Thüringen[Thüringen@data$fclass == "kindergarten",]

map2 <- rbind(BadenWürttemberg, Bayern, Berlin, Brandenburg, Bremen, Hamburg, 
              Hessen, MecklenburgVorpommern, Niedersachsen, NordrheinWestfalen,
              RheinlandPfalz, Saarland, Sachsen, SachsenAnhalt, SchleswigHolstein, 
              Thüringen)
# -------------------------------------------------------------------------------------
plot(map2)

# 3. GENERATE SpatialPointsDataFrame
# NOTE: in general, it is not necessary as one can proceed with SpatialPolygonsDataFrame like map2.
# This is because the polygons are very small (like 4 corners of a rectangular building).
# But it was not covered in the lecture.

# Generate a table of points representing kindergartens
map2@data$lon <- NA
map2@data$lat <- NA
for (ii in 1:nrow(map2)) {
  map2@data$lon[ii] <- map2@polygons[[ii]]@Polygons[[1]]@labpt[1]
  map2@data$lat[ii] <- map2@polygons[[ii]]@Polygons[[1]]@labpt[2]
}
map3 <- map2@data[,c("name","lon","lat")]
map3$name <- as.character(map3$name)

coordinates(map3) <- c("lon", "lat")
# ...and that's how the SpatialPointsDataFrame object (like the one with San Francisco restaurants) was created:
plot(map3)
map <- map3
# ----------------------------------------------------------
# Remove kindergartens occured multiple times
print("TOTAL"); nrow(map)
print("UNIQUE"); length(unique(map@data$name))
non.unique <- as.data.frame(table(map@data$name))
non.unique <- as.vector(non.unique[non.unique$Freq > 1, 1])
library(Hmisc)
map <- map[map@data$name %nin% non.unique, ]
plot(map)
rm(non.unique)
map@data$os

# Convert SPDF into DF:
map <- data.frame(map)

# Convert back DF into SPDF:
coordinates(map) <- c("lon", "lat")
plot(map)

map@data$name <- as.numeric(map@data$name)
map@data$name <- 0.1 * map@data$name
# ------------- save map ---------------------------------------------
setwd("~/Desktop/SGH/2 semester/Spatial Econometrics/Home/Home4")
# writeOGR(obj=map, dsn="germany", layer="germany",
#            driver="ESRI Shapefile")

map <- readOGR(dsn="germany", layer="germany", stringsAsFactors = F)
map@data$name <- 10 * map@data$name
# --------------------------------------------------------------------

# Visualise
green_area <- rgb(24, 121, 104, 80, names = NULL, maxColorValue = 255)
pal <- colorRampPalette(c("red", "yellow", green_area), bias = 0.4)
spplot(map, zcol = "name", colorkey = TRUE, col.regions = pal(100), cuts = 99, cex = 0.7,
       par.settings = list(axis.line = list(col =  'transparent')),
       main = "Number of children in kindergartens")

# Visualise with map background (map source: Stamen, ?get_map for alternatives); ggplot2 flavour
library(ggmap) 
gmap <- get_map(location = (bbox(map)), # bbox defines rectangle of map in terms of latitude and longitude
                source = "stamen", maptype = "toner", crop = TRUE)
gg <- ggmap(gmap)
gg
gg <- gg + geom_point(data = as.data.frame(map), 
                      aes(lon, lat, color = "red"), 
                      size = 2, 
                      shape = 20)  + # midpoint here instead of bias indicating which color should stand behind the yellow
  labs(x = "longitude", y = "latitude") 
gg

### 2a. RECTANGULAR GRID ###

library(raster)
raster_rect <- raster(map, ncol = 25, nrow = 25)
spol_rect <- as(raster_rect, "SpatialPolygonsDataFrame")
rm(raster_rect)

### 2b. HEXAGONAL GRID ###

library(rgeos)
spix_hex <- spsample(map, type = "hexagonal", n = 1000) # hexagonal - type of grid we are using; n - number of hexagonals
spol_hex <- HexPoints2SpatialPolygons(spix_hex)
rm(spix_hex)

### 2c. Which grid do we choose?
spol <- spol_hex
# spol <- spol_rect

### 2d. PUT A GRID OVER THE POINTS
if(exists("map.grid")) {rm(map.grid)}
map.grid <- SpatialPolygonsDataFrame(spol, data.frame(row.names = 1:length(spol), PolIDS = 1:length(spol)), match.ID = FALSE)
# rm(gt, grid, spix, spol)
plot(map.grid)
points(map.grid)
# Merge the grid and the points
map.over <- over(map, map.grid) # put grid on sf.rest
map@data <- data.frame(map@data, map.over)
rm(map.over)
#Compute average inspection results for each polygon ID
map.poly <- map@data[, c("name", "PolIDS")]
grid.avg.scores <- aggregate(map.poly, by = list(Polygon = map.poly$PolIDS), FUN = mean)
rm(map.poly)
# Merge the result into SpatialPolygonDataFrame
map.grid <- merge(x = map.grid, y = grid.avg.scores, by.x = "PolIDS", by.y = "PolIDS")
rm(grid.avg.scores)
# Remove empty cells from the grid
map.grid <- map.grid[!is.na(map.grid@data$name), ]

### 2e. VISUALISATIONS

# Visualisation 1
plot(map.grid)
points(map, pch = 20)

# Visualisation 2
spplot(map, zcol = "name", colorkey = TRUE, col.regions = pal(100), cuts = 99, cex = 0.7,
       par.settings = list(axis.line = list(col =  'transparent')),
       main = "Number of children in kindergartens", sp.layout = map.grid) 

# Visualisation 3
spplot(map.grid, zcol = "name", colorkey = TRUE, col.regions = pal(100), cuts = 99, cex = 0.5,
       par.settings = list(axis.line = list(col =  'transparent')),
       main = "Number of children in kindergartens")


### 3. ANALYSIS OF POINT DATA ###

# Define W: 5 nearest neighbours
library(spdep)
k_neigh_matrix <- knearneigh(map, k = 5, longlat = TRUE)
cont <- knn2nb(k_neigh_matrix)
W_list <- nb2listw(cont, style = "W")
rm(k_neigh_matrix, cont)

# Model of spatial autoregression
model.SAR.points <- spautolm(map$name ~ 1, listw = W_list, zero.policy = T)
summary(model.SAR.points)
res.points <- model.SAR.points$fit$residuals
moran.test(res.points, W_list)

### 4. GRID DATA ANALYSIS ###

# Define W: neighbourhood + queen criterion (meaningful for a rectangular grid!)
cont2 <- poly2nb(map.grid, queen = T)
W2_list <- nb2listw(cont2, style = "W", zero.policy = TRUE)

# Spatial autoregression model
model.SAR.grid <- spautolm(map.grid$name ~ 1, listw = W2_list)
summary(model.SAR.grid)
res.grid <- model.SAR.grid$fit$residuals
moran.test(res.grid, W2_list, zero.policy = TRUE)

# Set multipliers
W2 <- listw2mat(W2_list)
if (substr(rownames(W2), 1, 2)[1] == "ID") { rownames(W2) <- substr(rownames(W2), 3, 5) }
N <- dim(W2)[1]
sp.multiplier <- solve(diag(N) - model.SAR.grid$lambda * W2)
epsilon <- matrix(0, nrow = N, ncol = 1)
# Unit shock
epsilon[76, 1] <- 1
dY <- sp.multiplier %*% epsilon

# Merge into the spatial database
dY.regions <- data.frame(dY, as.integer(rownames(W2)), stringsAsFactors = FALSE)
colnames(dY.regions) <- c("dY", "region")
map.grid.impact <- merge(x = map.grid, y = dY.regions, by.x = "PolIDS", by.y = "region")

# Illustrate
pal <- colorRampPalette(c("white", green_area), bias = 1)
# Better use hand-made thresholds
thresholds <- c(0, 0.0001, 0.001, 0.01, 0.02, 0.03, 0.05, 0.10, 0.50, Inf)
map.grid.impact@data$cut_dY <- cut(map.grid.impact@data$dY, breaks = thresholds)
spplot(map.grid.impact, zcol = "cut_dY", 
       col.regions = pal(length(thresholds)), cuts = length(thresholds) - 1, 
       colorkey = list(labels = list(breaks = seq(0.5, length(thresholds) - 0.5), labels = thresholds)), #col.regions = pal(100), cuts = 99, cex = 0.5,
       par.settings = list(axis.line = list(col =  'transparent')),
       main = "Impact of unit shock in a single cell on the change in Y")

