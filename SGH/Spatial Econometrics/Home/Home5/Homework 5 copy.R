


library(sp)
library(rgdal)
library(spdep)
library(geospacom)
library(spatialEco)

rm(list = ls())
setwd("~/Desktop/SGH/2 semester/Spatial Econometrics/Home/Home5")

# Map of "kindergartens" in Germany
kindergartens <- readOGR(dsn="germany", layer="germany", stringsAsFactors = F)

# # Remove all NA's in rows (and associated points)
# sp.na.omit <- function(kindergartens, margin=1) {
#   if (!inherits(kindergartens, "SpatialPointsDataFrame") & 
#       !inherits(kindergartens, "SpatialPolygonsDataFrame")) 
#     stop("MUST BE sp SpatialPointsDataFrame OR SpatialPolygonsDataFrame CLASS OBJECT") 
#   na.index <- unique(as.data.frame(which(is.na(kindergartens@data),
#                                          arr.ind=TRUE))[,margin])
#   if(margin == 1) {  
#     cat("DELETING ROWS: ", na.index, "\n") 
#     return( kindergartens[-na.index,]  ) 
#   }
#   if(margin == 2) {  
#     cat("DELETING COLUMNS: ", na.index, "\n") 
#     return( kindergartens[,-na.index]  ) 
#   }
# }
# kindergartens <- sp.na.omit(kindergartens)

plot(kindergartens, pch = 16)

# Map of Germany with already chosen and merged variables x (Deaths (number of
# deaths in each region in 2017)) and y (Population) and Fertility rate
map <-
  readOGR(dsn = "spatial_data",
          layer = "spatial_final",
          stringsAsFactors = F)
map <- spTransform(map, "+proj=longlat")

  # nrow(kindergartens)
  # nrow(map)
  # 15981 - 413
  # kindergartens <- sample(1:nrow(kindergartens), nrow(map))
  # map <- sample(1:nrow(map), nrow(map))
  # kindergartens@data$GEO <- map@data$GEO
  # length(kindergartens) == length(map)
  
plot(map)
sgh_green <- rgb(13, 85, 72, 160, names = NULL, maxColorValue = 255)
points(kindergartens, pch = 20, col = sgh_green)

#Number of "Biedronka" markets in poviats
library(plotKML)
proj4string(kindergartens) <- getCRS(map)
Pts.poly <- over(kindergartens, map)[, "GEO"]
  
  # checking some stuff
  unique(map@data[["GEO"]])
  unique(Pts.poly)
  length(kindergartens)
  length(map)
  
kindergartensInRegions <- as.data.frame(table(Pts.poly))
colnames(kindergartensInRegions) <- c("geo", "quantity")
# --------------------------------------------------------------
biedronki.w.powiatach$kod <- as.numeric(as.character(biedronki.w.powiatach$powiat))
rm(biedronka, pts.poly)

# Visualise the number of "Biedronka" markets in poviats
pal <- colorRampPalette(c("white", sgh_green), bias = 1)
spplot(
  map,
  zcol = "Deaths",
  colorkey = TRUE,
  col.regions = pal(100),
  cuts = 99,
  cex = 0.5,
  par.settings = list(axis.line = list(col =  'transparent')),
  main = "Deaths"
)

# Merge with socio-economic data
dane <- read.csv("BDL_dane.csv", header = TRUE, sep = ";", dec = ",")
spatial_data <- merge(x = map, y = kindergartens, by.x = "GEO", by.y = "GEO")

rm(map, biedronki.w.powiatach)
dane.przestrzenne <- merge(x = dane.przestrzenne, y = dane, by.x = "kod", by.y = "kod")
rm(dane)

# Number of deaths per 1000 people
map@data$deathspp <- map@data$Deaths / map@data$Popultn * 1000

thresholds <- c(seq(9, 13, 0.5))
spplot(
  map,
  zcol = "deathspp",
  colorkey = list(labels = list(
    breaks = seq(10, length(thresholds)), labels = thresholds
  )),
  col.regions = rainbow(49, start = 0.1),
  cuts = length(thresholds),
  cex = 0.5,
  par.settings = list(axis.line = list(col =  'transparent')),
  main = "Number of deaths per 1000 people"
)

attach(map@data)
library(spdep)
cont <- poly2nb(map, queen = T)
W_list <- nb2listw(cont, style = "W", zero.policy = T)

# Linear model
model1 <-
  lm(deathspp ~ Popultn + Fertlty) # deaths per 1000 people explained by
# population and fertility rate
summary(model1)
lm.morantest(model1, listw = W_list, zero.policy = T)
lm.LMtests(model1, listw = W_list, test = "all", zero.policy = T)

# SAR: Spatial Lag - ML and TSLS
model2a <- lagsarlm(deathspp ~ Popultn + Fertlty, listw = W_list, zero.policy = T)
summary(model2a)
res2a <- model2a$residuals
moran.test(res2a, listw = W_list, zero.policy = T)

# Tests for rho (LR and Wald) can be computed individually:
LR1.sarlm(model2a)
Wald1.sarlm(model2a)

model2b <-
  stsls(biedronki.pc ~ bezrobocie + wynagrodzenie, listw = W_list)
summary(model2b)
res2b <- model2b$residuals
moran.test(res2b, listw = W_list)
lm.LMtests(res2b, listw = W_list, test = "LMerr")
# Number of instrument: argument W2X

# SEM: Spatial Error - ML and GLS
model3a <-
  errorsarlm(biedronki.pc ~ bezrobocie + wynagrodzenie, listw = W_list)
summary(model3a)
res3a <- model3a$residuals
moran.test(res3a, listw = W_list)

model3b <-
  GMerrorsar(biedronki.pc ~ bezrobocie + wynagrodzenie, listw = W_list)
summary(model3b)

# SLX
W <- listw2mat(W_list)
X <- cbind(bezrobocie, wynagrodzenie)
WX <- W %*% X
lag.bezrobocie <- WX [, 1]
lag.wynagrodzenie <- WX [, 2]

# or:
# WX <- lag.listw(W_list, X)
# lag.bezrobocie <- lag.listw(W_list, bezrobocie)
# lag.wynagrodzenie <- lag.listw(W_list, bezrobocie)

# or:
# WX <- create_WX(X, listw = W_list)
# lag.bezrobocie <- WX [, 1]
# lag.wynagrodzenie <- WX [, 2]

model4a <-
  lm(biedronki.pc ~ bezrobocie + wynagrodzenie + lag.bezrobocie + lag.wynagrodzenie)
summary(model4a)
lm.morantest(model4a, listw = W_list)
lm.LMtests(model4a, listw = W_list, test = "all")

model4b <-
  lmSLX(biedronki.pc ~ bezrobocie + wynagrodzenie, listw = W_list)
summary(model4b)
lm.morantest(model4b, listw = W_list)
lm.LMtests(model4b, listw = W_list, test = "all")

#...to be continued:
save.image(file = "dane_biedronka_1.RData")
