library(shiny)

shinyUI(fluidPage(
  
  
  titlePanel("Histogram of logFC"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("min", "Lower Value for Range ",
                  choices = seq(min(mydata3[,2]), by = .25)),
      selectInput("max", "Max value for range: ",
                  choices = seq(max(mydata3[,2]), by = -.25)),
      
      helpText("Davis Data")
    ),
    
    # Show a plot of the generated distribution
    
    mainPanel(
      tabsetPanel(type = "tabs", 
                  tabPanel("Data Table", dataTableOutput('mytable')),
                  tabPanel("Histogram", plotOutput("distPlot")), 
                  tabPanel("Bar Plot", plotOutput("GeneData"))
                  
      )
    )
  )))
