

setwd("~/Desktop/SGH/2 semester/Statistical learning methods/mnist")

f <- file("mnist_test.int", "rb")
cls <- as.integer(readBin(f, raw(), 1))
ing <- matrix(as.integer(readBin(f, raw(), 28*28), nrow = 28))
close(f)
