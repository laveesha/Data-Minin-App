server <- function(input, output, session) {
  ## UPLOAD --------------------------------------------------------------------
  source("dashboard/server.R", local=TRUE)
  
  ## UPLOAD Results --------------------------------------------------------------------
  #source("dashboardResults/server.R", local=TRUE)

  ## CLUSTER --------------------------------------------------------------------
  source("clustering/server.r", local=TRUE)
  
  
}

