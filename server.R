library(shiny)
library(ggplot2)
library(lattice)

mydata1 <- NULL
mydata2 <- NULL

#***************************************************************************
#Read the file
#***************************************************************************
datasetInput0 <- reactive({ 
  fileInput('file1', 'Select the xxx.txt file',
            accept=c('text/plain','text/comma-separated-values,text/plain','.txt'))
  
  
  
})

createLink <- function(val) {
  sprintf('<a href="https://www.google.com/#q=%s" target="_blank" class="btn btn-primary">Info</a>',val)
  
}


function(input, output) {
  
  
  output$input_options0 <- renderUI({
    
    datasetInput0()
    
  })
  
#***************************************************************************
#Get the color for the positive Value in the bar graph
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
                selected = "blue"
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
                selected = "yellow"
                
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
#Get Max Value p Value
#***************************************************************************
  DatasetInput_pvalue1 <- reactive({ 
    
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
#Sort Table based on P.Value column
#***************************************************************************
    mydata2 <- mydata1[order(mydata1$P.Value),]
    
    
    selectInput(
      inputId = "pvalue_max",
      label = h4("Select max P.Value:"), 
      choices =  seq(min(mydata2[,4]), by = 0.001),
      #selected = max(mydata2[,4])
      selected = 0.999 #not sure why max above is working. FIXME.
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
      'input.dataset === "mydata2"',
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
  
  output$GeneTable_logFC <- renderDataTable(
    {
      
      mydata <- subset_on_ragne_logFC()
      if(!is.null(mydata)){
        mydata$Gene <- createLink(mydata$Gene)
      }
      
      
      return(mydata)
      
    }, escape = FALSE)
  
  
#***************************************************************************
#Generate a Bar Graph focused on logFC Column but zoom in function
#***************************************************************************
  output$GeneBarGraph_logFC_zoom <- renderPlot({ 
    
#*************************************************************************
#create a subset of data based on the min and max values for logFC 
#*************************************************************************
    mydata <- subset_on_ragne_logFC()
#*************************************************************************
#select min and max logFC values based on brush
#*************************************************************************
    if(is.null(input$plot_brush$xmin)){
      my_min <- as.numeric(input$min) 
    } else {
      my_min <- input$plot_brush$xmin
    }
    
    if(is.null(input$plot_brush$xmax)){
      my_max <- as.numeric(input$max) 
    } else {
      my_max <- input$plot_brush$xmax
    }
#*************************************************************************
#Create a new table based on min and max x values as determined by the brush
#*************************************************************************    
    mydata1 <- subset(mydata,
                      (mydata$logFC >= my_min & 
                         (mydata$logFC <= my_max ))
    )
    
    
    
#***************************************************************************
#plot the bargraph with different colors for positive and negative values
#***************************************************************************
    
    cols <- c(input$NegativeColor, input$PositiveColor)[(mydata[,2] > 0) +1 ]
    
    if(!is.null(mydata1)){
      barplot(
        mydata1[,"logFC"],
        main = "logFC barplot",
        ylab="genes", 
        xlab= "data",
        cols = cols,
        border = cols,
        horiz = TRUE
      )
    } 
    
  })
  
  
  
  
#***************************************************************************
#Generate a Volcano Graph focused on logFC Column.
#***************************************************************************
  output$GeneVolcanoGraph_logFC <- renderPlot({ 
    
    mydata <- subset_on_ragne_logFC()
    
    xyplot(-log10(mydata[,4]) ~ mydata[,2])
    
    
    
  })
  
  
  

#***************************************************************************
  GeneTable_Export <- reactive({
    mydata <- subset_on_ragne_logFC()
    return (mydata[, input$show_vars, drop = FALSE])
    
  })
#***************************************************************************
# downloadHandler() takes two arguments, both functions.
# The content function is passed a filename as an argument, and
#   it should write out data to that filename.
#***************************************************************************
  output$downloadData <- downloadHandler(
    
  
    filename = function() {
      paste("export_data", input$filetype, sep = ".")
    },
    
    # This function should write data to a file given to it by
    # the argument 'file'.
    content = function(file) {
      sep <- switch(input$filetype, "csv" = ",", "tsv" = "\t")
      
      
      # Write to a file specified by the 'file' argument
      write.table(GeneTable_Export(), file, sep = sep,
                  row.names = FALSE)
    }
  )
  
  
  
  output$info <- renderText({
    xy_str <- function(e) {
      if(is.null(e)) return("NULL\n")
      paste0("x=", round(e$x, 1), " y=", round(e$y, 1), "\n")
    }
    xy_range_str <- function(e) {
      if(is.null(e)) return("NULL\n")
      paste0("xmin=", round(e$xmin, 1), " xmax=", round(e$xmax, 1), 
             " ymin=", round(e$ymin, 1), " ymax=", round(e$ymax, 1))
    }
    
    paste0(
      "click: ", xy_str(input$plot_click),
      "dblclick: ", xy_str(input$plot_dblclick),
      "hover: ", xy_str(input$plot_hover),
      "brush: ", xy_range_str(input$plot_brush)
    )
  })
  
}
