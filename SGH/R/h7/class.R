


library(ggplot2)


# Program 1
# Axis formating in ggplot2

mtcars2 <- mtcars
mtcars2$trans <- factor(mtcars$am,
                        levels = 0:1,
                        labels = c("automatic", "manual"))
mtcars2$gear <- as.factor(mtcars$gear)
mtcars2$am <- NULL
mtcars2$vs <- NULL
mtcars2$drat <- NULL
mtcars2$carb <- NULL
mtcars2$wt <- NULL
mtcars2$hp <- NULL
mtcars2$qsec <- NULL



p <- ggplot(mtcars2)



print(
  p + geom_point(aes(x = disp, y = mpg)) +
    scale_y_continuous(name = "miles per gallon") +
    scale_x_continuous(name = "displacement (cu.in.)")
  
)


print(p + geom_point(aes(x = disp, y = mpg)) +
        scale_y_continuous(limits = c(0, 40))) # setting limits of y axis


print(p + geom_point(aes(
  x = disp, y = mpg,
  color = trans
), size = 4) +
  scale_color_manual(values = c(
    automatic = gray(2 / 3),
    manual = gray(1 / 3)
  )))


# Program 2
# Grouping in gplot2

mtcars2 <- mtcars
mtcars2$trans <- factor(mtcars$am,
                        levels = 0:1,
                        labels = c("automatic", "manual"))
mtcars2$gear <- as.factor(mtcars$gear)
mtcars2$am <- NULL
mtcars2$vs <- NULL
mtcars2$drat <- NULL
mtcars2$carb <- NULL
mtcars2$wt <- NULL
mtcars2$hp <- NULL
mtcars2$qsec <- NULL

# Example 1

p <- ggplot(mtcars2)

# parameter scale_shape_manual- define types of symbols


print(p + geom_point(aes(
  x = disp, y = mpg, shape = trans
)) +
  scale_shape_manual(values = c(1, 3)))

# Example 2

print(ggplot(mtcars2, aes(x = disp, y = mpg)) +
        geom_point() +
        stat_smooth(aes(group = trans),
                    method = "lm"))


# Program 3 parameter position

mtcars2 <- mtcars
mtcars2$trans <- factor(mtcars$am,
                        levels = 0:1,
                        labels = c("automatic", "manual"))
mtcars2$gear <- as.factor(mtcars$gear)
mtcars2$am <- NULL
mtcars2$vs <- NULL
mtcars2$drat <- NULL
mtcars2$carb <- NULL
mtcars2$wt <- NULL
mtcars2$hp <- NULL
mtcars2$qsec <- NULL

p <- ggplot(mtcars2)



print(p + geom_bar(aes(x = trans, fill = factor(cyl)),
                   color = "black") +
        scale_fill_manual(values = gray(1:3 / 3)))


print(
  p + geom_bar(
    aes(x = trans, fill = factor(cyl)),
    color = "black",
    position = "dodge"
  ) +
    scale_fill_manual(values = gray(1:3 / 3))
)

print(p + geom_bar(
  aes(x = trans, fill = factor(cyl)),
  color = "black",
  position = "fill"
) +
  scale_fill_manual(values = gray(1:3 / 3)))

qplot(carat, price, data = diamonds, log = "xy")

qplot(carat, price, data = diamonds) +  scale_y_log10()




# Program 4 - facets

mtcars2 <- mtcars
mtcars2$trans <- factor(mtcars$am,
                        levels = 0:1,
                        labels = c("automatic", "manual"))
mtcars2$gear <- as.factor(mtcars$gear)
mtcars2$am <- NULL
mtcars2$vs <- NULL
mtcars2$drat <- NULL
mtcars2$carb <- NULL
mtcars2$wt <- NULL
mtcars2$hp <- NULL
mtcars2$qsec <- NULL



p <- ggplot(mtcars2)



print(p + geom_point(aes(x = disp, y = mpg)) +
        facet_wrap( ~ gear, nrow = 1)) # allows to create graphs in panels

# Program 5  - Themes in ggplot2

mtcars2 <- mtcars
mtcars2$trans <- factor(mtcars$am,
                        levels = 0:1,
                        labels = c("automatic", "manual"))
mtcars2$gear <- as.factor(mtcars$gear)
mtcars2$am <- NULL
mtcars2$vs <- NULL
mtcars2$drat <- NULL
mtcars2$carb <- NULL
mtcars2$wt <- NULL
mtcars2$hp <- NULL
mtcars2$qsec <- NULL

# Example 1

p <- ggplot(mtcars2)



print(p + geom_point(aes(x = disp, y = mpg)) +
        theme_bw())

print(p + geom_point(aes(x = disp, y = mpg)) +
        theme_light())


# Example 2

qplot(mpg, wt, data = mtcars)

old <- theme_set(theme_bw())
qplot(mpg, wt, data = mtcars)
theme_set(old)
qplot(mpg, wt, data = mtcars)


# Program 6 - annotations

mtcars2 <- mtcars
mtcars2$trans <- factor(mtcars$am,
                        levels = 0:1,
                        labels = c("automatic", "manual"))
mtcars2$gear <- as.factor(mtcars$gear)
mtcars2$am <- NULL
mtcars2$vs <- NULL
mtcars2$drat <- NULL
mtcars2$carb <- NULL
mtcars2$wt <- NULL
mtcars2$hp <- NULL
mtcars2$qsec <- NULL



p <- ggplot(mtcars2)



print(p + geom_point(aes(x = disp, y = mpg)) +
        geom_hline(yintercept = 29))


gcLimits <-
  data.frame(
    category = c(
      "2WD car",
      "4WD car",
      "2WD small pick-up truck",
      "4WD small pick-up truck",
      "2WD std pick-up truck",
      "4WD std pick-up truck"
    ),
    limit = c(29, 24, 20, 18, 17, 16)
  )


print(
  p + geom_point(aes(x = disp, y = mpg)) +
    geom_hline(data = gcLimits,
               aes(yintercept = limit),
               linetype = "dotted") +
    geom_text(
      data = gcLimits,
      aes(y = limit + .1, label = category),
      x = 70,
      hjust = 0,
      vjust = 0,
      size = 3
    )
  
)
