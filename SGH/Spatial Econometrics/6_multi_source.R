#INSTALLING PACKAGES (previously installed packages commented - please uncomment if necessary)
# install.packages("sp")
# install.packages("spdep")

#SET WORKING DIRECTORY
setwd("~/Desktop/SGH/2 semester/Spatial Econometrics")

# clear the workspace, plots and console
rm(list = ls())
if(!is.null(dev.list())) dev.off()
cat("\014") 

library(sp)
library(spdep)

#Analysis of Biedronka markets - cont'd. (assume that the code from the previous class prepared the workspace
#or the workspace after its execution is loaded along with the libraries)
#Load previously saved workspace:
load(file = "dane_biedronka_1.RData")
attach(dane.przestrzenne@data)


#SARAR - ML and GS2SLS
model5a <- sacsarlm(biedronki.pc ~ bezrobocie + wynagrodzenie, listw = W_list)
summary(model5a)
res5a <- model5a$residuals
moran.test(res5a, listw = W_list)

model5b <- gstsls(biedronki.pc ~ bezrobocie + wynagrodzenie, listw = W_list)
summary(model5b)
res5b <- model5b$residuals
moran.test(res5b, listw = W_list)

#SDM
model6a <- lagsarlm(biedronki.pc ~ bezrobocie + wynagrodzenie, listw = W_list, type = "Durbin")
summary(model6a)
res6a <- model5a$residuals
moran.test(res6a, listw = W_list)

model6b <- lagsarlm(biedronki.pc ~ bezrobocie + wynagrodzenie + lag.bezrobocie + lag.wynagrodzenie, listw = W_list)
summary(model6b)

#LR test SDM vs SEM (we can test in this way every pair of models)
lL0 <- logLik(model3a)
lL1 <- logLik(model6a)
LRa <- 2 * (lL1 - lL0)
LR.p.value <- pchisq(as.numeric(LRa), df = 2, lower.tail = FALSE)
# Other, simpler method (degrees of freedom displayed incorrectly, but the result is correct):
LRb <- LR.sarlm(lL1, lL0)

#SDEM
model7a <- errorsarlm(biedronki.pc ~ bezrobocie + wynagrodzenie + lag.bezrobocie + lag.wynagrodzenie, listw = W_list)
summary(model7a)
res7a <- model7a$residuals
moran.test(res7a, listw = W_list)

model7b <- errorsarlm(biedronki.pc ~ bezrobocie + wynagrodzenie, etype = "emixed", listw = W_list)
summary(model7b)
res7b <- model7b$residuals
moran.test(res7b, listw = W_list)

#GNS
model8a <- sacsarlm(biedronki.pc ~ bezrobocie + wynagrodzenie, listw = W_list, type = "sacmixed")
summary(model8a)
res8a <- model8a$residuals
moran.test(res8a, listw = W_list)

model8b <- sacsarlm(biedronki.pc ~ bezrobocie + wynagrodzenie + lag.bezrobocie + lag.wynagrodzenie, listw = W_list)
summary(model8b)
res8b <- model8b$residuals
moran.test(res8b, listw = W_list)

#...to be continued:
save.image(file = "dane_biedronka_2.RData")
