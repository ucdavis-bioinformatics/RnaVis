library(shiny)

function(input, output) {
  
  mydata <- read.table("/Users/Navya/Desktop/DavisData2.txt", header = TRUE, sep= "\t", as.is = TRUE)
  
  output$GeneData <- renderPlot({ 
    mydata2 <- mydata[order(mydata$logFC),]
    mydata3 <-subset(mydata2, (logFC>input$min) & (logFC<input$max))
    cols <- c("blue", "lightgreen")[(mydata3[,2] > 0) +1]
    barplot(mydata3[,"logFC"],
            main = "logFC barplot",
            col = cols,
            border = cols,
            ylab="genes", 
            xlab= "data",
            horiz = TRUE)
    
  })
  output$mytable <- renderDataTable({  
    mydata2 <- mydata[order(mydata$logFC),]
    mydata3 <-subset(mydata2, (logFC>input$min) & (logFC<input$max))
    #DT::datatable(mydata3[, input$show_vars, drop = FALSE])
  })
  
  
  output$distPlot <- renderPlot({
    logFC <- mydata[, 2]
    
    #draw the histogram with the specified number of bins
    hist(logFC, breaks = 50, col = 'blue', border = 'white')
  })
  
}
