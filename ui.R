library(shiny)
library(ggplot2)
library(lattice)
library(RColorBrewer)
library(plotly)
library(manhattanly)


fluidPage(
  
  fluidRow(
    
    
    
    column (width = 3,
            
            wellPanel(
              #***************************************************************************
              #Read the file and pass file handle fh_genetable_file to Server side for the 
              #Gene Table
              #***************************************************************************
              uiOutput("input_genetable_file"),
              
              
              #***************************************************************************
              #Read the file and pass file handle "file_frog_table" to Server side for the Gene Table
              #***************************************************************************
              uiOutput("input_frog_table"),
              
              
              #***************************************************************************
              #Choices for minimum value, logFC
              #***************************************************************************
              uiOutput("input_min_logFC"),
              
              #***************************************************************************
              #Choices for max  value, logFC
              #***************************************************************************  
              uiOutput("input_max_logFC"),
              
              
              #***************************************************************************
              #Choices for which column to select (FIXME)
              #***************************************************************************     
              uiOutput("input_options_logFC3"),
              
              
              #***************************************************************************
              #Select Adjuted P Value
              #***************************************************************************
              uiOutput("input_options_pvalue1"),
              
              uiOutput("input_options_PositiveColor"),
              uiOutput("input_options_NegativeColor"),           
              
              
              #***************************************************************************
              #Options for exporting the data table (FIXME)
              #***************************************************************************
              radioButtons("filetype_gene_table", "Select File Type for downloading Filtered Gene Table",
                           choices = c("csv", "tsv")),
              #***************************************************************************
              #Download data to a file
              #***************************************************************************
              downloadButton('downloadDataGeneTable', 'Write Filtered Gene Table to a file'),
              
              #***************************************************************************
              #Options for exporting the data table (FIXME)
              #***************************************************************************
              radioButtons("filetype_frog_table", "Select File Type for downloading Filtered Frog Table",
                           choices = c("csv", "tsv")),
              #***************************************************************************
              #Download data to a file
              #***************************************************************************
              downloadButton('downloadDataFrogTable', 'Write filtered Frog Table to a file')
              
              
              
            )
            
    ),
    #***************************************************************************
    #Display all tabs
    #***************************************************************************
    
    column (width=7,
            tabsetPanel(
              id = 'dataset',
              #tabPanel('GeneTable Original',dataTableOutput('GeneTable_logFC_UnFiltered'), value = 'GeneTable_logFC_Unfiltered'),
              tabPanel('GeneTable',dataTableOutput('GeneTable_logFC_Filtered'), value = 'GeneTable_logFC_Filtered'),
              tabPanel("logFC Bar Plot", 
                       plotlyOutput("GeneBarGraph_logFC_zoom"),
                       value='Bar Plot_logFC'
              ),
              tabPanel("logFC Volcano Plot", plotlyOutput("GeneVolcanoGraph_logFC"), value='Volcano Plot_logFC'),
              tabPanel('Expressions Table',
                       dataTableOutput('FrogTable'), 
                       value = 'FrogTable'
              ),
              #tabPanel("Expressions Table Line Plot", plotOutput("frog_table_line_graph"), value='Forg Table Plot') ,
              tabPanel("Expressions Table Line Plot", plotlyOutput("frog_table_line_graphly"), value='Forg Table Plot')
              
            )
    )
    
    
    
    
  )
  
  
)
