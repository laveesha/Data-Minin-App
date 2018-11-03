library(shiny)
library(shinydashboard)
library(ggplot2)
library(dplyr)


library(fpc)
library(cluster)
library(factoextra)
library(devtools)

dataset<-read.csv("C:/Users/User/Desktop/V2/FDMApp-V1/MyApp/DataSet/dataset.csv", header = T)
names(dataset)

df<-data.frame(dataset)

newData<-subset(df,select = c("MEM","Avg..Price","Brand.Runs","No..of..Trans","No..of.Brands","Others.999","Total.Volume","Value","Br..Cd..57..144","Br..Cd..55","Br..Cd..272","Br..Cd..286","Br..Cd..24","Br..Cd..481","Br..Cd..352","Br..Cd..5"))

#take column max values and copy it to new column called "Max"
newData$Maximum_Brand_Loyalty <-apply(newData[,8:15],1,max,na.rm=TRUE)
dataset2<-subset(newData,select = c("MEM","Avg..Price","Brand.Runs","No..of..Trans","No..of.Brands","Others.999","Total.Volume","Value","Maximum_Brand_Loyalty"))
scaledData<-scale(dataset2)

dataset3<-subset(df,select = c("MEM","Avg..Price","Pur.Vol.No.Promo","Pur.Vol.Promo.6","Pur.Vol.Other.Promo","PropCat.5","PropCat.6","PropCat.7","PropCat.8","PropCat.12","PropCat.15"))

dataSEC <-dataset[,12:46]
#names(dataSEC)

#function(input, output) { 

#get selected dataset  
  dataset_5 <- reactive({
    
   validate(need(input$data != "","Please Select a data set"))
    
    #req(input$data)
    get(input$data)

    })
 
  idExtractorFunc <-reactive({
    
    d.inputSet= dataset_5()
    d.inputSet= d.inputSet[1]
    
  }) 

#get input cluster count perform k mean
  clusterCount<-reactive({
    
    if(identical(dataset_5(),dataset))
    {
      kmeans(dataset_5()[,12:46],input$clusterCount)
    }
    else{
      kmeans(dataset_5()[,-1],input$clusterCount)
    }
    
   # kmeans(dataset_5()[,-1],input$clusterCount)
  })
  

#plot the cluster    
  output$clustplot<-renderPlot({
    
    if(identical(dataset_5(),dataset))
    {
      clusplot(dataset_5()[,12:46], clusterCount()$cluster, main='2D representation of the Cluster solution', color = TRUE,shade=TRUE,labels=2, lines=0)
    }
    else{
      clusplot(dataset_5()[,-1], clusterCount()$cluster, main='2D representation of the Cluster solution', color = TRUE,shade=TRUE,labels=2, lines=0)
    }
    
    
   # clusplot(dataset_5()[,-1], clusterCount()$cluster, main='2D representation of the Cluster solution', color = TRUE,shade=TRUE,labels=2, lines=0)
  })
  
  
  
