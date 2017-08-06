library(shiny)
library(ggplot2)

mydata1 <- NULL
mydata2 <- NULL

#***************************************************************************
#Read the file 
#***************************************************************************
datasetInput0 <- reactive({ 
  fileInput('file1', 'Select the xxx.txt file',
            accept=c('text/plain','text/comma-separated-values,text/plain','.txt'))
  
})

function(input, output) {
  
  output$input_options0 <- renderUI({
    
    datasetInput0()
    
  })
  
#***************************************************************************
#Get the color for the positive values in the bar graph
#***************************************************************************
  DatasetInput_PositiveColor <- reactive({ 
    
#***************************************************************************
#Read the Filehanlde
#***************************************************************************
    file1 = input$file1
    
#***************************************************************************
#if the File handle is NULL, exit
#***************************************************************************
    
    if (is.null(file1)) {
      return(NULL)
    }
    
#***************************************************************************
#Read Table in the file to a variable
#***************************************************************************
    mydata1 <- read.table(file1$datapath, header=TRUE)
    
#***************************************************************************
#Sort Table based on logFC column
#***************************************************************************
    mydata2 <- mydata1[order(mydata1$logFC),]
    
    
    selectInput("PositiveColor", 
                "Choose a color for Positive logFC in the Bar Plot:",
                list(`Colors` = c("blue", "lightgreen", "yellow", "purple")
                ),
                selected = "lightgreen"
    )
    
  })
  
  
  output$input_options_PositiveColor <- renderUI({
    
    DatasetInput_PositiveColor()
    
    
  })
  
#***************************************************************************
#Get Color for Negative Value in the bar graph
#***************************************************************************
  DatasetInput_NegativeColor <- reactive({ 
#***************************************************************************
#Read the Filehanlde
#NOTE: UI uses a browser to select the file
#***************************************************************************
    file1 = input$file1
    
#***************************************************************************
#if the File handle is NULL, exit
#***************************************************************************
    
    if (is.null(file1)) {
      return(NULL)
    }
    
#***************************************************************************
#Read Table in the file to a variable
#***************************************************************************
    mydata1 <- read.table(file1$datapath, header=TRUE)
    
#***************************************************************************
#Sort Table based on logFC column
#***************************************************************************
    mydata2 <- mydata1[order(mydata1$logFC),]
    
    selectInput("NegativeColor", 
                "Choose a color for Negative logFC in the Bar Plot:",
                list(`Colors` = c("blue", "lightgreen", "yellow", "purple")
                ),
                selected = "blue"
                
    )
    
    
  })
  
  
  output$input_options_NegativeColor <- renderUI({
    
    DatasetInput_NegativeColor()
    
    
  })
  
#***************************************************************************
#Get Minimum Value LogFC
#***************************************************************************
  DatasetInput_logFC1 <- reactive({ 
    
#***************************************************************************
#Read the Filehanlde
#NOTE: UI uses a browser to select the file
#***************************************************************************
    file1 = input$file1
    
#***************************************************************************
#if the File handle is NULL, exit
#***************************************************************************
    
    if (is.null(file1)) {
      return(NULL)
    }
#***************************************************************************
#Read Table in the file to a variable
#***************************************************************************
    mydata1 <- read.table(file1$datapath, header=TRUE)
    
#***************************************************************************
#Sort Table based on logFC column
#***************************************************************************
    mydata2 <- mydata1[order(mydata1$logFC),]
    
    
    selectInput(
      inputId = "min",
      label = h4("Select Lower Value for logFC:"), 
      choices =  seq(min(mydata2[,2]), by = 0.25),
      selected = min(mydata2[,2])
    )
    
  })
  
  
  output$input_options_logFC1 <- renderUI({
    
    DatasetInput_logFC1()
    
    
  })
  
#***************************************************************************
#Get the max adj. P value
#***************************************************************************
  DatasetInput_pvalue1 <- reactive({ 
    

    file1 = input$file1
    
    
    if (is.null(file1)) {
      return(NULL)
    }

    mydata1 <- read.table(file1$datapath, header=TRUE)
    
#***************************************************************************
#Sort Table based on P.Value column
#***************************************************************************
    mydata2 <- mydata1[order(mydata1$P.Value),]
    
    
    selectInput(
      inputId = "pvalue_max",
      label = h4("Select max P.Value:"), 
      choices =  seq(min(mydata2[,5]), by = 0.001),
      #selected = max(mydata2[,4])
      selected = 0.999 
    )
    
  })
  
  
  output$input_options_pvalue1 <- renderUI({
    
    DatasetInput_pvalue1()
    
    
  })
  
  
#***************************************************************************
#Get Max Value
#***************************************************************************
  DatasetInput_logFC2 <- reactive({ 
    
#***************************************************************************
#Read the Filehanlde
#NOTE: UI uses a browser to select the file
#***************************************************************************
    file1 = input$file1
    
#***************************************************************************
#if the File handle is NULL, exit
#***************************************************************************
    
    if (is.null(file1)) {
      return(NULL)
    }
#***************************************************************************
#Read Table in the file to a variable
#***************************************************************************
    mydata1 <- read.table(file1$datapath, header=TRUE)
    
#***************************************************************************
#Sort Table based on logFC column
#***************************************************************************
    mydata2 <- mydata1[order(mydata1$logFC),]
    
    selectInput(
      inputId = "max",
      label = h4("Select Upper Value for logFC:"), 
      choices =  seq(max(mydata2[,2]), by = -0.25),
      selected = max(mydata2[,2])
    )
    
  })
  output$input_options_logFC2 <- renderUI({
    
    
    DatasetInput_logFC2()
    
  })
  
#***************************************************************************
#Checkbox for which columns to show - FIXME this is not working
#***************************************************************************
  DatasetInput_logFC3 <- reactive({ 
#***************************************************************************
#Read the Filehanlde
#NOTE: UI uses a browser to select the file
#***************************************************************************
    file1 = input$file1
    
#***************************************************************************
#if the File handle is NULL, exit
#***************************************************************************
    
    if (is.null(file1)) {
      return(NULL)
    }
#***************************************************************************
#Read Table in the file to a variable
#***************************************************************************
    mydata1 <- read.table(file1$datapath, header=TRUE)
    
#***************************************************************************
#Sort Table based on logFC column
#***************************************************************************
    mydata2 <- mydata1[order(mydata1$logFC),]
    
    conditionalPanel(
      TRUE,
      checkboxGroupInput('show_vars', 'Columns in mydata to show:',
                         names(mydata2), selected = names(mydata2))
    )
    
  })
  
  
  output$input_options_logFC3 <- renderUI({
    
    
    DatasetInput_logFC3()
    
  })
  
  
#***************************************************************************
#Generate a Bar Graph
# - Read file
# - Filter data
#***************************************************************************
  read_file_and_sort_logFC <- reactive ({
#***************************************************************************
#Read the Filehanlde
#NOTE: UI uses a browser to select the file
#***************************************************************************
    file1 = input$file1
    
#***************************************************************************
#if the File handle is NULL, exit
#***************************************************************************
    
    if (is.null(file1)) {
      return(NULL)
    }
#***************************************************************************
#Read Table in the file to a variable
#***************************************************************************
    mydata1 <- read.table(file1$datapath, header=TRUE)
    
#***************************************************************************
#Sort Table based on logFC column
#***************************************************************************
    mydata2 <- mydata1[order(mydata1$logFC),]
    
    
    return(mydata2)
  })
  
#***************************************************************************
# create a subset of data within the min and max value range
#***************************************************************************
  subset_on_ragne_logFC <- reactive ({
    
    mydata1 <- read_file_and_sort_logFC()
    mydata2 <- subset(mydata1,
                      (mydata1$logFC >= as.numeric(input$min)) & 
                        (mydata1$logFC <= as.numeric(input$max)) &
                        (mydata1$P.Value <= as.numeric(input$pvalue_max)) 
    )
    
    return(mydata2)
  })
  
  
#***************************************************************************
#Generate a table for display
#***************************************************************************
  
  output$GeneTable_logFC <- DT::renderDataTable(
    {
      
      mydata <- subset_on_ragne_logFC()
      
      DT::datatable(mydata[, input$show_vars, drop = FALSE])
      
      
    })
  
#***************************************************************************
#Generate a Bar Graph focused on logFC Column.
#***************************************************************************
  output$GeneBarGraph_logFC <- renderPlot({ 
    
    mydata <- subset_on_ragne_logFC()

#***************************************************************************
#plot the bargraph with different colors for positive and negative values
#***************************************************************************
    #cols <- c("blue", "lightgreen")[(mydata[,2] > 0) +1 ]
    cols <- c(input$NegativeColor, input$PositiveColor)[(mydata[,2] > 0) +1 ]
    barplot(
      mydata[,"logFC"],
      main = "logFC barplot",
      ylab="genes", 
      xlab= "data",
      cols = cols,
      border = cols,
      horiz = TRUE
    )
    
  })
  
}
