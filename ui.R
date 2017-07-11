library(shiny)

shinyUI(fluidPage(

  titlePanel("Histogram of logFC"),
    
    sidebarLayout(
      sidebarPanel(
        selectInput("mydatacol", "Columns: ",
                    choices = colnames(mydata[,2-3])),
        
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
