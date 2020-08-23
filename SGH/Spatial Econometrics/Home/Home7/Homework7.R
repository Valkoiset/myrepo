

#INSTALLING PACKAGES (previously installed packages commented - please uncomment if necessary)
# install.packages("sp")
# install.packages("spdep")
# install.packages("MASS")

#SET WORKING DIRECTORY
setwd("~/Desktop/SGH/2 semester/Spatial Econometrics")

# clear the workspace, plots and console
rm(list = ls())
if(!is.null(dev.list())) dev.off()
cat("\014") 

library(rgdal)
library(sp)
library(spdep)

#Scripts 5-6 continued (final workspace and packages should be loaded)
map <-
  readOGR(dsn = "spatial_data",
          layer = "spatial_final",
          stringsAsFactors = F)
map <- spTransform(map, "+proj=longlat")
plot(map)

cont1 <- poly2nb(map, queen = T)
W1_list <- nb2listw(cont1, style = "W", zero.policy = T)
lm.morantest(mod.lin, W1_list, alternative = "greater", zero.policy = T)

# ------- Models without spatial autoregression -------
# Effects from SLX
SLX <- lmSLX(Deaths ~ Fertlty, listw = W1_list, data = map, zero.policy = T)
impacts.SLX <- impacts(SLX, zstats = TRUE, R = 200)
summary(impacts.SLX)

# Effects from SDEM
SDEM <- errorsarlm(Deaths ~ Fertlty, listw = W1_list, data = map, etype = "emixed", zero.policy = T)
impacts.SDEM <- impacts(SDEM, listw = W_list, zstats = TRUE, R = 200)
summary(impacts.SDEM)

##### Does it really make sense to compute impacts from SEM?
# ...


# ------- Models with spatial autoregression -------
# Effects from SAR
SAR <- lagsarlm(Deaths ~ Fertlty, listw = W1_list, data = map, type = "Durbin", zero.policy = T)
impacts.SAR <- impacts(SAR, listw = W1_list, zstats = TRUE, R = 200)
summary(impacts.SAR)

# Confidence intervals around estimated effects
HPDinterval.lagImpact(impacts.SAR, prob = 0.95, choice = "direct")
HPDinterval.lagImpact(impacts.SAR, prob = 0.95, choice = "indirect")
HPDinterval.lagImpact(impacts.SAR, prob = 0.95, choice = "total")

# Effects from SARAR
SARAR <- sacsarlm(Deaths ~ Fertlty, listw = W1_list, data = map, zero.policy = T)
impacts.SARAR <- impacts(SARAR, listw = W1_list, zstats = TRUE, R = 200)
summary(impacts.SARAR)
HPDinterval.lagImpact(impacts.SARAR, prob = 0.95, choice = "direct")
HPDinterval.lagImpact(impacts.SARAR, prob = 0.95, choice = "indirect")
HPDinterval.lagImpact(impacts.SARAR, prob = 0.95, choice = "total")

# Effects from SDM
SDM <- lagsarlm(Deaths ~ Fertlty, listw = W1_list, data = map, type = "Durbin", zero.policy = T)
impacts.SDM <- impacts(SDM, listw = W1_list, zstats = TRUE, R = 200)
summary(impacts.SDM)
HPDinterval.lagImpact(impacts.SDM, prob = 0.95, choice = "direct")
HPDinterval.lagImpact(impacts.SDM, prob = 0.95, choice = "indirect")
HPDinterval.lagImpact(impacts.SDM, prob = 0.95, choice = "total")



