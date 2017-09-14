library(shiny)
library(ggplot2)
library(lattice)


fluidPage(
  
  fluidRow(
    
    column (width = 2,
            
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
#Choices for max  value, logFC
#***************************************************************************  
              
              uiOutput("input_options_logFC2"),
#***************************************************************************
#Choices for which column to select 
#***************************************************************************     
              uiOutput("input_options_logFC3"),
              
              
#***************************************************************************
#Select Max P.Value
#***************************************************************************
              uiOutput("input_options_pvalue1"),
              
#***************************************************************************
#Options for exporting the data table 
#***************************************************************************
              radioButtons("filetype", "Download File type:",
                           choices = c("csv", "tsv")),
#***************************************************************************
#Download data to a file
#***************************************************************************
              downloadButton('downloadData', 'Download')
              
              
            )
            
    ),
#***************************************************************************
#Display all tabs
#***************************************************************************
    
    column (width=6,
            tabsetPanel(
              id = 'dataset',
              tabPanel('GeneTable',dataTableOutput('GeneTable_logFC'), value = 'GeneTable_logFC'),
              tabPanel("logFC Bar Plot", 
                       plotOutput("GeneBarGraph_logFC_zoom",
                                  click = "plot_click",
                                  dblclick = "plot_dblclick",
                                  hover = "plot_hover",
                                  brush = "plot_brush"
                       ), 
                       verbatimTextOutput("info"), # display the options picked for zoom
                       value='Bar Plot_logFC'
              ),
              tabPanel("logFC Volcano Plot", plotOutput("GeneVolcanoGraph_logFC"), value='Volcano Plot_logFC')
              
            )
    ),
#***************************************************************************
#color choices for the bar graph
#***************************************************************************
    column (width=3,offset=1, 
            wellPanel(
              uiOutput("input_options_PositiveColor"),
              uiOutput("input_options_NegativeColor")
            )
    )    
    
  )
  
  
)
