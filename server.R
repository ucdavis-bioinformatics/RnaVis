library(shiny)

function(input, output) {
  df <- read.table("/Users/Navya/Desktop/DavisData2.txt", header = TRUE, sep= "\t", as.is = TRUE)
  #df <- read.table("/Users/Navya/Downloads/DavisData10Rows.txt", header = TRUE, sep= "\t", as.is = TRUE)
  sorted_data_table <- df[order( df[,2]) , ]
  
  output$mytable = renderDataTable({sorted_data_table})
  output$GeneData <- renderPlot({ 
    mydata2 <- mydata[,2-3]
    barplot(mydata2[,input$mydatacol],
            main = "Bar Plot",
            ylab="data", 
            xlab= "genes")
    
  })
  output$distPlot <- renderPlot({
    logFC <- mydata[, 2]
    
    #draw the histogram with the specified number of bins
    hist(logFC, breaks = 50, col = 'blue', border = 'white')
  })
  
 


  
}
