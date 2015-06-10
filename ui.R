require(shinydashboard)
require(shiny)
require(rCharts)
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Team", tabName = "team"),
    menuItem("Player", tabName = "player"),
    menuItem("Next fixture",tabName="next_fixture")
  )
  
)


body <- dashboardBody(
  tabItems(
    tabItem(tabName = "team",h2("Scatter plot"),
            fluidRow(
              box(width=8,title="Player comparison",showOutput("scatter","highcharts"),HTML('<style>.rChart {width: 100%; height: 100%}</style>')),
              box(width=4,title="",
                  radioButtons("xaxis", "Select x-axis:",
                               c("Batting world ranking" = "batting_world_ranking",
                                 "# not outs" = "not_outs",
                                 "Career runs" = "total_runs",
                                 "Career batting average"="batting_average",
                                 "Balls faced"="balls_faced",
                                 "Batting strike rate"="strike_rate",
                                 "Bowling world ranking"="bowling_world_ranking",
                                 "Overs bowled"="overs_bowled",
                                 "Runs conceded"="runs_conceded",
                                 "# Wickets"="wickets",
                                 "Career bowling average"="bowling_average",
                                 "Bowling economy"="economy"                                 
                                 )),
                  radioButtons("yaxis", "Select y-axis:",
                               c("Batting world ranking" = "batting_world_ranking",
                                 "# not outs" = "not_outs",
                                 "Career runs" = "total_runs",
                                 "Career batting average"="batting_average",
                                 "Balls faced"="balls_faced",
                                 "Batting strike rate"="strike_rate",
                                 "Bowling world ranking"="bowling_world_ranking",
                                 "Overs bowled"="overs_bowled",
                                 "Runs conceded"="runs_conceded",
                                 "# Wickets"="wickets",
                                 "Career bowling average"="bowling_average",
                                 "Bowling economy"="economy"                                 
                               ))
                                    
              )
            )
    )
  )
)


# Put them together into a dashboardPage
dashboardPage(skin='black',
              dashboardHeader(title = ("Game Engine")),
              sidebar,
              body
)
