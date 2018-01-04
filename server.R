library(shiny)
library(ggplot2)
library(lattice)
library(RColorBrewer)
library(plotly)
library(manhattanly)


mydata1 <- NULL
mydata2 <- NULL

#***************************************************************************
#Read GeneTable into file handle fh_gene_table
#***************************************************************************
read_genetable_file <- reactive({ 
  fileInput('fh_gene_table', 'Select the Gene Table source (xxx.txt) file',
            accept=c('text/plain','text/comma-separated-values,text/plain','.txt'))
  
  
  
})

#***************************************************************************
#Read Frog Table into file handle fh_frog_table
#***************************************************************************
read_frog_table <- reactive({ 
  fileInput('fh_frog_table', 'Select the Frog Tail Table source (xxx.txt) file',
            accept=c('text/plain','text/comma-separated-values,text/plain','.txt'))
  
  
})


createLink <- function(val) {
  
  sprintf('<a href="https://www.google.com/#q=%s" target="_blank" class="btn btn-primary">%s</a>',val, val)
  
}






function(input, output) {
  
  
  
  #***************************************************************************
  #renderUI entities BEGIN
  #***************************************************************************
  output$input_genetable_file <- renderUI({
    
    read_genetable_file()
    
  })
  
  
  output$input_frog_table <- renderUI({
    
    read_frog_table()
    
  })
  
  output$input_min_logFC <- renderUI({
    
    DatasetInput_min_logFC()
    
    
  })
  
  output$input_max_logFC <- renderUI({
    
    
    DatasetInput_max_logFC()
    
  })
  
  output$input_options_PositiveColor <- renderUI({
    
    DatasetInput_PositiveColor()
    
    
  })
  
  output$input_options_NegativeColor <- renderUI({
    
    DatasetInput_NegativeColor()
    
    
  })
  
  output$input_options_pvalue1 <- renderUI({
    
    DatasetInput_pvalue1()
    
    
  })
  
  output$input_options_logFC3 <- renderUI({
    
    
    DatasetInput_logFC3()
    
  })
  #***************************************************************************
  #renderUI entities END
  #***************************************************************************
  
  
  
  #***************************************************************************
  #renderDataTable Entities BEGIN
  #***************************************************************************
  
  output$FrogTable <- renderDataTable(
    options = list(pageLength = 10),
    {
      
      mydata <- subset_on_range_frog_table()
      
      
      
      
      if(!is.null(mydata)){
        mydata$Gene <- createLink(mydata$Gene)
      } 
      
      validate(
        need(mydata != "NULL", "No Data to show")
      )
      return(mydata)
      
    }, escape = FALSE)
  
  #***************************************************************************
  #Generate a table for display - gene table filtered
  #***************************************************************************
  
  output$GeneTable_logFC_Filtered <- renderDataTable(
    options = list(pageLength = 10),
    {
      
      mydata <- subset_on_range_logFC()
      if(!is.null(mydata)){
        mydata$Gene <- createLink(mydata$Gene)
      }
      validate(
        need(mydata != "NULL", "No Data to show")
      )
      
      return(mydata)
      
    }, escape = FALSE )
  #***************************************************************************
  #Generate a table for display - gene table unfiltered
  #***************************************************************************
  
  output$GeneTable_logFC_UnFiltered <- renderDataTable(
    options = list(pageLength = 10),
    {
      
      mydata <- read_file_and_sort_logFC()
      if(!is.null(mydata)){
        mydata$Gene <- createLink(mydata$Gene)
      }
      
      validate(
        need(mydata != "NULL", "No Data to show")
      )
      return(mydata)
      
    }, escape = FALSE )
  
  
  #***************************************************************************
  #renderDataTable Entities END
  #***************************************************************************
  
  #***************************************************************************
  #renderPlot Entities BEGIN
  #***************************************************************************
  #***************************************************************************
  #Generate a Volcano Graph focused on logFC Column.
  #***************************************************************************
  output$GeneVolcanoGraph_logFC <- renderPlotly({ 
    
    mydata <- subset_on_range_logFC()
    colnames(mydata) <- c("Gene", "EFFECTSIZE", "AveExpr", "P.Value", "P")
    volcanoly(mydata, genomewideline = -log10(1e-2), effect_size_line = FALSE)
    
   
    
    #if(!is.null(mydata)){
      #xyplot(-log10(mydata[,5]) ~ mydata[,2], layout = c(1, 1), xlab = "logFC", ylab = "Log10 of Adjusted P Value")
      
    
  })
  
  
  
  
  
  #***************************************************************************
  #Generate a Bar Graph focused on logFC Column but zoom in function
  #***************************************************************************
  output$GeneBarGraph_logFC_zoom <- renderPlotly({ 
    #*************************************************************************
    #create a subset of data based on the min and max values for logFC 
    #*************************************************************************
    mydata <- subset_on_range_logFC()
    
    mydata_pos <- subset(mydata,
                         (mydata$logFC >= as.numeric(0)) 
    ) 
    
    mydata_pos_nrows = nrow(mydata_pos)
    mydata_neg <- subset(mydata,
                         (mydata$logFC < as.numeric(0)) 
    ) 
    mydata_neg_nrows = nrow(mydata_neg)
    
    
    #***************************************************************************
    #plot the bargraph with different colors for positive and negative values
    #***************************************************************************
    
    
    
    
    
    
    if(mydata_pos_nrows && mydata_neg_nrows){
      
      plot_ly(
        mydata_pos,
        x = mydata_pos[,"logFC"],
        name = "logFC Positive Values",
        type = "bar",
        orientation = "h",
        color = I(input$PositiveColor)
      ) %>%
        add_trace(
          x = mydata_neg[,"logFC"],
          name = "logFC Negative Values",
          color = I(input$NegativeColor)
        ) %>%
        layout(title = "Gene Table LogFC Plot",
               xaxis = list(title = "Gene Data"),
               yaxis = list(title = "Gene"),
               autosize = F,
               width = 1000,
               height = 700)
      
    } else if(mydata_pos_nrows && !mydata_neg_nrows) {
      plot_ly(
        mydata_pos,
        x = mydata_pos[,"logFC"],
        name = "logFC Positive Values",
        type = "bar",
        orientation = "h",
        color = I(input$PositiveColor)
      ) %>%
        layout(title = "Gene Table LogFC Plot",
               xaxis = list(title = "Gene Data"),
               yaxis = list(title = "Gene"),
               autosize = F,
               width = 1300,
               height = 800)
      
    } else if(!mydata_pos_nrows && mydata_neg_nrows) {
      plot_ly(
        mydata_neg,
        x = mydata_neg[,"logFC"],
        name = "logFC Negative Values",
        type = "bar",
        orientation = "h",
        color = I(input$NegativeColor)
      ) %>%
        layout(title = "Gene Table LogFC Plot",
               xaxis = list(title = "Gene Data"),
               yaxis = list(title = "Gene"),
               autosize = F,
               width = 1300,
               height = 800)
      
    }  else {
      
      text (1, "No Frog Table Entries Found")
      
    } 
    
  })
  #***************************************************************************
  #renderPlot Entities END
  #***************************************************************************
  
  
  #***************************************************************************
  #Functions that are used in renderUI
  #***************************************************************************
  
  
  #***************************************************************************
  #Get Minimum Value LogFC
  #***************************************************************************
  DatasetInput_min_logFC <- reactive({ 
    
    #***************************************************************************
    #Read the Filehanlde
    #NOTE: UI uses a browser to select the file
    #***************************************************************************
    fh_gene_table = input$fh_gene_table
    
    #***************************************************************************
    #if the File handle is NULL, exit
    #***************************************************************************
    
    if (is.null(fh_gene_table)) {
      return(NULL)
    }
    #***************************************************************************
    #Read Table in the file to a variable
    #***************************************************************************
    mydata1 <- read.table(fh_gene_table$datapath, header=TRUE)
    
    #***************************************************************************
    #Sort Table based on logFC column
    #***************************************************************************
    mydata2 <- mydata1[order(mydata1$logFC),]
    max_value <- max(mydata2[,2])
    
    selectInput(
      inputId = "min",
      label = h4("Select Lower Value for logFC:"), 
      choices =  c(seq(from = min(mydata2[,2]), to = max_value, by = 0.125),max_value),
      selected = min(mydata2[,2])
    )
    
  })
  
  
  #***************************************************************************
  #Get Max Value
  #***************************************************************************
  DatasetInput_max_logFC <- reactive({ 
    
    #***************************************************************************
    #Read the Filehanlde
    #NOTE: UI uses a browser to select the file
    #***************************************************************************
    fh_gene_table = input$fh_gene_table
    
    #***************************************************************************
    #if the File handle is NULL, exit
    #***************************************************************************
    
    if (is.null(fh_gene_table)) {
      return(NULL)
    }
    #***************************************************************************
    #Read Table in the file to a variable
    #***************************************************************************
    mydata1 <- read.table(fh_gene_table$datapath, header=TRUE)
    
    #***************************************************************************
    #Sort Table based on logFC column
    #***************************************************************************
    mydata2 <- mydata1[order(mydata1$logFC),]
    
    max_value <- max(mydata2[,2])
    
    
    
    selectInput(
      inputId = "max",
      label = h4("Select Upper Value for logFC:"), 
      #choices =  c(max_value, rev(seq(from = min(mydata2[,2]), to = max_value, by = 0.25))),
      choices =  c(seq(from = min(mydata2[,2]), to = max_value, by = 0.125),max_value), 
      selected = max(mydata2[,2])
    )
    
  })
  
  #***************************************************************************
  #Get Max Value p Value
  #***************************************************************************
  DatasetInput_pvalue1 <- reactive({ 
    
    #***************************************************************************
    #Read the Filehanlde
    #NOTE: UI uses a browser to select the file
    #***************************************************************************
    fh_gene_table = input$fh_gene_table
    
    #***************************************************************************
    #if the File handle is NULL, exit
    #***************************************************************************
    
    if (is.null(fh_gene_table)) {
      return(NULL)
    }
    #***************************************************************************
    #Read Table in the file to a variable
    #***************************************************************************
    mydata1 <- read.table(fh_gene_table$datapath, header=TRUE)
    
    #***************************************************************************
    #Sort Table based on P.Value column
    #***************************************************************************
    mydata2 <- mydata1[order(mydata1$P.Value),]
    
    
    selectInput(
      inputId = "pvalue_max",
      label = h4("Select Adjusted P Value:"), 
      choices =  c(seq(from = min(mydata2[,5]), to = max(mydata2[,4]), by = 0.0001),max(mydata2[,5])) ,
      selected = max(mydata2[,5]) 
    )
    
  })
  
  
  
  
  #***************************************************************************
  #Get Color for positive Value in the bar graph
  #***************************************************************************
  DatasetInput_PositiveColor <- reactive({ 
    
    #***************************************************************************
    #Read the Filehanlde
    #NOTE: UI uses a browser to select the file
    #***************************************************************************
    fh_gene_table = input$fh_gene_table
    
    #***************************************************************************
    #if the File handle is NULL, exit
    #***************************************************************************
    
    if (is.null(fh_gene_table)) {
      return(NULL)
    }
    
    #***************************************************************************
    #Read Table in the file to a variable
    #***************************************************************************
    mydata1 <- read.table(fh_gene_table$datapath, header=TRUE)
    
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
  
  
  
  
  #***************************************************************************
  #Get Color for Negative Value in the bar graph
  #***************************************************************************
  DatasetInput_NegativeColor <- reactive({ 
    #***************************************************************************
    #Read the Filehanlde
    #NOTE: UI uses a browser to select the file
    #***************************************************************************
    fh_gene_table = input$fh_gene_table
    
    #***************************************************************************
    #if the File handle is NULL, exit
    #***************************************************************************
    
    if (is.null(fh_gene_table)) {
      return(NULL)
    }
    
    #***************************************************************************
    #Read Table in the file to a variable
    #***************************************************************************
    mydata1 <- read.table(fh_gene_table$datapath, header=TRUE)
    
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
  
  
  #***************************************************************************
  #Create a subset of Frog table based on matching subset of Genetable
  #***************************************************************************
  create_subset_of_frog_table <- reactive ({
    #***************************************************************************
    #Read the Filehanlde
    #NOTE: UI uses a browser to select the file
    #***************************************************************************
    fh_frog_table = input$fh_frog_table
    
    #***************************************************************************
    #if the File handle is NULL, exit
    #***************************************************************************
    
    if (is.null(fh_frog_table)) {
      return(NULL)
    }
    
    #***************************************************************************
    #Read Table in the file to a variable
    #***************************************************************************
    frog_table <- read.table(fh_frog_table$datapath, header=TRUE, stringsAsFactors=FALSE)
    
    if (is.null(frog_table)) {
      return (NULL)
    }
    #***************************************************************************
    #Read Log FC table and filter it
    #***************************************************************************    
    
    
    gene_table_subset <- subset_on_range_logFC()
    
    if (is.null(gene_table_subset)) {
      return (NULL)
    }
    
    frog_table_subset <- c()
    
    
    
    for (i in 1:nrow(gene_table_subset)){
      x <- gene_table_subset[i,1]
      
      for (j in 1:nrow(frog_table)){
        y <- frog_table[j,1]
        
        if(x == y){
          
          frog_table_subset <- rbind(frog_table_subset, frog_table[j,])
          
          
        }
      }
    }
    
    
    
    if(is.null(frog_table_subset)) {
      return (NULL)
    }
    
    colnames(frog_table_subset) <- colnames(frog_table)
    
    return(frog_table_subset)
  })
  
  
  #***************************************************************************
  # create a subset of data with in frog table based on the same variables 
  #***************************************************************************
  subset_on_range_frog_table <- reactive ({
    
    mydata1 <- create_subset_of_frog_table()
    
    return(mydata1)
  })
  
  
  
  
  
  
  
  
  
  
  #***************************************************************************
  #Checkbox for which columns to show - FIXME this is not working
  #***************************************************************************
  DatasetInput_logFC3 <- reactive({ 
    #***************************************************************************
    #Read the Filehanlde
    #NOTE: UI uses a browser to select the file
    #***************************************************************************
    fh_gene_table = input$fh_gene_table
    
    #***************************************************************************
    #if the File handle is NULL, exit
    #***************************************************************************
    
    if (is.null(fh_gene_table)) {
      return(NULL)
    }
    #***************************************************************************
    #Read Table in the file to a variable
    #***************************************************************************
    mydata1 <- read.table(fh_gene_table$datapath, header=TRUE)
    
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
    fh_gene_table = input$fh_gene_table
    
    #***************************************************************************
    #if the File handle is NULL, exit
    #***************************************************************************
    
    if (is.null(fh_gene_table)) {
      return(NULL)
    }
    #***************************************************************************
    #Read Table in the file to a variable
    #***************************************************************************
    mydata1 <- read.table(fh_gene_table$datapath, header=TRUE,stringsAsFactors=FALSE)
    
    #***************************************************************************
    #Sort Table based on logFC column
    #***************************************************************************
    mydata2 <- mydata1[order(mydata1$logFC),]
    
    
    return(mydata2)
  })
  
  
  
  #***************************************************************************
  # create a subset of data within min and max logFC but <= P value
  #***************************************************************************
  subset_on_range_logFC <- reactive ({
    
    mydata1 <- read_file_and_sort_logFC()
    
    
    
    if(as.numeric(input$min) < as.numeric(input$max)){
      min_value <- as.numeric(input$min)
      max_value <- as.numeric(input$max)
    } else {
      min_value <- as.numeric(input$max)
      max_value <- as.numeric(input$min)    
    }
    
    mydata2 <- subset(mydata1,
                      (mydata1$logFC >= min_value) & 
                        (mydata1$logFC <= max_value) &
                        (mydata1$adj.P.Val <= as.numeric(input$pvalue_max)) 
    ) 
    
    if(is.null(mydata2)){
      return(NULL)
    } else {
      return(mydata2)
    }
    
    return(mydata2)
  })
  
  
  
  
  #***************************************************************************
  #Generate a Bar Graph focused for the Frog Table
  #***************************************************************************
  output$frog_table_line_graph <- renderPlot({ 
    
    
    mydata1 <- create_subset_of_frog_table()
    
    
    
    if(!is.null(mydata1)){
      
      
      mydata1_t = t(mydata1) #transpose the original data frame
      
      matplot(mydata1_t, type = "l", ylab = "Gene Value", xlab = "Gene", col = c(1:ncol(mydata1_t)))
      
      legend("topright", inset=0.01, legend=mydata1[,1], col=c(1:ncol(mydata1_t)),pch=1:ncol(mydata1_t),
             bg= ("white"), horiz=F)
      
    }  else {
      matplot(1, type = "l", ylab = "Gene Value", xlab = "RNA Sequence ID")
      text (1, "No Frog Table Entries Found")
    }
    
  })
  
  
  #***************************************************************************
  #Generate a Bar Graph focused for the Frog Table
  #***************************************************************************
  output$frog_table_line_graphly <- renderPlotly({ 
    
    mydata1 <- create_subset_of_frog_table()
    
    if(!is.null(mydata1)){
      
      
      my_x <- c(2:ncol(mydata1))
      
      p <- plot_ly() %>%
        layout(
          autosize=F, 
          width = 1300, 
          height = 800,
          xaxis = list(title = "X16.??.?? - See Filtered Frog Table Headings"),
          yaxis = list(title = "Gene Value")
        )
      
      for(i in 1:nrow(mydata1)) {
        my_y <- as.numeric(mydata1[i,2:ncol(mydata1)])
        trace_name <- sprintf("%s_%d", mydata1[i,1],i)
        p <- add_trace(p,  x = my_x, y= my_y,  type='scatter', name = trace_name, mode='lines',evaluate = TRUE )
      }
      p
      
    }  else {
      
      text (1, "No Frog Table Entries Found")
    }
    
  })
  
  
  
  
  
  
  
  
  
  #***************************************************************************
  #Create a function for the data to export
  # this is used in the downloadHandler function
  #***************************************************************************
  GeneTable_Export <- reactive({
    mydata <- subset_on_range_logFC()
    return (mydata[, input$show_vars, drop = FALSE])
    
  })
  #***************************************************************************
  # downloadHandler() takes two arguments, both functions.
  # The content function is passed a filename as an argument, and
  #   it should write out data to that filename.
  #***************************************************************************
  output$downloadDataGeneTable <- downloadHandler(
    
    # This function returns a string which tells the client
    # browser what name to use when saving the file.
    filename = function() {
      paste("export_data", input$filetype_gene_table, sep = ".")
    },
    
    # This function should write data to a file given to it by
    # the argument 'file'.
    content = function(file) {
      sep <- switch(input$filetype_gene_table, "csv" = ",", "tsv" = "\t")
      
      
      # Write to a file specified by the 'file' argument
      write.table(GeneTable_Export(), file, sep = sep,
                  row.names = FALSE)
    }
  )
  
  
  
  #***************************************************************************
  #Create a function for the data to export
  # this is used in the downloadHandler function
  #***************************************************************************
  FrogTable_Export <- reactive({
    mydata <- subset_on_range_frog_table()
    return (mydata)
    
  })
  #***************************************************************************
  # downloadHandler() takes two arguments, both functions.
  # The content function is passed a filename as an argument, and
  #   it should write out data to that filename.
  #***************************************************************************
  output$downloadDataFrogTable <- downloadHandler(
    
    # This function returns a string which tells the client
    # browser what name to use when saving the file.
    filename = function() {
      paste("export_data", input$filetype_frog_table, sep = ".")
    },
    
    # This function should write data to a file given to it by
    # the argument 'file'.
    content = function(file) {
      sep <- switch(input$filetype_frog_table, "csv" = ",", "tsv" = "\t")
      
      
      # Write to a file specified by the 'file' argument
      write.table(FrogTable_Export(), file, sep = sep,
                  row.names = FALSE)
    }
  )
  
  
  
}
