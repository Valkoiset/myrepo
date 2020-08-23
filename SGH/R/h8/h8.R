library(grid)
library(lattice)
library(ggplot2)
library(sandwich)
library(ggplot2movies)
library(dplyr)
library(tidyverse)
data(Investment, package="sandwich")

# Investment dataset
# 1
trellis.par.set(theme = canonical.theme("postscript", color=FALSE))
grid.newpage()
pushViewport(viewport(x=0, width=.33, just="left"))
print(xyplot(GNP~Investment, data=Investment_data,
             auto.key=list(space="right")),
      newpage=FALSE)
popViewport()
pushViewport(viewport(x=.33, width=.33, just="left"))
print(xyplot(GNP~Years, data=Investment_data,
             auto.key=list(space="right")),
      newpage=FALSE)
popViewport()
pushViewport(viewport(x=.66, width=.33, just="left"))
print(xyplot(Interest~Investment, data=Investment_data,
             auto.key=list(space="right")),
      newpage=FALSE)

# 2
pushViewport(viewport(x=0, width=.50, just="left"))
print(xyplot(Investment~GNP, Investment_data, pch=0,
             panel=function(x, y) {
               panel.lmline(x, y)
               panel.xyplot(x, y)
             }),
             auto.key=list(space="right"),
      newpage=FALSE)
popViewport()
pushViewport(viewport(x=.50, width=.50, just="left"))
print(xyplot(Interest~Years,Investment_data, type="l"),
      auto.key=list(space="right"),
      newpage=FALSE)
popViewport()

# movies
# dividing by genres
movies <- within (movies, { 
  Genre = ifelse (Action == 1, "Action" ,
                  ifelse(Animation == 1,'Animation',
                         ifelse(Comedy == 1, "Comedy",
                                ifelse(Drama == 1, "Drama", 
                                       ifelse(Documentary == 1, 'Documentary',
                                              ifelse(Romance == 1, "Romance", 
                                                     ifelse(Short==1, 'Short', '')))))))})

# 1
grid.newpage()
pushViewport(viewport(x=0, width=2/4, just="left"))
print(ggplot(movies, aes(x=length)) + 
        geom_histogram(color = "blue", fill = "lightgreen") +
        scale_x_continuous(limits = c(0, 200)),
      newpage=FALSE)
popViewport()
pushViewport(viewport(x=1/2, width=1/2, just="left"))
print(ggplot(movies, aes(x=rating)) + 
        geom_histogram(color = "red", fill = "light blue") +
        scale_x_continuous(limits = c(0, 10)),
      newpage=FALSE)
popViewport()

# 2
grid.newpage()
pushViewport(viewport(x=0, width=1/2, just="left"))
print(ggplot(movies, aes(factor(Genre), rating)) +
        geom_boxplot(aes(fill = Genre)) +
        scale_y_continuous(limits = c(5, 10)) +
        theme(axis.text.x = element_text(angle = 90, hjust = 1),
              legend.position = "none"),
      newpage=FALSE)
popViewport()
pushViewport(viewport(x=1/2, width=1/2, just="left"))
print(ggplot(genres.bar, aes(Genre)) + 
        geom_bar(aes(fill= Genre)) +
        theme(axis.text.x = element_text(angle = 90, hjust = 1),
              legend.position = "none"),
      newpage=FALSE)
