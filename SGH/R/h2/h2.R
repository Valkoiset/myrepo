

# 1
library(ggplot2)
z <- ggplot(Eggs, aes(x = Week, y = Cases))
z + geom_point(aes(color = factor(Easter)))

# 2
df <- Eggs[,c(1,6:10)]
g <- ggplot(df, aes(Week))
g <- g + geom_line(aes(y=Egg.Pr), colour="red")
g <- g + geom_line(aes(y=Beef.Pr), colour="green")
g <- g + geom_line(aes(y=Pork.Pr), colour="yellow")
g <- g + geom_line(aes(y=Cereal.Pr), colour="blue")
g <- g + geom_line(aes(y=Chicken.Pr), colour="purple")
g <- g + geom_line(aes(y=Cereal.Pr), colour="grey")
g + labs(y = "Price")
