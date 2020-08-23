

# Lattice package - ci??g 

# Program 1 - Display data in many panels

# mtcars - The data was extracted from the 1974 Motor Trend US magazine, and # comprises fuel consumption and 10 aspects of automobile design and performance # for 32 automobiles (1973???74 models). 

# mpg - Miles/(US) gallon
# cyl - Number of cylinders
# disp - Displacement (cu.in.)
# gear - Number of forward gears
# carb - Number of carburetors

library(lattice)

xyplot(mpg ~ disp | factor(gear), data=mtcars)

# Program 2 Control of panels leyout

# aspect - adjusting panels size

xyplot(mpg ~ disp | factor(gear), data=mtcars, layout=c(3, 1),aspect="fill")
# aspect = fill means use maximum value of the window

xyplot(mpg ~ disp | factor(gear), data=mtcars, layout=c(3, 1),aspect=1)


# Program 3 Different charts in separate panels

plot1 <- xyplot(mpg ~ disp, data=mtcars, 
                aspect=1, xlim=c(65, 480), ylim=c(9, 35),
                subset=gear == 5)
plot2 <- xyplot(mpg ~ disp, data=mtcars, 
                aspect=1, xlim=c(65, 480), ylim=c(9, 35),
                subset=gear == 4)
plot3 <- xyplot(mpg ~ disp, data=mtcars, 
                aspect=1, xlim=c(65, 480), ylim=c(9, 35),
                subset=gear == 3)
print(plot1, position=c(0, 2/3, 1, 1), more=TRUE) # print allowa to print all the plots
                  # in 1 window. more = TRUE allows it
print(plot2, position=c(0, 1/3, 1, 2/3), more=TRUE)
print(plot3, position=c(0, 0, 1, 1/3))

#position - panel localization in graphical window - arguments (left, bottom,right, top).


# Program 4 Scaterplot with grouping

gear.f<-factor((mtcars$gear),
               labels=c("3gears","4gears","5gears"))

xyplot(mpg ~ disp, data=mtcars,
       group=gear.f,auto.key=list(border=TRUE))


xyplot(mpg ~ disp, data=mtcars,
       group=gear.f,auto.key=list(border=TRUE), # autokey defines the legend
       par.settings=list(superpose.symbol=list(pch=c(2, 3, 16))))

# ustawienie auto.key=list(border=TRUE) wprowadza legend?? do wykresu

# Program 5 Changing axes annotation

xyplot(mpg ~ disp | factor(gear), data=mtcars,
       layout=c(3, 1), aspect=1,
       scales=list(y=list(at=seq(10, 30, 10))),
       ylab="miles per gallon",
       xlab=expression(paste("displacement (", inch^3, ")")))



# Program 6 scaterplot with regression line

xyplot(mpg ~ disp | factor(gear), data=mtcars,
       layout=c(3, 1), aspect=2,
       panel=function(x, y) {
         panel.lmline(x, y) # panel.lmline drows regression line
         panel.xyplot(x, y)
       })



# Lattice Extra package 

library(latticeExtra)


# Program 1 - edcfplot displays of Cumulative Distribution Functions

data(singer, package = "lattice")
ecdfplot(~height | voice.part, data = singer)


# Program 2 - segplot - drawing segments

data(USCancerRates)
segplot(reorder(factor(county), rate.male) ~ LCL95.male + UCL95.male, # county - observations
        data = subset(USCancerRates, state == "Washington")) # y ~ x1 + x2

segplot(reorder(factor(county), rate.male) ~ LCL95.male + UCL95.male,
        data = subset(USCancerRates, state == "Washington"),
        draw.bands = FALSE, centers = rate.male)

segplot(reorder(factor(county), rate.male) ~ LCL95.male + UCL95.male,
        data = subset(USCancerRates, state == "Washington"),
        level = rate.female, col.regions = terrain.colors)

segplot(reorder(factor(county), rate.male) ~ LCL95.male + UCL95.male,
        data = subset(USCancerRates, state == "Washington"),
        draw.bands = FALSE, centers = rate.male,
        segments.fun = panel.arrows, ends = "both",
        angle = 90, length = 1, unit = "mm")


# Program 3 panel.xyarea - cutting graph

# cut allows to cut timeseries on some parts
xyplot(sunspot.year, panel = panel.xyarea, origin = 0,
       aspect = "xy", cut = list(n = 4, overlap = 0))
