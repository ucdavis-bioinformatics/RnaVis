library(shiny)

function(input, output) {
  df <- read.table("/Users/Navya/Downloads/DavisData2.txt", header = TRUE, sep= "\t", as.is = TRUE)
  output$mytable = renderDataTable({
    df
  })
  output$distPlot <- renderPlot({
    #create bins based on input$bins from ui.R
    logFC <- mydata[, 2]
    
    #draw the histogram with the specified number of bins
    hist(logFC, breaks = input$bins, col = 'blue', border = 'white')
  })
  
}
