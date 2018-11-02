
library(shiny)
library(ggplot2)

cluster.box<-fluidPage(
    
    titlePanel("Cluster Analysis"),
    
    sidebarPanel(
      
        h2("Data Bar"),
        
        # Button to import data
        fileInput('file1', 'Upload data',
                  accept=c('text/csv', 'text/comma-separated-values,text/plain')),
        conditionalPanel(condition="input.conditionedPanels==1"),
        conditionalPanel(condition="input.conditionedPanels==1",
                         tabPanel("Columns",uiOutput("choose_columns"))
                         #tabPanel("target",uiOutput("choose_target"))
        )
        #wellPanel(img(src = "logo.png", height = 89, width = 200,align="center"))
        
      ),
    
      # Main panel (on the right hand side)
      mainPanel(
        tabsetPanel(
          tabPanel("Data",
                   h3("Uploaded DataSet"),
                   #p("(A maximum of 50 rows and 10 columns can be displayed here due to window size, but all of the data uploaded will be used for prediction and cluster analysis.)"),
                   tableOutput("view"),
                   value=1
          ),
          tabPanel("Cluster Analysis",    
                   numericInput('clusters', 'Number of Clusters', 2, min = 1, max = 9),
                   plotOutput('kmeans_plot'),
                   h3("Cluster Means"),
                   tableOutput('agg_table'),
                   value=1),
          # tabPanel("Prediction Analysis",tableOutput("prediction"),value=1), 
          id = "conditionedPanels"
        ))
    )