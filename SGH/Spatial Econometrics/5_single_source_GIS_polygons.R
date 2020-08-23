#INSTALLING PACKAGES (previously installed packages commented - please uncomment if necessary)
# install.packages("rgdal")
# install.packages("sp")
# install.packages("spdep")
# install.packages("spatialEco")
# install.packages("plotKML")

#SET WORKING DIRECTORY
setwd("~/Desktop/SGH/2 semester/Spatial Econometrics/Home/Home5")

# clear the workspace, plots and console
rm(list = ls())
if(!is.null(dev.list())) dev.off()
cat("\014") 

library(rgdal)
library(sp)
library(spatialEco)

#Map of "Biedronka" markets
biedronka <- read.csv("Polska_Biedronka.csv", header = FALSE, sep = ";", dec = ".")
colnames(biedronka) <- c("dlugosc", "szerokosc", "sklep", "miasto", "adres", "telefon")
coordinates(biedronka) = ~ dlugosc + szerokosc
plot(biedronka, pch = 16)

#Map of Poland (and "Biedronka" markets)
mapa <- readOGR(".", "powiaty")
mapa <- spTransform(mapa, "+proj=longlat")
  quartz()
plot(mapa)
sgh_green <- rgb(13, 85, 72, 160, names = NULL, maxColorValue = 255)
points(biedronka, pch = 20, col = sgh_green)

#Number of "Biedronka" markets in poviats
library(plotKML)
proj4string(biedronka) <- getCRS(mapa)
pts.poly <- over(biedronka, mapa)[, "jpt_kod_je"]
# --------------------------------------------------------------
  unique(pts.poly)
  length(biedronka)
  length(mapa)
  # biedronka@data$
# --------------------------------------------------------------
biedronki.w.powiatach <- as.data.frame(table(pts.poly))
colnames(biedronki.w.powiatach) <- c("powiat", "biedronki")
biedronki.w.powiatach$kod <- as.numeric(as.character(biedronki.w.powiatach$powiat))
rm(biedronka, pts.poly)

#Merge with socio-economic data
dane <- read.csv("BDL_dane.csv", header = TRUE, sep = ";", dec = ",")
mapa@data$kod <- as.numeric(as.character(mapa@data$jpt_kod_je))
dane.przestrzenne <- merge(x = mapa, y = biedronki.w.powiatach, by.x = "kod", by.y = "kod")
rm(mapa, biedronki.w.powiatach)
dane.przestrzenne <- merge(x = dane.przestrzenne, y = dane, by.x = "kod", by.y = "kod")
rm(dane)

#Visualise the number of "Biedronka" markets in poviats
pal <- colorRampPalette(c("white", sgh_green), bias = 1)
spplot(dane.przestrzenne, zcol = "biedronki", colorkey = TRUE, col.regions = pal(100), cuts = 99, cex = 0.5,
       par.settings = list(axis.line = list(col =  'transparent')),
       main = "Number of Biedronka markets in poviat")

#Many markets in Warsaw? No rocket science. Maybe better the number of Biedronka markets per 10000 residents?
dane.przestrzenne@data$biedronki.pc <- dane.przestrzenne@data$biedronki / dane.przestrzenne@data$liczba_ludnosci * 10000
spplot(dane.przestrzenne, zcol = "biedronki.pc", colorkey = TRUE, col.regions = pal(100), cuts = 99, cex = 0.5,
       par.settings = list(axis.line = list(col =  'transparent')),
       main = "Number of Biedronka markets in poviat per 10000 residents")

attach(dane.przestrzenne@data)
library(spdep)
cont <- poly2nb(dane.przestrzenne, queen = T)
W_list <- nb2listw(cont, style = "W")

#Linear model
model1 <- lm(biedronki.pc ~ bezrobocie + wynagrodzenie)
summary(model1)
lm.morantest(model1, listw = W_list)
lm.LMtests(model1, listw = W_list, test = "all")

#SAR: Spatial Lag - ML and TSLS
model2a <- lagsarlm(biedronki.pc ~ bezrobocie + wynagrodzenie, listw = W_list)
summary(model2a)
res2a <- model2a$residuals
moran.test(res2a, listw = W_list)
#Tests for rho (LR and Wald) can be computed individually:
LR1.sarlm(model2a)
Wald1.sarlm(model2a)

model2b <- stsls(biedronki.pc ~ bezrobocie + wynagrodzenie, listw = W_list)
summary(model2b)
res2b <- model2b$residuals
moran.test(res2b, listw = W_list)
lm.LMtests(res2b, listw = W_list, test = "LMerr")
#Number of instrument: argument W2X

#SEM: Spatial Error - ML and GLS
model3a <- errorsarlm(biedronki.pc ~ bezrobocie + wynagrodzenie, listw = W_list)
summary(model3a)
res3a <- model3a$residuals
moran.test(res3a, listw = W_list)

model3b <- GMerrorsar(biedronki.pc ~ bezrobocie + wynagrodzenie, listw = W_list)
summary(model3b)

#SLX
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

model4a <- lm(biedronki.pc ~ bezrobocie + wynagrodzenie + lag.bezrobocie + lag.wynagrodzenie)
summary(model4a)
lm.morantest(model4a, listw = W_list)
lm.LMtests(model4a, listw = W_list, test = "all")

model4b <- lmSLX(biedronki.pc ~ bezrobocie + wynagrodzenie, listw = W_list)
summary(model4b)
lm.morantest(model4b, listw = W_list)
lm.LMtests(model4b, listw = W_list, test = "all")

#...to be continued:
save.image(file = "dane_biedronka_1.RData")

