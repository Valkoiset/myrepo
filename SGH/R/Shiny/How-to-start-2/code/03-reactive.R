# 03-reactive

library(shiny)

ui <- fluidPage(
  sliderInput(inputId = "num", 
    label = "Choose a number", 
    value = 25, min = 1, max = 100),
  plotOutput("hist"),
  verbatimTextOutput("stats")
)

server <- function(input, output) {
  
  data <- reactive({ # works like a function
    rnorm(input$num)
  })
  
  output$hist <- renderPlot({
    hist(data()) # inserting saved data here
  })
  output$stats <- renderPrint({ # and here. To work with the same data
                                # for graph and for stats
    summary(data())
  })
}

shinyApp(ui = ui, server = server)