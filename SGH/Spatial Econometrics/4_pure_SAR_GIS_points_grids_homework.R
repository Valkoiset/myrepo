

#EXAMPLE USE OF OPEN STREET MAP TO GENERATE A SPATIAL POINTS DATA FRAME

# 1. SELECT THE GEOGRAPHY OF INTEREST

  # https://www.openstreetmap.org/#map=5/50.611/22.368

  # Our focus is on Mazowieckie voivodship in Poland
  # So download e.g. http://download.geofabrik.de/europe/poland/mazowieckie-latest-free.shp.zip
  # (i.e. download.geofabrik.de -> Poland -> row "Województwo mazowieckie", column ".shp.zip")
  # and unzip to the following folder:
setwd("~/Desktop/SGH/2 semester/Spatial Econometrics/mazowieckie-latest-free.shp")
# Import the map into R workspace as SpatialPolygonsDataFrame
library(sp)
library(rgdal)
library(spdep)
library(geospacom)

# 2. SELECT THE DESIRED SPATIAL OBJECTS

  #For example, we look at the 'points of interest' (pois)
  mapa <- readOGR(".", "gis_osm_pois_a_free_1")
  mapa <- spTransform(mapa, "+proj=longlat")
  
  quartz()
  plot(mapa)
  #Looks like Mazowieckie
  
  unique(mapa@data$fclass)
  #What kind of pois are available?
  
  table(mapa@data$fclass)
  #How many for each category?
  
  #Let's pick convenience stores
  mapa2 <- mapa[mapa@data$fclass == "convenience",]
  plot(mapa2)

# 3. GENERATE SpatialPointsDataFrame
  #NOTE: in general, it is not necessary as one can proceed with SpatialPolygonsDataFrame like mapa2.
  # This is because the polygons are very small (like 4 corners of a rectangular building).
  # But it was not covered in the lecture.
  
  #Let us generate a table of points representing convenience stores
  mapa2@data$lon <- NA
  mapa2@data$lat <- NA
  for (ii in 1:nrow(mapa2)) {
    mapa2@data$lon[ii] <- mapa2@polygons[[ii]]@Polygons[[1]]@labpt[1]
    mapa2@data$lat[ii] <- mapa2@polygons[[ii]]@Polygons[[1]]@labpt[2]
  }
  mapa3 <- mapa2@data[,c("name","lon","lat")]
  mapa3$name <- as.character(mapa3$name)
  
  coordinates(mapa3) <- c("lon", "lat")
  #...and that's how the SpatialPointsDataFrame object (like the one with San Francisco restaurants) was created:
  plot(mapa3)

  