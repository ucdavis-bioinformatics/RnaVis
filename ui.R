library(shiny)

shinyUI(fluidPage(
  
  h2('davis'),
  dataTableOutput('mytable'),
  
  titlePanel("Histogram of logFC"),
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      #selectInput("Distribution", "Please select distribution type",
      #choices = c("Normal", "Exponential")),
      sliderInput("bins",
                  "Select sample size",
                  min = 1,
                  max = 50,
                  value = 25,
                  step = 1)
      #conditionalPanel(condition = "input.Distribution =="Normal",
      #textInput)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot")
      
      
      
    )
  )
))
