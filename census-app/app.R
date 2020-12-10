library(shiny)

library(maps)
library(mapproj)
#source("census-app/helpers.R")
source("helpers.R")
#counties <- readRDS("census-app/data/counties.rds")
counties <- readRDS("data/counties.rds")
percent_map(counties$white, "darkgreen", "% White")

# User interface ----
ui <- fluidPage(
  titlePanel("censusVis"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Create demographic maps with 
        information from the 2010 US Census."),
      
      selectInput("var", 
                  label = "Choose a variable to display",
                  choices = c("Percent White", "Percent Black",
                              "Percent Hispanic", "Percent Asian"),
                  selected = "Percent White"),
      
      sliderInput("range", 
                  label = "Range of interest:",
                  min = 0, max = 100, value = c(0, 100))
    ),
    
    mainPanel(plotOutput("map"))
  )
)


# Define server logic required to draw a histogram ----
server <- function(input, output) {
  # output$map <- renderPlot({
  #   data <- switch(input$var, 
  #                  "Percent White" = counties$white,
  #                  "Percent Black" = counties$black,
  #                  "Percent Hispanic" = counties$hispanic,
  #                  "Percent Asian" = counties$asian)
  #   color <- switch(input$var, 
  #                   "Percent White" = "darkgreen",
  #                   "Percent Black" = "slateblue",
  #                   "Percent Hispanic" = "darkorange",
  #                   "Percent Asian" = "yellow")
  #   
  #   legend <- switch(input$var, 
  #                    "Percent White" = "% White",
  #                    "Percent Black" = "% Black",
  #                    "Percent Hispanic" = "% Hispanic",
  #                    "Percent Asian" = "% Asian")
  #   percent_map(data, color, legend, input$range[1], input$range[2])
  # })
  output$map <- renderPlot({
    args <- switch(input$var,
                   "Percent White" = list(counties$white, "darkgreen", "% White"),
                   "Percent Black" = list(counties$black, "black", "% Black"),
                   "Percent Hispanic" = list(counties$hispanic, "darkorange", "% Hispanic"),
                   "Percent Asian" = list(counties$asian, "darkviolet", "% Asian"))
    
    args$min <- input$range[1]
    args$max <- input$range[2]
    
    do.call(percent_map, args)
  })
}


shinyApp(ui = ui, server = server)