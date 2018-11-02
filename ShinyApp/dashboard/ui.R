
dataset1<-read.csv("F:/SLIIT/3rd Year/2nd semester/FDM/kush/FDM/DataSet/dataset1.csv", header = T)

dataset<-read.csv("F:/SLIIT/3rd Year/2nd semester/FDM/kush/FDM/DataSet/dataset.csv", header = T)
names(dataset)
df<-data.frame(dataset)
newData<-subset(df,select = c("Avg..Price","Brand.Runs","No..of..Trans","No..of.Brands","Others.999","Total.Volume","Value","Br..Cd..57..144","Br..Cd..55","Br..Cd..272","Br..Cd..286","Br..Cd..24","Br..Cd..481","Br..Cd..352","Br..Cd..5"))
#take column max values and copy it to new column called "Max"
newData$Maximum_Brand_Loyalty <-apply(newData[,8:15],1,max,na.rm=TRUE)
dataset2<-subset(newData,select = c("Avg..Price","Brand.Runs","No..of..Trans","No..of.Brands","Others.999","Total.Volume","Value","Maximum_Brand_Loyalty"))
scaledData<-scale(dataset2)

dataset3<-read.csv("F:/SLIIT/3rd Year/2nd semester/FDM/kush/FDM/DataSet/dataset3.csv", header = T)


dataSEC <-dataset[,12:46]
#names(dataSEC)

library(shiny)
library(ggplot2)

dashboard<-fluidPage(
  
  fluidPage(
    
    titlePanel("Bath Soap K-Mean Clustering"),
    
    sidebarPanel(
      
      selectInput('data', 'Select Data',choices = c("Select a dataset"="","Bath Soap Data"="dataset", "Purchase Behaviors"="dataset2","Basic Purchases"="dataset3")),
      
      numericInput('clusters','Cluster count',2,min = 1,max = 9)
      
    ),
    
    mainPanel(
      plotOutput('plot'),
      tableOutput('table')
    )),
  
  
  fluidPage(
    
    titlePanel("Bath Soap K-Mean Clustering - Purchase Behaviour"),
    
    sidebarPanel(
      
      sliderInput('sampleSize2', 'Sample Size', min=1, max=nrow(dataset2),
                  value=min(100, nrow(dataset2)), step=5, round=0),
      selectInput('xcol2', 'X Variable',names(dataset2)),
      
      selectInput('ycol2', 'Y Variable',names(dataset2),names(dataset2)[2] ),
      numericInput('clusters2','Cluster count',2,min = 1,max = 9)
      
      
    ),
    
    mainPanel(
      plotOutput('plot2')
    )
  ),
  
  
  
  
  fluidPage(
    
    titlePanel("Bath Soap K-Mean Clustering - Basic Purchases"),
    
    sidebarPanel(
      
      sliderInput('sampleSize3', 'Sample Size', min=1, max=nrow(dataset3),
                  value=min(100, nrow(dataset3)), step=5, round=0),
      selectInput('xcol3', 'X Variable',names(dataset3)),
      
      selectInput('ycol3', 'Y Variable',names(dataset3),names(dataset3)[2] ),
      numericInput('clusters3','Cluster count',2,min = 1,max = 9)
      
      
    ),
    
    mainPanel(
      plotOutput('plot3')
    )
  )
) 

