

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
setwd("~/Desktop/SGH/2 semester/Spatial Econometrics/Home/Home4")

set.seed(323)
# SELECT THE DESIRED SPATIAL OBJECTS
# Germany: Niedersachsen district
map <- readOGR(".", "gis_osm_pois_a_free_1")
map <- spTransform(map, "+proj=longlat")

plot(map)

# What kind of pois are available?
unique(map@data$fclass)

# How many for each category?
table(map@data$fclass)

# Let's pick convenience kindergartens
map2 <- map[map@data$fclass == "kindergartens",] # 2074 observations
plot(map2)

# 3. GENERATE SpatialPointsDataFrame
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
plot(map3)
map <- map3



