library(shiny)

function(input, output) {
  df <- read.table("/Users/Navya/Desktop/DavisData2.txt", header = TRUE, sep= "\t", as.is = TRUE)
  sorted_data_table <- df[order( df[,2]) , ]
  
  
  output$GeneData <- renderPlot({ 
    mydata2 <- mydata[order(mydata$logFC),2-3]
    mydata3 <-subset(mydata2, (logFC>input$min) & (logFC<input$max))
    barplot(mydata3[,"logFC"],
            main = "logFC barplot",
            ylab="genes", 
            xlab= "data",
            horiz = TRUE)
  })
  
  output$mytable = renderDataTable({  
    mydata2 <- mydata[order(mydata$logFC),]
    #mydata2 <- mydata
    mydata3 <-subset(mydata2, (logFC>input$min) & (logFC<input$max))
    mydata3
  })
  #output$mytable = renderDataTable({sorted_data_table})
  
  output$distPlot <- renderPlot({
    logFC <- mydata[, 2]
    
    #draw the histogram with the specified number of bins
    hist(logFC, breaks = 50, col = 'blue', border = 'white')
  })
}
