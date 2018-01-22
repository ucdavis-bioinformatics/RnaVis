RnaVis
===
The purpose of this app is to allow filter and visualize data. After receiveing the input, the app organizes data into a readable and conscise data table and creates several different graphs. Additionaly, it has the capacity to read in more than one table.  

# Features: 




  • Allows user to filter data based on different columns
  
  
  
  
  • Visualize LogFC column into a bar graph
  
  
  
  
  • Volcano Plot
  
  
  
  
  • Represents Expressions table 
  
  
  
  
  • Creates Line plot with expressions table data
  
  
  
  
The app will allow the user to download the filtered data table/any visualizions they create in differernt formats. 
  
# Instructions


1. Select File you would like to display using menu on left

 ![select gene table](https://user-images.githubusercontent.com/29413695/35205338-47a6abc6-fee9-11e7-87b8-3710617a2604.png)



2. The file will be displayed in an interactive data table 

![gene table](https://user-images.githubusercontent.com/29413695/35205354-627b9434-fee9-11e7-890f-9f20f7fea1d5.png)


Click on gene name to look it up - choose search engine in drop down box on the left hand menu: 


3. Filter LogFC values or Adjusted P. Values with drop down boxes on left hand menu 

![logfc](https://user-images.githubusercontent.com/29413695/35205392-bd2ffd16-fee9-11e7-8095-03c02e32b092.png)


4. LogFC values will create an interactive bar plot on a seperate table labeled: LogFC Bar PLot

![bar graph](https://user-images.githubusercontent.com/29413695/35205399-cb32f562-fee9-11e7-802f-d660b95ebf3c.png)
   
   NOTE: adjust lower and upper bounds with drop down menu
   NOTE: You may choose to change the colors of the positive and negative values on the bar plot
   
![pos neg](https://user-images.githubusercontent.com/29413695/35205411-e2fad94e-fee9-11e7-892d-989e52fa3001.png)
   
   
  
5. The Adjusted P. Values will be displayed in a volcano Plot on a seperate tab labled: Volcano Plot

![volcano screenshot](https://user-images.githubusercontent.com/29413695/35205417-f2bdf096-fee9-11e7-9d9a-f563ce4b877d.png)

   Choose the maximum P value for the plot on the left hand side drop down box
   
![adj p value](https://user-images.githubusercontent.com/29413695/35205436-0200b642-feea-11e7-91bb-bdcb6725fa14.png)

   
6. You may add an expressions table - which will be filtered alongside the original gene table.
   NOTE: this expressions table will also create a line graph with a legend on the right hand side
   
7.  You may download and filtered data table or graph in different formats using the buttons on the left hand side menu:


# Installation 

1. Download RStudio here: https://www.rstudio.com/products/rstudio/download/#download

2. Open a shiny project in R studio which contains a server and UI page

3. Go to RNAvis repository on Github (linked at the top of the page)

4. Copy and paste the server and UI code into Rstudio - You will have to install all shiny packages in the console. 
   Use the function - install.packages("") 
   
   Packages are listed at the top of server and UI code as : 
   
   
   
library(shiny)
library(ggplot2)
library(lattice)
library(RColorBrewer)
library(plotly)
library(manhattanly)
   

5. Run App


