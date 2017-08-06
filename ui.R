library(shiny)
library(ggplot2)


fluidPage(
  
  fluidRow(
    
    column (width = 3,
            
            wellPanel(
#***************************************************************************
#Read the file and pass file handle "file1" to Server side
#***************************************************************************
              uiOutput("input_options0"),
#***************************************************************************
#Choices for minimum value, logFC
#***************************************************************************
              uiOutput("input_options_logFC1"),
#***************************************************************************
#***************************************************************************        
              uiOutput("input_options_logFC2"),
              uiOutput("input_options_logFC3"),
              
              
#***************************************************************************
#Select Max P.Value
#***************************************************************************
              uiOutput("input_options_pvalue1")
              
              
            )
            
    ),
#***************************************************************************
#Output table and bar graph on different tabs of the browser
#***************************************************************************
    
    column (width=5, 
            tabsetPanel(
              id = 'dataset',
              tabPanel('GeneTable',DT::dataTableOutput('GeneTable_logFC'), value = 'GeneTable_logFC'),
              tabPanel("logFC Bar Plot", plotOutput("GeneBarGraph_logFC"), value='Bar Plot_logFC')
              
            )
    ),
    
    column (width=2, offset = 2, 
            wellPanel(
              uiOutput("input_options_PositiveColor"),
              uiOutput("input_options_NegativeColor")
            )
    )
    
  )
  
  
)
