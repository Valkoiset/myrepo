?USArrests

data(USArrests)
ds <- cbind(rownames(USArrests), data.frame(USArrests, row.names=NULL))
ds$Total <- USArrests$Murder + USArrests$Assault + USArrests$Rape
colnames(ds) <- c("State", "Murders", "Assaults", "UrbanPops", "Rapes", "Totals")

head(ds, n=3)
ds
