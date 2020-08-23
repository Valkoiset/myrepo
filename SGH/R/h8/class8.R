  # grid - package
  # Program 1
  # simple dot point chart
  # creating views
  # View below define margins with 5 lines from the bottom, 4 lines from left side
  # and 2 lines from the top and right side.
  
library(grid)
pushViewport(plotViewport(c(5, 4, 2, 2))) # function to create a new view

# Next view define the data layer.

pushViewport(dataViewport(pressure$temperature, 
                          pressure$pressure,
                          name="plotRegion"))

# code below will add points to the deined views

# cex = size of points
grid.points(pressure$temperature, pressure$pressure, gp=gpar(cex=0.5))

grid.rect()
grid.xaxis()
grid.yaxis()
grid.text("temperature", y=unit(-3, "line"))
grid.text("pressure", x=unit(-3, "line"), rot=90)

# Program 2 - several charts in separate panels

pushViewport(viewport(layout=grid.layout(2, 2), gp=gpar(cex=0.6, fill=NA)))
pushViewport(viewport(layout.pos.col=1, layout.pos.row=1))
pushViewport(plotViewport(c(5, 4, 2, 2)))
pushViewport(dataViewport(pressure$temperature, 
                          pressure$pressure,
                          name="plotRegion"))

grid.points(pressure$temperature, pressure$pressure, 
            gp=gpar(cex=0.5))
grid.rect()
grid.xaxis()
grid.yaxis()
grid.text("temperatura", y=unit(-3, "line"))
grid.text("ci??nienie", x=unit(-3, "line"), rot=90)

popViewport(3)
pushViewport(viewport(layout.pos.col=2, layout.pos.row=1))
pushViewport(plotViewport(c(5, 4, 2, 2)))
pushViewport(dataViewport(pressure$temperature, 
                          pressure$pressure,
                          name="plotRegion"))

grid.points(pressure$temperature, pressure$pressure, pch=2, 
            gp=gpar(cex=0.5))
grid.rect()
grid.xaxis()
grid.yaxis()
grid.text("temperatura", y=unit(-3, "line"))
grid.text("ci??nienie", x=unit(-3, "line"), rot=90)


# popViewport function deletes a number of defined views (in this case 3)


popViewport(3)
pushViewport(viewport(layout.pos.col=2, layout.pos.row=2))
pushViewport(plotViewport(c(5, 4, 2, 2)))
pushViewport(dataViewport(pressure$temperature, 
                          pressure$pressure,
                          name="plotRegion"))

grid.points(pressure$temperature, pressure$pressure, pch=2, 
            gp=gpar(cex=0.5))
grid.rect()
grid.xaxis()
grid.yaxis()
grid.text("temperatura", y=unit(-3, "line"))
grid.text("ci??nienie", x=unit(-3, "line"), rot=90)


# UpViewport function allow to move back to previously created views.
# downViewport function allow to move forward to previously created views.


upViewport(2)
grid.rect(gp=gpar(lty="dashed"))

downViewport("plotRegion")
grid.text("Wp??yw ci??nienia (mm Hg)\nna\nTemperatur?? (Celsius)",
          x=unit(150, "native"), y=unit(600, "native"))


# Program 3 - Example of simple chart in grid package.

grid.rect(gp=gpar(col="gray"))
grid.circle(x=seq(0.1, 0.9, length=100), 
            y=0.5 + 0.4*sin(seq(0, 2*pi, length=100)),
            r=abs(0.1*cos(seq(0, 2*pi, length=100))))

# parameters of grid.circle(x,y,r) function:

# x - coordinate x
# y - coordinate y
# r - radius

# Program 4 - curves

grid.rect(gp=gpar(col="gray"))

# Function below defines 6 points


grid.circle(c(.1, .3, .4, .6, .7, .9), 
            c(.25, .75), r=unit(1, "mm"),
            gp=gpar(col=NA, fill="gray"))

# Example 1 - for the first curve we declare begining and end points


grid.curve(x1=.1, y1=.25, x2=.3, y2=.75)

# Example 2 - parametry ncp i curvature

grid.curve(x1=.4, y1=.25, x2=.6, y2=.75,
           square=FALSE, ncp=8, curvature=.5)

# parameter ncp decides about number of points on the curve (the more points the smoother curve)

# parametr curvature decyduje o stopniu wypuk??o??ci krzywej, parametr ten mo??e by?? dodatni lub ujemny

# parametr curvature decides about a convex of curve.

# Example 3

# angle parameter decides about angle of curve , arguments of angle parameter 
# should be between 0 and 180

# shape parameter decides about shape of the curve, please run the code below
# with shape equal -1, 0 and 1

grid.curve(x1=.7, y1=.25, x2=.9, y2=.75,
           square=FALSE, angle=45, shape=-1)

# Program 5 - arrows

grid.rect(gp=gpar(col="gray"))
angle <- seq(0, 2*pi, length=50)
grid.lines(x=seq(0.1, 0.5, length=50), 
           y=0.5 + 0.3*sin(angle), arrow=arrow())
grid.segments(6:8/10, 0.2, 7:9/10, 0.8,
              arrow=arrow(angle=15, type="closed"))

# parameter arrow could have the following values
# angle - angle of the arrow head
# lenghth - length of the arrow
# ends could have values : last , first or both decide about position of arrow head
# type could have values: open or closed and decide about shape of arrow head
# parametr arrow mo??e przyjmowa?? nast??puj??ce warto??ci: 


# Program 6 - polygons

# Example 1

