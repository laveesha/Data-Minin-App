## GET STARTED ----------------------------------------------------------------------
source('dashboard/ui.R', local=TRUE)

start <- tabItem(
  tabName = "dashboard",
  dashboard
)


## CLUSTER ---------------------------------------------------------------------
source('clustering/ui.R', local=TRUE)

cluster <- tabItem(
 tabName = "cluster",
 cluster.box
)


## BODY ------------------------------------------------------------------------
body <- dashboardBody(
    tags$head(includeScript("www/google-analytics.js")),
    includeCSS("www/custom.css"),
    tabItems(
        start,
        cluster
        )
    )
