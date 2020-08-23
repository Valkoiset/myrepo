

# Lattice package

x <- 1:5
y <- 1:5
g <- factor(1:5)
angle <- seq(0, 2*pi, length=19)[-19]
xx <- cos(angle)
yy <- sin(angle)
gg <- factor(rep(1:3, each=6))

aaa <- seq(0, pi, length=10)
xxx <- rep(aaa, 10)
yyy <- rep(aaa, each=10)
zzz <- sin(xxx) + sin(yyy)


# Program 1
# Point chart

library(lattice)
trellis.par.set(list(dot.symbol=list(pch=1)))

xyplot(pressure ~ temperature, pressure)


#Program 2
# Point chart

library(lattice)
tplot <- xyplot(pressure ~ temperature, pressure)
trellis.par.set(list(dot.symbol=list(pch=1)))

xyplot(pressure ~ temperature, pressure,
       type="o", pch=16, lty=4, # "o" means it would be points and lines
       main="Vapor Pressure of Mercury")



#Program 3
# Bar chart

library(lattice)
x <- 1:5
g <- factor(1:5)
barchart( y ~ g | "Bar chart")

#Program 4
# Density plot, example 1

library(lattice)
densityplot(  ~ yy | "Density plot")

#Program 5
# Density plot, example 2

library(stats)
densityplot( ~ height | voice.part, data = singer, layout = c(2, 4),  
             xlab = "Height (inches)", bw = 5) # "bw" regulates accuracy of chart

#Program 6
#Histogram

library(lattice)
angle <- seq(0, 2*pi, length=19)[-19]
xx <- cos(angle)
histogram( ~ xx | "Histogram")

#Program 7 
#Stripplot, Example 1

library(lattice)
angle <- seq(0, 2*pi, length=19)[-19]
yy <- sin(angle)
gg <- factor(rep(1:3, each=6))
library(lattice)
stripplot(yy ~ gg | "Stripplot")

#Program 8
#Stripplot, example 2

library(lattice)
library(stats)
stripplot(voice.part ~ jitter(height), data = singer, aspect = 1, # aspect regulates
                                        # how many space in wondow to take for chart
          jitter.data = TRUE, xlab = "Height (inches)")

#Program 9
# Point chart

angle <- seq(0, 2*pi, length=19)[-19]
xx <- cos(angle)
yy <- sin(angle)
xyplot(xx ~ yy | "Point chart")

#Program 10

library(lattice)
angle <- seq(0, 2*pi, length=19)[-19]
zzz <- sin(xxx) + sin(yyy)
xxx <- rep(aaa, 10)
yyy <- rep(aaa, each=10)
levelplot(zzz ~ xxx + yyy | "Levelplot")


#Program 11
# Contourplot

library(lattice)
angle <- seq(0, 2*pi, length=19)[-19]
zzz <- sin(xxx) + sin(yyy)
xxx <- rep(aaa, 10)
yyy <- rep(aaa, each=10)
contourplot(zzz ~ xxx + yyy | "Wykres poziomicowy")

#Program 12
#Cloud

library(lattice)
angle <- seq(0, 2*pi, length=19)[-19]
zzz <- sin(xxx) + sin(yyy)
xxx <- rep(aaa, 10)
yyy <- rep(aaa, each=10)

cloud(zzz ~ xxx + yyy | "Cloud")


#Program 13
#Wireframe

library(lattice)
angle <- seq(0, 2*pi, length=19)[-19]
zzz <- sin(xxx) + sin(yyy)
xxx <- rep(aaa, 10)
yyy <- rep(aaa, each=10)

wireframe(zzz ~ xxx + yyy | "Wireframe",drape=TRUE)




#Program 14
# Matrix plot


library(lattice)
super.sym <- trellis.par.get("superpose.symbol")
splom(~iris[1:4], groups = Species, data = iris,
      panel = panel.superpose,
      key = list(title = "Three Varieties of Iris",
                 columns = 3, 
                 points = list(pch = super.sym$pch[1:3],
                               col = super.sym$col[1:3]),
                 text = list(c("Setosa", "Versicolor", "Virginica"))))

splom(~iris[1:3]|Species, data = iris, 
      layout=c(2,2), pscales = 0,
      varnames = c("Sepal\nLength", "Sepal\nWidth", "Petal\nLength"),
      page = function(...) {
        ltext(x = seq(.6, .8, length.out = 4), 
              y = seq(.9, .6, length.out = 4), 
              labels = c("Three", "Varieties", "of", "Iris"),
              cex = 2)
      })


#Program 15
# Parallel plot

library(lattice)
angle <- seq(0, 2*pi, length=19)[-19]
yy <- sin(angle)
gg <- factor(rep(1:3, each=6))


parallelplot(~ as.data.frame(split(yy, gg)) | "Wykres r??wnoleg??y")

#Przyk??ad 2
library(BCA)
data(Eggs, package="BCA")
parallelplot(~Eggs[4:5] | "Wykres r??wnoleg??y")

parallelplot(iris)
# Program 19
# Box plot

#Example 1
bwplot(decrease ~ treatment, OrchardSprays)
decrease

#Example 2
bwplot(voice.part ~ height, data=singer, xlab="Height (inches)")
dim(voice.part)

