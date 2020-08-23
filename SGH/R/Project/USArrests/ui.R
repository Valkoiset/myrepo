library("shiny")

# Define UI for application that draws a histogram
shinyUI(navbarPage(
  title = "Violent Crime Rates by US State",
  tabPanel("Chart",
           sidebarPanel(
             p("Create a map of 1973 crime arrests by state."),
             p("To use this app, choose a crime in the dropdown below, and the chart will update."),
             selectInput("Crime", "Select a crime:",
                         choices = c("Assault", "Rape", "Murder")),
             p("Created by Chris Leonard. Jan 16, 2015.")),
           mainPanel(h4(textOutput("header")),
                     p(uiOutput("avg")),
                     p(uiOutput("sd")),
                     p("Hover over a state to see the number of arrests. The horizontal bar below the chart shows the max & min values."),
                     htmlOutput("gvis"))
  ),
  tabPanel("Data Table", dataTableOutput("USArrests")),
  tabPanel("About",
           fluidRow(
             column(12,
                    mainPanel(
                      p("The data presented here comes from the ", a("USArrests", href="http://stat.ethz.ch/R-manual/R-devel/library/datasets/html/USArrests.html"), " data contained within the ", a("datasets", href="http://stat.ethz.ch/R-manual/R-patched/library/datasets/html/00Index.html"), " package."),
                      HTML("The USArrests data set is a data frame with 4 variables for each state:<br />
                           <ul><li><strong>Assault</strong> - number of Assault arrests per 100,000 people.</li>
                           <li><strong>Rape</strong> - number of Rape arrests per 100,000 people.</li>
                           <li><strong>UrbanPop</strong> - percentage of uban population. <em>Not used.</em></li>
                           <li><strong>Murder</strong> - number of Murder arrests per 100,000 people.</li></ul>"),
                      p("The source for crime data is the World Almanac and Book of facts 1975."),
                      p("The source for the urban rates is Statistical Abstracts of the United States 1975."),
                      p("This code available in my ", a("Github Repository", href="https://github.com/lenwood/USArrests"), ". My Slidify deck is availabe at ", a("RPubs", href="http://rpubs.com/lenwood/USArrests"), ".")
                      )
                    )
             )
           )
  
  ))