#perform action of "show more" button  
  observeEvent(input$show, {
    
    if(identical(dataset_5(),dataset))
    {
      showModal(modalDialog(
        title = "Bath Soap K-Mean Clustering - Bath Soap Data",
        "No More Additional Data to Display"
        ))
       
    }
    else if(identical(dataset_5(),dataset2)) {
    showModal(modalDialog(
      title = "Bath Soap K-Mean Clustering - Purchase Behaviour",
      sidebarPanel(
        
        sliderInput('sampleSize2', 'Sample Size', min=1, max=nrow(dataset2),
                    value=min(100, nrow(dataset2)), step=5, round=0),
        selectInput('xcol2', 'X Variable',names(dataset2),names(dataset2)[2]),
        
        selectInput('ycol2', 'Y Variable',names(dataset2),names(dataset2)[3] ),
        numericInput('clusters2','Cluster count',2,min = 1,max = 9)
 
      ),
      mainPanel(
        plotOutput("plot2")
      )
    ))}
    else if(identical(dataset_5(),dataset3)) {
      showModal(modalDialog(
        titlePanel("Bath Soap K-Mean Clustering - Basic Purchases"),
        
        sidebarPanel(
          
          sliderInput('sampleSize3', 'Sample Size', min=1, max=nrow(dataset3),
                      value=min(100, nrow(dataset3)), step=5, round=0),
          selectInput('xcol3', 'X Variable',names(dataset3),names(dataset3)[2]),
          
          selectInput('ycol3', 'Y Variable',names(dataset3),names(dataset3)[3] ),
          numericInput('clusters3','Cluster count',2,min = 1,max = 9)
        ),
        
        mainPanel(
          plotOutput('plot3')
        )
      ))}
    easyClose = TRUE
  })
  
  
  
  # Function that render the data file and passes it to ui.R
  output$viewTable = renderDataTable({
    d.input = dataset_5()
    if (is.null(d.input)) return(NULL)
    if (ncol(d.input>10)) d.input = d.input[] #$,1:10]
    dataset_5()
    # head(dataset_5(), n=50)  
  })
  
  
  # Downloadable csv of selected dataset ----
  output$downloadDataSet <- downloadHandler(
    filename = function() {
      #input$data,Sys.Date(), 
      paste(input$data,".csv",sep = "")
    },
    content = function(file) {
      write.csv(dataset_5(), file)
    }
  )
  
  # Downloadable csv of selected dataset ----
  
 # output$downloadPlot <- downloadHandler(
   # filename = function() {
      #input$data,Sys.Date(), 
   #   paste(input$data,".png",sep = "")
   # },
   # content = function(file) {
   #   png(file, width = 980, height = 400, units = "px", pointsize = 12,
   #       bg = "white", res = NA)
   #   clustplot()
   #   dev.off()},
  #  contentType = 'image/png'
 # )
  
  
  
 #output summary datset 
  output$summaryTab <- renderPrint({
    if(identical(dataset_5(),dataset))
    {
      summary(dataset_5()[,12:46])
    }
    else{
      summary(dataset_5()[,-1])
    }
    
    #summary(dataset_5()[,-1])
  })
  
  
  #output cluster details
  output$table<-renderDataTable({
    #par(mar =c(5.1,4.1,0,1))
    # plot(dataset_5(), col=clusters()$cluster, pch =20, cex =3)
    # points(clusters()$centers, pch =4, cex =4,lwd =4)
    
    #if(is.null(input$data)
    #head(dataset_5(),10)
    
    if(identical(dataset_5(),dataset))
    {
      c_table <-  datatable(cbind(dataset_5()[,12:46], by=list(cluster=clusterCount()$cluster)), options = list(paging = FALSE))
      c_table
    }
    else{
      c_table <-  datatable(cbind(dataset_5()[,-1], by=list(cluster=clusterCount()$cluster)), options = list(paging = FALSE))
      c_table
    }
    
    
    #c_table <-  datatable(cbind(dataset_5()[,-1], by=list(cluster=clusterCount()$cluster)), options = list(paging = FALSE))
    #c_table
    
  })
  
  
  output$tableSize<-renderDataTable({

    c_table1 <-  datatable(cbind(Cluster=sort(unique(clusterCount()$cluster)),Size=clusterCount()$size))
    c_table1
  })
  
  
  
  output$clus_mean_tab <- renderDataTable({
    
    if(identical(dataset_5(),dataset))
    {
      agg_tab <-  datatable(aggregate(dataset_5()[,12:46], by=list(cluster=clusterCount()$cluster),options = list(paging = FALSE,autoWidth = TRUE),mean),rownames = FALSE)
      agg_tab
    }
    else{
      agg_tab <-  datatable(aggregate(dataset_5()[,-1], by=list(cluster=clusterCount()$cluster),options = list(paging = FALSE,autoWidth = TRUE),mean),rownames = FALSE)
      agg_tab
    }
  })
  
  output$clus_ssq <- renderDataTable({
    
    ssq_tab <-  datatable(cbind(Cluster=sort(unique(clusterCount()$cluster)),Sum_of_Square=clusterCount()$withinss))
    ssq_tab
  })

  
  #output a summary of cluster
  output$tableSegment <- renderDataTable({
    seg_table <- datatable(cbind(idExtractorFunc(), by=list(Cluster=clusterCount()$cluster)), options = list(paging = FALSE,autoWidth = TRUE),rownames = FALSE)
    seg_table
  })
  
  #output details of cluster
  output$summary1 <- renderPrint({
    clusterCount()
    #summary(cluster1()$cluster)
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

