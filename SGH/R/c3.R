# Chart regions

plot(c(0, 1), c(0, 1), type="n", ann=FALSE, axes=FALSE)
box("outer", col="gray")

# Chart region settings

# xpd=NA - window area
# xpd=TRUE - current region
# xpd=FALSE - current plot region (default value)

par(xpd=TRUE)

# Creating rectangle

rect(-1, -1, 2, 2, col="gray90")

box("figure")
par(xpd=FALSE)

# Create rectangle

rect(-1, -1, 2, 2, col="gray80")
box("plot", lty="dashed")
text(.5, .5, "Plot region")
mtext("Window region", side=3, line=2)


## Adding legend to chart

# Example 1
x <- 0:64/64
y <- sin(3*pi*x)
plot(x, y, type = "l", col = "blue",main = "Dodawanie punkt??w i legendy(*, pt.bg)")
points(x, y, pch = 21, bg = "white")
legend(.4,1, "sin(c x)", pch = 21, pt.bg = "white", lty = 1, col = "blue")


# Example 2

par(mfrow=c(2, 1), mar=c(5, 3, 2, 1), cex=0.5, pty="s")
with(iris,
     plot(Sepal.Length, Sepal.Width, 
          pch=as.numeric(Species), cex=1.2))
legend(6.1, 4.4, c("setosa", "versicolor", "virginica"), 
       cex=1.5, pch=1:3)

barplot(VADeaths[1:2,], angle=c(45, 135), density=20, 
        col="gray", names=c("RM", "RF", "UM", "UF"))
legend(0.4, 38, c("55-59", "50-54"), cex=1.5,
       angle=c(135, 45), density=20, fill="gray")

## Chart annotations

# Example 1

par(cex=0.7)
x <- 1:10
y <- matrix(sort(rnorm(30)), ncol=3)
plot(x, y[,1], ylim=range(y), ann=FALSE, axes=FALSE, 
     type="l", col="gray")
box(col="gray")

points(x, y[,1])
lines(x, y[,2], col="gray")
points(x, y[,2], pch=2)
lines(x, y[,3], col="gray")
points(x, y[,3], pch=3)

legend(1,1.8, c("a","b","c"),cex=1.5, pch=1:3)
mtext("points() & lines()", side=3, line=0.5)

# Example 2

x <- 1:5
y <- x
plot(x, y, ann=FALSE, axes=FALSE, col="gray", pch=16)
box(col="gray")

text(x[-3], y[-3], c("right", "top", "bottom", "left"), 
     pos=c(4, 3, 1, 2))
text(3, 3, "overlay")

# Example 3

par(mar=c(1, 1, 2, 1), pty="s")
par(cex=1)
x <- runif(20, 1, 10)
y <- x + rnorm(20)
plot(x, y, ann=FALSE, axes=FALSE, col="gray", pch=16)
box(col="gray")

lmfit <- lm(y ~ x)
abline(lmfit)
arrows(5, 8, 7, predict(lmfit, data.frame(x=7)),
       length=0.1)
text(5, 8, "Line of best fit", pos=3)

# Chart comparison

par(mar=c(2, 1, 1, 1))
y1 <- rnorm(100)
y2 <- rnorm(100)

par(mfrow=c(2, 1), xpd=NA)

plot(y1, type="l", axes=FALSE,
     xlab="", ylab="", main="")
box(col="gray")
mtext("Left end of margin", adj=0, side=3)
lines(x=c(20, 20, 40, 40), y=c(-7, max(y1), max(y1), -7), 
      lwd=3, col="gray")

plot(y2, type="l", axes=FALSE,
     xlab="", ylab="", main="")
box(col="gray")
mtext("Right end of margin", adj=1, side=3)
mtext("Label below x=30", at=30, side=1)
lines(x=c(20, 20, 40, 40), y=c(7, min(y2), min(y2), 7), 
      lwd=3, col="gray")

# Defining axes

# Example 1

require(stats) # for rnorm
plot(1:4, rnorm(4), axes = FALSE)
axis(1, 1:4, LETTERS[1:4])
axis(2)
box() #- to make it look "as usual"

# Example 2

plot(1:7, rnorm(7), main = "axis() examples",
     type = "s", xaxt = "n", frame = FALSE, col = "red")
axis(1, 1:7, LETTERS[1:7], col.axis = "blue")
# unusual options:
axis(4, col = "violet", col.axis = "dark violet", lwd = 2)
axis(3, col = "gold", lty = 2, lwd = 0.5)

# Example of creating specific chart

par(cex=0.8)
x <- 1:2
y <- runif(2, 0, 100)
par(mar=c(4, 4, 2, 4))
plot(x, y, type="n", xlim=c(0.5, 2.5), ylim=c(-10, 110),
     axes=FALSE, ann=FALSE)

axis(2, at=seq(0, 100, 20))
mtext("Temperature (Centigrade)", side=2, line=3)

axis(1, at=1:2, labels=c("Treatment 1", "Treatment 2"))
axis(4, at=seq(0, 100, 20), labels=seq(0, 100, 20)*9/5 + 32)
mtext("Temperature (Fahrenheit)", side=4, line=3)
box()

segments(x, 0, x, 100, lwd=20)
segments(x, 0, x, 100, lwd=16, col="white")
segments(x, 0, x, y, lwd=16, col="gray")





