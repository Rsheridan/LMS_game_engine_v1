require(shinydashboard)
require(shiny)
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Team", tabName = "team"),
    menuItem("Player", tabName = "player"),
    menuItem("Next fixture",tabName="next_fixture")
  )
  
)


body <- dashboardBody(
  )


# Put them together into a dashboardPage
dashboardPage(skin='black',
              dashboardHeader(title = ("Game Engine")),
              sidebar,
              body
)
