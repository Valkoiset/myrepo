

Eggs<-read.csv2("http://jolej.linuxpl.info/Eggs.csv", header=TRUE) 
Eggs
ls(Eggs)
library(ggplot2)

Eggs$First.Week <- as.factor(Eggs$First.Week)

Eggs %>% gather(Egg.Pr:Cereal.Pr, key = "column", value = "value")

# 1
plot <- ggplot(Eggs, aes(x = Cases, fill = Month))
histogram <- plot + geom_histogram(binwidth = 5000, color = "white") +
  theme_light() +
  labs(x = "Cases", y = "Months") + coord_flip()
histogram

# 2
scat <- ggplot(Eggs, aes(x = Week, y = Cases))
scat + geom_point(aes(color = Month), shape = 21, fill = "White",
                  size = 3, stroke = 2) + theme_light() +
  labs(x = "Week", y = "Cases")

# 3
pairs(Eggs[, 6:10], col = Eggs$Cases)

# 4
box <- ggplot(Eggs, aes(x = Cases, y = Week))
a <- box + geom_boxplot() + geom_jitter(width = 1, aes(color = Easter)) +
  theme_light() + coord_flip()
a

# 5 
plot(Eggs$Cases, Eggs$Week, col = Eggs$Easter)
legend("topright", levels(Eggs$Easter), fill = Eggs$Easter)

# 6!
library(ggplot2)
z <- ggplot(Eggs, aes(x = Week, y = Cases))
z + geom_point(aes(color = factor(Easter)))

# 7!

df <- Eggs[,c(1,6:10)]
g <- ggplot(df, aes(Week))
g <- g + geom_line(aes(y=Egg.Pr), colour="red")
g <- g + geom_line(aes(y=Beef.Pr), colour="green")
g <- g + geom_line(aes(y=Pork.Pr), colour="yellow")
g <- g + geom_line(aes(y=Cereal.Pr), colour="blue")
g <- g + geom_line(aes(y=Chicken.Pr), colour="purple")
g <- g + geom_line(aes(y=Cereal.Pr), colour="grey")
g + labs(y = "Price")

