
library(shiny)
library(ggplot2)
library(DT)





cluster.box<-fluidPage(
  
  #tags$head(tags$style(HTML(mycss))),
  
  theme = shinytheme("flatly"),
    
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
                   column(width = 12,
                   DT::dataTableOutput('view'),style="height:500px;overflow-y: scroll;overflow-x: scroll;"),
                   value=1
          ),
          tabPanel("Cluster Analysis",    
                  numericInput('newclusters', 'Number of Clusters', 2, min = 1, max = 9),
                  plotOutput('kmeans_plot'),
                  h3("Cluster Details"),
                  column(width = 9,
                         DT::dataTableOutput('clust_table'),style="height:500px;overflow-y: scroll;overflow-x: scroll;"),
                  
                  value=1),
          
          tabPanel("Statistical Information", 
                   hr(),
                   h3("Optimal K Value"),
                   hr(),
                   selectInput('optimal_k', 'Methods',choices = c("Select a Method","Elbow", "Silhouette","NbClust()","Gap Statistic")),
                   hr(),
                   
                   
                   
                   
                   plotOutput('Sil_plot'),
                   hr(),
                   h3("Cluster Means"),
                   hr(),
                   #tableOutput('agg_table'),
                   column(width = 12,
                          DT::dataTableOutput('agg_table'),style="overflow-x: scroll;"),
                   hr(),
                   h3("Cluster Size"),
                   hr(),
                   #tableOutput('sum_table'),
                   column(width = 12,
                          DT::dataTableOutput('sum_table'),style="overflow-x: scroll;"),
                   
                    value=1),
          hr(),
         
          # tabPanel("Prediction Analysis",tableOutput("prediction"),value=1), 
          id = "conditionedPanels"
         
         
        ))
    
    )