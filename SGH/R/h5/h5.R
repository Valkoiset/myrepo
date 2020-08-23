
library(sandwich)
data(Investment, package="sandwich")
Investment_data <- data.frame(Years=c(1963:1982),Investment)

# Investments in the USA, an annual time series from 1963 to 1982 with 7 variables. 

# Please investigate factors  related to investments in the USA, create visualization using lattice package.

#Graph 1
library(latticeExtra)
a<-xyplot(GNP~Investment,Investment_data, pch=0)
b<-xyplot(Interest~Investment, Investment_data, pch=1)
c<-c(a, b, layout = 1:2)
update(c, scales = list(y = list(rot = 0)), ylab = c("GNP", "Interest Rate"))

#Graph 2
library(latticeExtra)
a<-xyplot(Investment~Years,Investment_data, pch=0)
b<-xyplot(RealInt~Years, Investment_data, pch=1)
c<-xyplot(GNP~Years, Investment_data, pch=2)
graph<-c(a, b, c, layout=c(1, 3))
update(graph, scales = list(y = list(rot = 0)), ylab = c("Investments", "Real Interest","GNP"),
       panel=function(x, y) {
         panel.loess(x, y)
         panel.xyplot(x, y)
       })

#Graph 3
xyplot(Investment~GNP, Investment_data, pch=0,
       panel=function(x, y) {
         panel.lmline(x, y)
         panel.xyplot(x, y)
       })

#Graph 4

xyplot(Interest~Years,Investment_data, type="l")