grid.newpage()
grid.polygon(x=c((0:4)/10, rep(.5, 5), (10:6)/10, rep(.5, 5)),
             y=c(rep(.5, 5), (10:6/10), rep(.5, 5), (0:4)/10),
             id=rep(1:5, 4),
             gp=gpar(fill=1:5))

# x and y coordinates of polygon vertex's
# id polygons identyfiers on the same chart
# gp list of polygon graphical settings

# Example 2

grid.rect(gp=gpar(col="gray"))
angle <- seq(0, 2*pi, length=10)[-10]
grid.polygon(x=0.25 + 0.15*cos(angle), y=0.5 + 0.3*sin(angle), 
             gp=gpar(fill="gray"))
grid.polygon(x=0.75 + 0.15*cos(angle), y=0.5 + 0.3*sin(angle), 
             id=rep(1:3, each=3),
             gp=gpar(fill="gray"))


# Program 7 - Adding viewport (viewport)

grid.rect(gp=gpar(col="gray"))
grid.text("top-left corner", x=unit(1, "mm"),
          y=unit(1, "npc") - unit(1, "mm"), 
          just=c("left", "top"))
pushViewport(viewport(width=0.8, height=0.5, angle=10, 
                      name="vp1"))
grid.rect()
grid.text("top-left corner", x=unit(1, "mm"),
          y=unit(1, "npc") - unit(1, "mm"), 
          just=c("left", "top"))


grid.circle(x=seq(0.1, 0.9, length=100), 
            y=0.5 + 0.4*sin(seq(0, 2*pi, length=100)),
            r=abs(0.1*cos(seq(0, 2*pi, length=100))))

# Program 8 - adding several views

grid.rect(gp=gpar(col="gray"))
grid.text("top-left corner", x=unit(1, "mm"),
          y=unit(1, "npc") - unit(1, "mm"), 
          just=c("left", "top"))
pushViewport(viewport(width=0.8, height=0.5, angle=10, 
                      name="vp1"))
grid.rect()
grid.text("top-left corner", x=unit(1, "mm"),
          y=unit(1, "npc") - unit(1, "mm"), 
          just=c("left", "top"))

pushViewport(viewport(width=0.8, height=0.5, angle=10, 
                      name="vp2"))
grid.rect()
grid.text("top-left corner", x=unit(1, "mm"),
          y=unit(1, "npc") - unit(1, "mm"), 
          just=c("left", "top"))

# Program 9 - deleting viewport - popViewport

# Default argument of popViewport is 1 and means that last defined viewport will
# be deleted. Argument 0 means that all defined viewports will be deleted.

popViewport()
grid.text("bottom-right corner", 
          x=unit(1, "npc") - unit(1, "mm"),
          y=unit(1, "mm"), just=c("right", "bottom"))

# Program 10 - moving between views - upViewport()


upViewport()
grid.text("down-right corner", 
          x=unit(1, "npc") - unit(1, "mm"),
          y=unit(1, "mm"), just=c("right", "bottom"))
downViewport("vp1")
grid.rect(width=unit(1, "npc") + unit(2, "mm"),
          height=unit(1, "npc") + unit(2, "mm"))

# Program 11 - Creating several views on same level

# Example 1

vp1<-viewport(name="A")
vp2<-viewport(name="B")
vp3<-viewport(name="C")

# Function vpList create several views on the same level.

pushViewport(vpList(vp1,vp2,vp3))

# Function current.vpTree shows views hierarchy

current.vpTree()

#Przyk??ad 2
# Function vpStack creates views hierarchy.


grid.newpage()
pushViewport(vpStack(vp1,vp2,vp3))
current.vpTree()

# Program 12 - Embeding lattice charts in the grid views

library(lattice)
trellis.par.set(theme = canonical.theme("postscript", color=FALSE))
grid.newpage()
pushViewport(viewport(x=0, width=.4, just="left"))
print(barchart(table(mtcars$gear)),
      newpage=FALSE)
popViewport()
pushViewport(viewport(x=.4, width=.6, just="left"))
print(xyplot(mpg ~ disp, data=mtcars,
             group=gear, 
             auto.key=list(space="right"),
             par.settings=list(superpose.symbol=list(pch=c(1, 3, 16),
                                                     fill="white"))),
      newpage=FALSE)
popViewport()

# Program 13 - Embeding ggplot2 charts in grid views

mtcars2 <- mtcars
mtcars2$trans <- factor(mtcars$am, 
                        levels=0:1, 
                        labels=c("automatic", "manual"))
mtcars2$gear <- as.factor(mtcars$gear)
mtcars2$am <- NULL
mtcars2$vs <- NULL
mtcars2$drat <- NULL
mtcars2$carb <- NULL


library(ggplot2)
grid.newpage()
pushViewport(viewport(x=0, width=1/3, just="left"))
print(ggplot(mtcars2, aes(x=trans)) + 
        geom_bar(),
      newpage=FALSE)
popViewport()
pushViewport(viewport(x=1/3, width=2/3, just="left"))
print(ggplot(mtcars2, aes(x=disp, y=mpg)) +
        geom_point(aes(color=trans)) +
        scale_color_manual(values=gray(2:1/3)),
      newpage=FALSE)
popViewport()

pushViewport(viewport(layout=grid.layout(2,2)))

print(m, vp=viewport(layout.pos.row = 1, layout.pos.col = 1))
print(n, vp=viewport(layout.pos.row = 1, layout.pos.col = 2))
print(z, vp=viewport(layout.pos.row = 2, layout.pos.col = 1))
print(y, vp=viewport(layout.pos.row = 2, layout.pos.col = 2))

grid.arrange(m,n,y,z, nrow=2, ncol=2)
