library(shiny)
library(shinydashboard)
library(ggplot2)
library(dplyr)


library(fpc)
library(cluster)
library(factoextra)

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
#dataSec<-dataset[,12:46]

#function(input, output) { 
  
  
  
  
  dataset_5 <- reactive({
    
   validate(need(input$data != "","Please Select a data set"))
    
    #req(input$data)
    get(input$data)
  })
  
  clusters<-reactive({
    kmeans(dataset_5(),input$clusters)
  })
  
  output$plot<-renderPlot({
    #par(mar =c(5.1,4.1,0,1))
    # plot(dataset_5(), col=clusters()$cluster, pch =20, cex =3)
    # points(clusters()$centers, pch =4, cex =4,lwd =4)
    
    #if(is.null(input$data)
    
    
    clusplot(dataset_5(), clusters()$cluster, main='2D representation of the Cluster solution', color = TRUE,
             shade=TRUE,
             labels=2, lines=0)
  })
  
  output$table<-renderTable({
    #par(mar =c(5.1,4.1,0,1))
    # plot(dataset_5(), col=clusters()$cluster, pch =20, cex =3)
    # points(clusters()$centers, pch =4, cex =4,lwd =4)
    
    #if(is.null(input$data)
    #head(dataset_5(),10)
    
    agg_table <-  aggregate(dataset_5(), by=list(cluster=clusters()$cluster),mean)
    agg_table
  })
  
  
  #input,output for purchase behaviour
  dataset_2 <- reactive({
    scaledData[sample(nrow(scaledData), input$sampleSize2),c(input$xcol2,input$ycol2)]
  })
  
  clusters2<-reactive({
    kmeans(dataset_2(),input$clusters2)
  })
  
  output$plot2<-renderPlot({
    par(mar =c(5.1,4.1,0,1))
    plot(dataset_2(), col=clusters2()$cluster, pch =20, cex =3)
    points(clusters2()$centers, pch =4, cex =4,lwd =4)
  })
  
  
  
  
  #input,output for basic purchases
  dataset_3 <- reactive({
    dataset3[sample(nrow(dataset3), input$sampleSize3),c(input$xcol3,input$ycol3)]
  })
  
  clusters3<-reactive({
    kmeans(dataset_3(),input$clusters3)
  })
  
  output$plot3<-renderPlot({
    par(mar =c(5.1,4.1,0,1))
    plot(dataset_3(), col=clusters3()$cluster, pch =20, cex =3)
    points(clusters3()$centers, pch =4, cex =4,lwd =4)
  })
  
  
  
#}
