#INSTALLING PACKAGES (previously installed packages commented - please uncomment if necessary)
# install.packages("rgdal")
# install.packages("sp")
# install.packages("spdep")

#SET WORKING DIRECTORY
setwd("~/Desktop/SGH/2 semester/Spatial Econometrics")

# clear the workspace, plots and console
rm(list = ls())
if(!is.null(dev.list())) dev.off()
cat("\014")

library(rgdal)
library(sp)
library(spdep)


mapa <- readOGR(".", "powiaty")
mapa <- spTransform(mapa, "+proj=longlat")
dane <- read.csv("BDL_dane.csv", header = TRUE, sep = ";", dec = ",")
mapa@data$kod <- as.numeric(as.character(mapa@data$jpt_kod_je))
spatial_data <- merge(y = dane, x = mapa, by.y = "kod", by.x = "kod")
centroids <- coordinates(spatial_data)
rm(mapa)
rm(dane)

#Linear model (from specific...?)
spatial_data@data$l_wynagrodzenie <- log(spatial_data@data$wynagrodzenie)
mod.lin <- lm(l_wynagrodzenie ~ bezrobocie, data = spatial_data)
summary(mod.lin)

cont1 <- poly2nb(spatial_data, queen = T)
W1_list <- nb2listw(cont1, style = "W")
cont2 <- dnearneigh(centroids, 0.0001, 60, row.names = spatial_data@data$kod, longlat = TRUE)
W2_list <- nb2listw(cont2, style = "W")
lm.morantest(mod.lin, W1_list, alternative = "greater")
lm.morantest(mod.lin, W2_list, alternative = "greater")
#NO!

#General model GNS (from general...?)
mod.GNS1 <- sacsarlm(l_wynagrodzenie ~ bezrobocie, listw = W1_list, data = spatial_data, type = "sacmixed")
summary(mod.GNS1)
mod.GNS2 <- sacsarlm(l_wynagrodzenie ~ bezrobocie, listw = W2_list, data = spatial_data, type = "sacmixed")
summary(mod.GNS2)
#Depends on W matrix! (which one is the best in socio-economic terms?)
#...and on the significance level
#What does the Monte Carlo research and the literature say?


#From specific to general (single-source models)

lm.LMtests(mod.lin, listw = W1_list, test = "all")
lm.LMtests(mod.lin, listw = W2_list, test = "all")
#...which model is indicated by the tests? Which one by the robust tests?

mod.SLM1 <- lagsarlm(l_wynagrodzenie ~ bezrobocie, listw = W1_list, data = spatial_data)
summary(mod.SLM1)
mod.SLM2 <- lagsarlm(l_wynagrodzenie ~ bezrobocie, listw = W2_list, data = spatial_data)
summary(mod.SLM2)

mod.SEM1 <- errorsarlm(l_wynagrodzenie ~ bezrobocie, listw = W1_list, data = spatial_data)
summary(mod.SEM1)
mod.SEM2 <- errorsarlm(l_wynagrodzenie ~ bezrobocie, listw = W2_list, data = spatial_data)
summary(mod.SEM2)

mod.SLX1 <- lmSLX(l_wynagrodzenie ~ bezrobocie, listw = W1_list, data = spatial_data)
summary(mod.SLX1)
mod.SLX2 <- lmSLX(l_wynagrodzenie ~ bezrobocie, listw = W2_list, data = spatial_data)
summary(mod.SLX2)

#What does the theory say? What about tests?


#Multi-source models - does it make sense to estimate all of them individually?

mod.SARAR1 <- sacsarlm(l_wynagrodzenie ~ bezrobocie, listw = W1_list, data = spatial_data)
summary(mod.SARAR1)
mod.SARAR2 <- sacsarlm(l_wynagrodzenie ~ bezrobocie, listw = W2_list, data = spatial_data)
summary(mod.SARAR2)

mod.SDM1 <- lagsarlm(l_wynagrodzenie ~ bezrobocie, listw = W1_list, data = spatial_data, type = "Durbin")
summary(mod.SDM1)
mod.SDM2 <- lagsarlm(l_wynagrodzenie ~ bezrobocie, listw = W2_list, data = spatial_data, type = "Durbin")
summary(mod.SDM2)

mod.SDEM1 <- errorsarlm(l_wynagrodzenie ~ bezrobocie, listw = W1_list, data = spatial_data, etype = "emixed")
summary(mod.SDEM1)
mod.SDEM2 <- errorsarlm(l_wynagrodzenie ~ bezrobocie, listw = W2_list, data = spatial_data, etype = "emixed")
summary(mod.SDEM2)


