## SIDEBAR

sidebar <- dashboardSidebar(
  sidebarMenu(
        menuItem(
            "Sample Clustering",
            tabName = "dashboard",
            icon = icon("play")
        ),
 
        menuItem(
          "Cluster Analysis",
          tabName = "cluster",
          icon = icon("sitemap")
        )
    )
)
