dataset<-read.csv("C:/Users/User/Desktop/V2/FDMApp-V1/MyApp/DataSet/dataset.csv", header = T)
names(dataset)

df<-data.frame(dataset)

newData<-subset(df,select = c("Avg..Price","Brand.Runs","No..of..Trans","No..of.Brands","Others.999","Total.Volume","Value","Br..Cd..57..144","Br..Cd..55","Br..Cd..272","Br..Cd..286","Br..Cd..24","Br..Cd..481","Br..Cd..352","Br..Cd..5"))

#take column max values and copy it to new column called "Max"
newData$Maximum_Brand_Loyalty <-apply(newData[,8:15],1,max,na.rm=TRUE)
dataset2<-subset(newData,select = c("Avg..Price","Brand.Runs","No..of..Trans","No..of.Brands","Others.999","Total.Volume","Value","Maximum_Brand_Loyalty"))
scaledData<-scale(dataset2)

dataset3<-subset(df,select = c("Avg..Price","Pur.Vol.No.Promo","Pur.Vol.Promo.6","Pur.Vol.Other.Promo","PropCat.5","PropCat.6","PropCat.7","PropCat.8","PropCat.12","PropCat.15"))

dataSEC <-dataset[,12:46]
#names(dataSEC)

library(shiny)
library(ggplot2)

library(shinythemes)
dashboard<-fluidPage(
  #theme = shinytheme("flatly"),
  #shinythemes::themeSelector(),
  fluidPage(
    
    titlePanel("Bath Soap K-Mean Clustering"),
    
    sidebarPanel(
      
      selectInput('data', 'Select Data',choices = c("Select a dataset"="","Bath Soap Data"="dataset", "Purchase Behaviors"="dataset2","Basic Purchases"="dataset3")),
      
      numericInput('clusterCount','Cluster count',2,min = 1,max = 9)
      
      #downloadButton("downloadDataSet", "Download DataSet")
      
    ),
    
    mainPanel(
    
    tabsetPanel(type = "tabs",
                #tabPanel("DataSet", tableOutput("table")),
                tabPanel("DataSet",
                  hr(),
                  downloadButton("downloadDataSet", "Download DataSet"),
                  hr(),
                  column(width = 12,
                       DT::dataTableOutput('viewTable'),style="height:300px;overflow-y: scroll;overflow-x: scroll;"),
                
                value=1,
                
                hr(),
                h4("   "),
                h4("Data Summary"),
                hr(),
                verbatimTextOutput("summaryTab")),
                
                
                tabPanel("Cluster", 
                        hr(),
                        actionButton("show", "Show More"),
                      
                        
                        hr(),
                        plotOutput("clustplot"),
                        hr(),
                        #downloadButton("downloadPlot", "Download Plot"),
                        hr(),
                        h4("Cluster Details"),
                        column(width = 12,
                              DT::dataTableOutput('table'),style="height:500px;overflow-y: scroll;overflow-x: scroll;"),
                                              
                              value=1
                        ),
                
                tabPanel("Cluster Summary & Segmentations", 
                         hr(),
                         h4("Customer Segmentation"),
                         hr(),
                         column(width = 12,
                                DT::dataTableOutput('tableSegment'),style="height:300px;overflow-y:scroll;"),
                         hr(),
                         h4("Cluster Size"),
                         hr(),
                         column(width = 12,
                                DT::dataTableOutput('tableSize'),style="height:200px;overflow-y:scroll;"),
                         
                         value=1,
                         hr(),
                         h4("Cluster Mean"),
                         hr(),
                         column(width = 12,
                                DT::dataTableOutput('clus_mean_tab'),style="overflow-x: scroll;"),
                         
                        # value=1,
                         hr(),
                        h4("Cluster Sum of Squares"),
                        hr(),
                        column(width = 12,
                               DT::dataTableOutput('clus_ssq'),style="overflow-y: scroll;"),
                        
                        # value=1,
                        hr()
                        # h4("Cluster Summary"),
                        # hr(),
                        # verbatimTextOutput("summary"),
                        # hr(),
                        # h4("Cluster Analysis Details"),
                        # hr(),
                        # verbatimTextOutput("summary1"))
    
    
    
    
    ))))
  
  
  #fluidPage(
    
   # titlePanel("Bath Soap K-Mean Clustering - Purchase Behaviour"),
    
   # sidebarPanel(
      
  #    sliderInput('sampleSize2', 'Sample Size', min=1, max=nrow(dataset2),
  #                value=min(100, nrow(dataset2)), step=5, round=0),
  #    selectInput('xcol2', 'X Variable',names(dataset2)),
      
   #   selectInput('ycol2', 'Y Variable',names(dataset2),names(dataset2)[2] ),
   #   numericInput('clusters2','Cluster count',2,min = 1,max = 9)
      
      
  #  ),
    
  #  mainPanel(
  #    plotOutput('plot2')
  #  )
 # ),
  
  
  
  
  #fluidPage(
    
  #  titlePanel("Bath Soap K-Mean Clustering - Basic Purchases"),
    
  #  sidebarPanel(
      
   #   sliderInput('sampleSize3', 'Sample Size', min=1, max=nrow(dataset3),
      #            value=min(100, nrow(dataset3)), step=5, round=0),
   #   selectInput('xcol3', 'X Variable',names(dataset3)),
      
    #  selectInput('ycol3', 'Y Variable',names(dataset3),names(dataset3)[2] ),
     # numericInput('clusters3','Cluster count',2,min = 1,max = 9)
      
      
  #  ),
    
   # mainPanel(
    #  plotOutput('plot3')
    #)
#  )
) 

