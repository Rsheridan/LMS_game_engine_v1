require(shinydashboard)
require(shiny)
require(rCharts)
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Team", tabName = "team"),
    menuItem("Player", tabName = "player"),
    menuItem("Next fixture",tabName="next_fixture"),
    menuItem("MVP",tabName = "mvp")
  )
  
)


body <- dashboardBody(
  tabItems(
    tabItem(tabName = "team",
            fluidRow(
              box(width=4,title="How to use","This is the Two Bats Or Not To Bat 'Game Engine'. Use it to keep track of team statistics, your own game, the current MVP standings, and info about our next opponent. 
                  Feedback welcome", a('here',href="mailto:robbies121@gmail.com?body=My suggestion is...&subject=Game enging suggestion box")),
              box(width=4,title="Last Fixture","last fixture details here- Best bowler, top scorer"),
              box(width=4,title="Team statistics","Total wickets, total runs scored, total runs conceded, total games played, win %")
            ),
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
    ),
    
    tabItem(tabName = "player",
            fluidRow(
                box(width=8,title='Guide','This page helps you analyze your game, and that of your teammates. Use the selection to choose your player, and then
                     see their batting form, bowling form, and top dismissals. Also see their summary career statistics'),
                box(width=4,title='Select your player',selectInput('player_name','',choices=dropdown_choices,selected=NULL))
            ),
            fluidRow(
              box(width=6,title='Batting form',showOutput("batting_time","highcharts"),HTML('<style>.rChart {width: 100%; height: 100%}</style>')),
              box(width=6,title='Bowling form',showOutput("bowling_time","highcharts"),HTML('<style>.rChart {width: 100%; height: 100%}</style>'))
            ),
            fluidRow(
              box(width=6,title='Top dismissal mode','How out bar chart')
            ))
    
    
  )
)


# Put them together into a dashboardPage
dashboardPage(skin='black',
              dashboardHeader(title = ("Game Engine")),
              sidebar,
              body
)
