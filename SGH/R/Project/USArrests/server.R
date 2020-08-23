library("shiny")
library("maps")
library("googleVis")

data(USArrests)
USArrests$State <- rownames(USArrests)
USArrests <- USArrests[c(5, 1, 2, 3, 4)]

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  # prepare page header
  variable <- reactive({switch(input$Crime,
                               "Assault" = "assault",
                               "Rape" = "rape",
                               "Murder" = "murder")})
  
  output$header <- renderText({paste("Map of ", variable(), " arrests per 100,000 people in 1973.")})
  
  dataList <- reactive({switch(input$Crime,
                               "Assault" = 1,
                               "Rape" = 2,
                               "Murder" = 3)})
  
  output$gvis <- renderGvis({
    # assign data frame variables regardless of selection
    d <- dataList()
    if(d==1) {stateData <- data.frame(USArrests$State, USArrests$Assault)}
    if(d==2) {stateData <- data.frame(USArrests$State, USArrests$Rape)}
    if(d==3) {stateData <- data.frame(USArrests$State, USArrests$Murder)}
    names(stateData)[2] <- "value"
    
    # generate the choropleth
    data(stateMapEnv)
    stateData$state.abb <- state.abb[match(USArrests$State, state.name)]
    gvisGeoChart(stateData, "state.abb", "value", options=list(
      region="US", displayMode="regions", resolution="provinces"))
  })
  
  output$avg <- renderText({
    # assign data frame variables regardless of selection
    d <- dataList()
    if(d==1) {stateData <- data.frame(USArrests$State, USArrests$Assault)}
    if(d==2) {stateData <- data.frame(USArrests$State, USArrests$Rape)}
    if(d==3) {stateData <- data.frame(USArrests$State, USArrests$Murder)}
    names(stateData)[2] <- "value"
    
    paste("<strong>Average:</strong> ", round(mean(stateData$value), 1))
  })
  
  output$sd <- renderText({
    # assign data frame variables regardless of selection
    d <- dataList()
    if(d==1) {stateData <- data.frame(USArrests$State, USArrests$Assault)}
    if(d==2) {stateData <- data.frame(USArrests$State, USArrests$Rape)}
    if(d==3) {stateData <- data.frame(USArrests$State, USArrests$Murder)}
    names(stateData)[2] <- "value"
    
    paste("<strong>Std Dev:</strong> ", round(sd(stateData$value), 1))
  })
  
  # data table
  output$USArrests <- renderDataTable(USArrests, options = list(pageLength=10))
})