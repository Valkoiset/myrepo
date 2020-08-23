


library(sp)
library(rgdal)
library(spdep)
library(geospacom)
library(spatialEco)

rm(list = ls())
setwd("~/Desktop/SGH/2 semester/Spatial Econometrics/Home/Home5")

# Map of Germany with already chosen and merged variables x (Deaths (number of
# deaths in each region in 2017)) and y (Population) and Fertility rate
map <-
  readOGR(dsn = "spatial_data",
          layer = "spatial_final",
          stringsAsFactors = F)
map <- spTransform(map, "+proj=longlat")

plot(map)
sgh_green <- rgb(13, 85, 72, 160, names = NULL, maxColorValue = 255)
# --------------------------------------------------------------

# Visualise the number of Deaths in regions
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

# Number of deaths per 1000 people
map@data$deathspp <- map@data$Deaths / map@data$Popultn * 1000

thresholds <- c(seq(9, 13, 0.5))
spplot(
  map,
  zcol = "deathspp",
  colorkey = list(labels = list(
    breaks = seq(10, length(thresholds)), labels = thresholds
  )),
  col.regions = rainbow(99, start = 0.1),
  cuts = length(thresholds),
  cex = 0.5,
  par.settings = list(axis.line = list(col =  'transparent')),
  main = "Number of deaths per 1000 people"
)

                               # Modelling
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

  # SAR: Spatial Lag
# maximum likelihood
model2a <- lagsarlm(deathspp ~ Popultn + Fertlty, listw = W_list, zero.policy = T)
summary(model2a)
res2a <- model2a$residuals
moran.test(res2a, listw = W_list, zero.policy = T)

# least squares
model2b <-
  stsls(Deaths ~ Popultn + Fertlty, listw = W_list, zero.policy = T)
summary(model2b)
res2b <- model2b$residuals
moran.test(res2b, listw = W_list, zero.policy = T)

  # SEM: Spatial Error 
# maximum likelihood
model3a <-
  errorsarlm(Deaths ~ Popultn + Fertlty, listw = W_list, zero.policy = T)
summary(model3a)
res3a <- model3a$residuals
moran.test(res3a, listw = W_list, zero.policy = T)

# least squares
model3b <-
  GMerrorsar(Deaths ~ Popultn + Fertlty, listw = W_list, zero.policy = T)
summary(model3b)
res3b <- model3b$residuals
moran.test(res3b, listw = W_list,zero.policy = T)

  # SLX
W <- listw2mat(W_list)
X <- cbind(Deaths, Popultn, Fertlty, zero.policy = T)
WX <- W %*% X
lag.Deaths <- WX [, 1]
lag.Popultn <- WX [, 2]
lag.Fertlty <- WX [, 3]

model4 <-
  lm(Deaths ~ Popultn + Fertlty)
summary(model4)
lm.morantest(model4, listw = W_list, zero.policy = T)

