# Data import from csv file, from the web page

a<-read.csv2("http://akson.sgh.waw.pl/~jolej/Dane1.csv", header=TRUE)


# Data import from MS Excel file, package RODBC

library(RODBC)
setwd("~/Desktop/SGH/2 semester/Big data/labs/1")

dane <- odbcConnectExcel("Data10_11.xls")
DANE <- sqlQuery(dane, "select * from [Data$]")


# Data import from Excel file, package XLConnect

library(XLConnect)

DANE2<- readNamedRegionFromFile("Data10_11.xls", name=c("Cost","Production"))

# Data export from R to Excel worksheet , package XLConnet

Cost2<-(DANE2$Cost*0.1)/2
writeWorksheetToFile("Data10_11.xls", data=Cost2, sheet="Wyniki",header=TRUE, startRow=1, startCol = 2)

