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

library(sp)
library(spdep)

#Scripts 5-6 continued (final workspace and packages should be loaded)
load(file = "dane_biedronka_2.RData")
attach(dane.przestrzenne@data)


##### Models without spatial autoregression

#Effects from SLX

SLX <- lmSLX(biedronki.pc ~ bezrobocie + wynagrodzenie, listw = W_list)
impacts.SLX <- impacts(SLX, zstats = TRUE, R = 200)
summary(impacts.SLX)

#Effects from SDEM
SDEM <- errorsarlm(biedronki.pc ~ bezrobocie + wynagrodzenie, etype = "emixed", listw = W_list)
impacts.SDEM <- impacts(SDEM, listw = W_list, zstats = TRUE, R = 200)
summary(impacts.SDEM)


##### Does it really make sense to compute impacts from SEM?
# ...


##### Models with spatial autoregression ##

#Effects from SAR

SAR <- lagsarlm(biedronki.pc ~ bezrobocie + wynagrodzenie, listw = W_list, control = list(fdHess = TRUE))
impacts.SAR <- impacts(SAR, listw = W_list, zstats = TRUE, R = 200)
summary(impacts.SAR)
#Confidence intervals around estimated effects
HPDinterval.lagImpact(impacts.SAR, prob = 0.95, choice = "direct")
HPDinterval.lagImpact(impacts.SAR, prob = 0.95, choice = "indirect")
HPDinterval.lagImpact(impacts.SAR, prob = 0.95, choice = "total")
#Spatial multipliers matrix M
W <- listw2mat(W_list)
N <- dim(W)[1]
rho <- SAR$rho
M <- solve(diag(N) - rho  * W)
#Let us focus on one regressor: wages and compute the standard errors of its spatial multipliers
#METHOD 1: DELTA
b_wyn <- SAR$coefficients["wynagrodzenie"]
S.b_wyn <- M * b_wyn
partial.Sb_wyn.rho <- M %*% W %*% M * b_wyn
partial.Sb_wyn.b_wyn <- M
VCV <- SAR$fdHess
VCV.rho.b_wyn <- solve(matrix(c(VCV["rho", "rho"], VCV["wynagrodzenie", "rho"], 
                        VCV ["rho", "wynagrodzenie"], VCV["wynagrodzenie", "wynagrodzenie"]), 
                      nrow = 2))
S.b_wyn.SE <- matrix(NA, nrow = N, ncol = N)
for(i in 1:N){
  S.b_wyn.gradients <- cbind(partial.Sb_wyn.rho[, i], partial.Sb_wyn.b_wyn[, i])
  S.b_wyn.var <- S.b_wyn.gradients %*% VCV.rho.b_wyn %*% t(S.b_wyn.gradients)
  S.b_wyn.var <- matrix(S.b_wyn.var, ncol = N)
  S.b_wyn.SE[, i] <- diag(sqrt(S.b_wyn.var))
}
rm(partial.Sb_wyn.rho, partial.Sb_wyn.b_wyn, b_wyn, rho, VCV, VCV.rho.b_wyn, S.b_wyn.gradients, S.b_wyn.var)

#Effects from SARAR
SARAR <- sacsarlm(biedronki.pc ~ bezrobocie + wynagrodzenie, listw = W_list)
impacts.SARAR <- impacts(SARAR, listw = W_list, zstats = TRUE, R = 200)
HPDinterval.lagImpact(impacts.SARAR, prob = 0.95, choice = "direct")
HPDinterval.lagImpact(impacts.SARAR, prob = 0.95, choice = "indirect")
HPDinterval.lagImpact(impacts.SARAR, prob = 0.95, choice = "total")

#Effects from SDM
SDM <- lagsarlm(biedronki.pc ~ bezrobocie + wynagrodzenie, listw = W_list, type = "Durbin", control = list(fdHess = TRUE))
impacts.SDM <- impacts(SDM, listw = W_list, zstats = TRUE, R = 200)
HPDinterval.lagImpact(impacts.SDM, prob = 0.95, choice = "direct")
HPDinterval.lagImpact(impacts.SDM, prob = 0.95, choice = "indirect")
HPDinterval.lagImpact(impacts.SDM, prob = 0.95, choice = "total")

#In this model, it is more difficult to evaluate the standard errors with delta method (more involved functional form). Let us try then:
#METHOD 2: BOOTSTRAPPING
R = 100
VCV <- SDM$fdHess
VCV.rho.b_wyn <- solve(matrix(c(VCV["rho", "rho"], VCV["wynagrodzenie", "rho"], VCV["lag.wynagrodzenie", "rho"], 
                          VCV ["rho", "wynagrodzenie"], VCV["wynagrodzenie", "wynagrodzenie"], VCV["lag.wynagrodzenie", "wynagrodzenie"],
                          VCV ["rho", "lag.wynagrodzenie"], VCV["wynagrodzenie", "lag.wynagrodzenie"], VCV["lag.wynagrodzenie", "lag.wynagrodzenie"]), 
                        nrow = 3))
rho <- SDM$rho
b_wyn <- SDM$coefficients["wynagrodzenie"]
theta_wyn <- SDM$coefficients["lag.wynagrodzenie"]
library(MASS)
samp <- mvrnorm(n = R, mu = c(rho, b_wyn, theta_wyn),
                Sigma = VCV.rho.b_wyn, empirical = T)	
S.b_wyn <- apply(samp, 1, function (x) (solve(diag(N) - x[1] * W) * (diag(N) * x[2] + W * x[3])))
c025 <- apply(S.b_wyn, 1, function(x) quantile(x, probs = c(0.025)))
c975 <- apply(S.b_wyn, 1, function(x) quantile(x, probs = c(0.975)))
S.b_wyn.025 <- matrix(c025, nrow = sqrt(length(c025)))
S.b_wyn.975 <- matrix(c975, nrow = sqrt(length(c975)))
rm(rho, b_wyn, theta_wyn, VCV, VCV.rho.b_wyn, samp, c025, c975)

