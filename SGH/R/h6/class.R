
library(ggplot2)
# ggplot2 package 

# funkcja qplot - equivalent of plot function in graphics package.

# Program 1

qplot(temperature, pressure, data=pressure)

# Program 2

qplot(temperature, pressure, data=pressure,
      main="Vapor Pressure of Mercury",
      geom=c("point", "line"))

qplot(temperature, pressure, data=pressure,
      main="Vapor Pressure of Mercury",
      geom=c("point", "line"), lty=I("dashed"))

# Program 3
# Different examples of qplot function

qplot(mpg, wt, data=mtcars)
qplot(mpg, wt, data=mtcars, colour=factor(cyl))
qplot(mpg, wt, data=mtcars, size=cyl)
qplot(mpg, wt, data=mtcars, facets=vs ~ am)

# Program 4

c <- ggplot(mtcars, aes(factor(cyl)))

# First line define data

c + geom_bar()


# second line define plot layer (in this case type of chart)

# Program 5

mtcars2 <- mtcars
mtcars2$trans <- factor(mtcars$am, 
                        levels=0:1, 
                        labels=c("automatic", "manual"))
mtcars2$gear <- as.factor(mtcars$gear)
mtcars2$am <- NULL
mtcars2$vs <- NULL
mtcars2$drat <- NULL
mtcars2$carb <- NULL
mtcars2$wt <- NULL
mtcars2$hp <- NULL
mtcars2$qsec <- NULL

# Declaration of data wchich will be used
p <- ggplot(mtcars2)

# Definition of chart type

print(
  p + geom_point(aes(x=disp, y=mpg))
  
)

# Annotations definition

print(
  p + geom_text(aes(x=disp, y=mpg, label=gear))
  
)

# Definition of regression line


lmcoef <- coef(lm(mpg ~ disp, mtcars2))

print(
  p + geom_point(aes(x=disp, y=mpg)) +
    geom_abline(intercept=lmcoef[1], slope=lmcoef[2])
  
)

# Program 6
# barplot charts in  ggplot2 package.

qplot(factor(cyl), mpg, data = mtcars, geom = "boxplot")

# Program 7
# Example of the same chart using layers

p <- ggplot(mtcars, aes(factor(cyl), mpg))

p + geom_boxplot()

# adding boxplot layer with points

p + geom_boxplot() + geom_jitter()


# boxplot chart rotated  90 degrees
p + geom_boxplot() + coord_flip()

# boxplot witch notches

p + geom_boxplot(notch = TRUE) # notch shows the distribution of variable

# boxplot with green outliers

p <- ggplot(mtcars, aes(factor(cyl), mpg))
p + geom_boxplot(outlier.colour = "green", outlier.size = 3)

# boxplot with coloured variable cyl

p <- ggplot(mtcars, aes(factor(cyl), mpg))
p + geom_boxplot(aes(fill = cyl))

# Example 2. boxplot with coloured variable cyl

p <- ggplot(mtcars, aes(factor(cyl), mpg))
p + geom_boxplot(aes(fill = factor(cyl)))

# boxplot with coloured variable vs (third variable)

p <- ggplot(mtcars, aes(factor(cyl), mpg))
p + geom_boxplot(aes(fill = factor(vs)))

# coloured boxplot (contour and fill color)

p <- ggplot(mtcars, aes(factor(cyl), mpg))
p + geom_boxplot(fill = "grey80", colour = "#3366FF")

# Creating bublechart in graphics

# Step 1. Loading data
crime <- read.csv("http://datasets.flowingdata.com/crimeRatesByState2005.tsv", header=TRUE, sep="\t")

# Step 2. Creating circles with size related to third variable (in this case # population)

symbols(crime$murder, crime$burglary, circles=crime$population)

# Step 3. Creating circles related to radius

radius <- sqrt( crime$population/ pi )
symbols(crime$murder, crime$burglary, circles=radius)

# Krok 4 . Zmiana wielko??ci promienia i dodanie nazw osi i atrybut??w kolorystycznych
# Step 4.Calibrating size of circles and adding colours

# inches defines the largest size of bubbles. fg - border line
symbols(crime$murder, crime$burglary, circles=radius, inches=0.35, fg="white", bg="red", xlab="Murder Rate", ylab="Burglary Rate")

# Step 5. Adding text labels

# cex defines the size of the text
text(crime$murder, crime$burglary, crime$state, cex=0.5)

# Program 9. Creating buble chart in ggplot2
# scale_area() - calibrating size of bubles
# theme_bw() changing chart theme
# shape 21 - changing bubles colours

# scale_size_area - the same as inches inn previous example.
crime <-read.csv("http://datasets.flowingdata.com/crimeRatesByState2005.tsv", header=TRUE, sep="\t")
ggplot(crime, aes(x=murder, y=burglary, size=population, label=state),guide=FALSE)+
  geom_point(colour="white", fill="red", shape=21)+ scale_size_area(max_size = 15)+
  scale_x_continuous(name="Murders per 1,000 population", limits=c(0,12))+
  scale_y_continuous(name="Burglaries per 1,000 population", limits=c(0,1250))+
  geom_text(size=4)+
  theme_bw()

#---------------------------------------------------------------------------------------------------








