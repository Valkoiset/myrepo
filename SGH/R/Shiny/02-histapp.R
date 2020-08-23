

library(shiny)

ui <- fluidPage( # create an empty page with html code
  sliderInput(inputId = "num",
              label = "choose a number",
              value = 25, min = 1, max = 100),
  plotOutput("hist")
)

server <- function(input, output) {
  output$hist <- renderPlot({ # hist here because plotOutput("hist)
    title <- "100 random normal values"
    hist(rnorm(input$num), main = title)
  })
}

shinyApp(ui = ui, server = server)

