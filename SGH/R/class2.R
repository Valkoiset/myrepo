# Package graphics

# Multiple variables charts

# Program 1

mdf <- cbind(3:6, (3:6)^2, (3:6)^3)
names(mdf) <- c("Y1", "Y2", "Y3")
matplot(mdf, pch=21:23, bg=c("white",  "black", "gray"), type="o",col="black", xlim=c(0, 6), ylim=c(-10,  230))

# Program 2 - star charts

USJudge <- apply(USJudgeRatings, 2, function(x) x/max(x))
Jnam <- row.names(USJudgeRatings)
Snam <- abbreviate(substring(Jnam, 1, regexpr("[,.]",Jnam) - 1), 7)
stars(USJudge, labels = Jnam, scale = FALSE,
      key.loc = c(13, 1.5), main = "Judge not ...", len = 0.8)
stars(USJudge, labels = Snam, scale = FALSE,
      key.loc = c(13, 1.5), radius = FALSE)

loc <- stars(USJudge, labels = NULL, scale = FALSE,
             radius = FALSE, frame.plot = TRUE,
             key.loc = c(13, 1.5), main = "Judge not ...", len = 1.2)
text(loc, Snam, col = "blue", cex = 0.8, xpd = TRUE)

## 'Segments':
stars(USJudge, draw.segments = TRUE, scale = FALSE, key.loc = c(13,1.5))

## 'Radar-Segments'
stars(USJudgeRatings[1:10,], locations = 0:1, scale = FALSE, draw.segments = TRUE, col.segments = 0, col.stars = 1:10, key.loc =  0:1, main = "US Judges 1-10 ")

#program 3 - Contour charts
aaa <- seq(0, pi, length=10)
xxx <- rep(aaa, 10)
yyy <- rep(aaa, each=10)
zzz <- sin(xxx) + sin(yyy)
image(matrix(zzz, ncol=10), col=gray(1:12/13))
contour(matrix(zzz, ncol=10), levels=seq(0, 2, .25), labcex=.8)

#Program 4 - Contour charts

x <- 10*(1:nrow(volcano))
y <- 10*(1:ncol(volcano))
image(x, y, volcano, col = terrain.colors(100), axes = FALSE)
contour(x, y, volcano, levels = seq(90, 200, by = 5),
        add = TRUE, col = "peru")
axis(1, at = seq(100, 800, by = 100))
axis(2, at = seq(100, 600, by = 100))
box()
title(main = "Maunga Whau Volcano", font.main = 4)

# Program 5

# 3D visualisations

z <- 2 * volcano        # Exaggerate the relief
x <- 10 * (1:nrow(z))   # 10 meter spacing (S to N)
y <- 10 * (1:ncol(z))   # 10 meter spacing (E to W)
## Don't draw the grid lines :  border = NA
par(bg = "slategray")
persp(x, y, z, theta = 135, phi = 30, col = "green3", scale = FALSE,
      ltheta = -160, shade = 0.75, border = NA, box = FALSE) # theta - for rotaing
# horizontally, phi - vertically, ltheta - angle of light of shade

# Program 6

# 3D visualisations

aaa <- seq(0, pi, length=10)
xxx <- rep(aaa, 10)
yyy <- rep(aaa, each=10)
zzz <- sin(xxx) + sin(yyy)

persp(matrix(zzz, ncol=10), theta=30, phi=45, col="gray")

symbols(xxx, yyy, circles=zzz, inches=.08) # size of bubbles

# Program 7 - mosaicplot

aa<-table(factor(rep(1:3, each=6)), factor(c(rep(1:3, 3:1), rep(1:3, 2), rep(1:3, 1:3))))
mosaicplot(aa,cex.axis=.1, off=10)

# Program 8 - boxplot

par(mfrow=c(2, 2), mar=c(2.5, 2, 1, 1), cex=0.6)
boxplot(decrease ~ treatment, data = OrchardSprays,log="y",
        col="light gray")
boxplot(decrease ~ treatment, data = OrchardSprays,
        log = "y", col="light gray", 
        boxwex=0.5) # boxwex regulates width of the boxes (default value = 1)

# barplot


barplot(VADeaths[1:2,], angle = c(45, 135), 
        density = 20, col = "gray",
        names=c("RM", "RF", "UM", "UF"))
barplot(VADeaths[1:2,], angle = c(45, 135), 
        density = 20, col = "gray",
        names=c("RM", "RF", "UM", "UF"),
        horiz=TRUE) # horiz rotates the plot

# matrixplot

library(BCA)
library(car)
library(corrplot)
data(Eggs)


pairs(Eggs, panel = panel.smooth, main ="Eggs")



scatterplotMatrix(~Beef.Pr+Cases+Cereal.Pr+Chicken.Pr+Egg.Pr+Pork.Pr+Week, reg.line=lm, smooth=TRUE, spread=FALSE, span=0.5, id.n=0, diagonal = 'boxplot', data=Eggs)

a<-data.frame(Eggs$Beef.Pr,Eggs$Cases,Eggs$Cereal.Pr,Eggs$Chicken.Pr,Eggs$Egg.Pr,Eggs$Pork.Pr,Eggs$Week)
b<-cor(a)
corrplot(b)
corrplot(b, method="number")
corrplot(b, method="color")
corrplot(b, method="pie")
corrplot(b, method="square")
corrplot(b, method="ellipse")

Eggs<-read.csv2("http://jolej.linuxpl.info/Eggs.csv", header=TRUE) 

Eggs







