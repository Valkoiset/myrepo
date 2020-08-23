

#INSTALLING PACKAGES (previously installed packages commented - please uncomment if necessary)
# install.packages("rgdal")
# install.packages("sp")
# install.packages("spdep")

library(rgdal)
library(sp)
library(spdep)

#SET WORKING DIRECTORY
setwd("~/Desktop/SGH/2 semester/Spatial Econometrics")

# clear the workspace, plots and console
rm(list = ls())
if(!is.null(dev.list())) dev.off()
cat("\014")

# Map of Germany with already chosen and merged variables x (Deaths (number of
# deaths in each region in 2017)) and Fertility rate
map <-
  readOGR(dsn = "spatial_data",
          layer = "spatial_final",
          stringsAsFactors = F)
map <- spTransform(map, "+proj=longlat")

plot(map)

#Linear model (from specific...?)
map@data$l_Deaths <- log(map@data$Deaths)
mod.lin <- lm(l_Deaths ~ Fertlty, data = map)
summary(mod.lin)

cont1 <- poly2nb(map, queen = T)
W1_list <- nb2listw(cont1, style = "W", zero.policy = T)
lm.morantest(mod.lin, W1_list, alternative = "greater", zero.policy = T)

#General model GNS (from general...?)
mod.GNS1 <- sacsarlm(l_Deaths ~ Fertlty, listw = W1_list, data = map,
                     type = "sacmixed", zero.policy = T)
summary(mod.GNS1)
#Depends on W matrix! (which one is the best in socio-economic terms?)
#...and on the significance level
#What does the Monte Carlo research and the literature say?


#From specific to general (single-source models)
lm.LMtests(mod.lin, listw = W1_list, test = "all", zero.policy = T)

#...which model is indicated by the tests? Which one by the robust tests?
mod.SLM1 <- lagsarlm(l_Deaths ~ Fertlty, listw = W1_list, data = map, zero.policy = T)
summary(mod.SLM1)

mod.SEM1 <- errorsarlm(l_Deaths ~ Fertlty, listw = W1_list, data = map, zero.policy = T)
summary(mod.SEM1)

mod.SLX1 <- lmSLX(l_Deaths ~ Fertlty, listw = W1_list, data = map, zero.policy = T)
summary(mod.SLX1)

#Multi-source models - does it make sense to estimate all of them individually?
mod.SARAR1 <- sacsarlm(l_Deaths ~ Fertlty, listw = W1_list, data = map, zero.policy = T)
summary(mod.SARAR1)

mod.SDM1 <- lagsarlm(l_Deaths ~ Fertlty, listw = W1_list, data = map, type = "Durbin", zero.policy = T)
summary(mod.SDM1)

mod.SDEM1 <- errorsarlm(l_Deaths ~ Fertlty, listw = W1_list, data = map, etype = "emixed", zero.policy = T)
summary(mod.SDEM1)

save.image(file = "data_kindergartens.RData")

