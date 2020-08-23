system.time(m <- matrix(rnorm(10000^2), ncol=10000))

m

system.time(m[lower.tri(m)] <- 0) # fill the matrix with 0 where we want them
system.time(sum(m))
