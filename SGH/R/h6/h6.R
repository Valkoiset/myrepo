


library(ggplot2)
library(dplyr)
? economics
View(economics)


# psavert to date
# 1) with qplot
qplot(date, psavert, data = economics)

# 2) with ggplot2
econ.point <- ggplot(economics)
lmcoef <- coef(lm(psavert ~ date, economics))
econ.point + geom_point(aes(x = date, y = psavert)) +
  geom_abline(intercept = lmcoef[1], slope = lmcoef[2])

# unemployment to population
econ.unemp <- ggplot(economics)
lmcoef <- coef(lm(unemploy ~ pop, economics))
econ.unemp + geom_point(aes(x = pop, y = unemploy), colour = "brown") +
  geom_abline(intercept = lmcoef[1], slope = lmcoef[2])

# distributiopn of uempmed (median duration of unemployment, in weeks)
econ.hist <- ggplot(economics, aes(uempmed))
econ.hist + geom_histogram(color = "blue", fill = "yellow")


econ.filtered <- economics %>%
  filter(psavert > 6, pce > 10000) %>%
  arrange(desc(pce)) %>%
  head(10)

ggplot(econ.filtered, aes(
  x = pce,
  y = pop,
  size = psavert,
  label = date
), guide = FALSE) +
  geom_point(colour = "blue",
             fill = "darkgreen",
             shape = 21) + scale_size_area(max_size = 16) +
  scale_x_continuous() +
  scale_y_continuous() +
  geom_text(size = 3) +
  theme_bw()
