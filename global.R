require(dplyr)
require(rvest)

#Building blocks functions

#1. get results summary of a given team
get_results<-function(teamid){ 
  results_wr<-html(paste0('http://www.lastmanstands.com/team-results?teamid=',teamid,'#team-stats-content'))%>%
    html_nodes('#team-stats-content')%>%
    html_nodes('table')%>%
    html_table()%>%
    .[[1]]
  
  results_non_wr<-html(paste0('http://www.lastmanstands.com/team-results?teamid=',teamid,'#team-stats-content'))%>%
    html_nodes('#team-stats-content')%>%
    html_nodes('table')%>%
    html_table()%>%
    .[[2]]
  
  return(rbind(results_wr,results_non_wr))       
}

#2. get career history for a given player
get_player_stats<-function(user_id){
  
  data<-html(paste0('http://www.lastmanstands.com/career-history?userid=',user_id,'#player-stats-content'))%>%
    html_nodes('#player-stats-content')%>%
    html_nodes('table')%>%
    html_table()%>%
    .[[1]]
  
  return(data)
}


#3. Get team batting stats
team_batting<-function(teamid){
  
  data<-html(paste0("http://www.lastmanstands.com/team-batting-stats?teamid=",teamid,"#team-stats-content"))%>%
  html_nodes('#team-stats-content')%>%
  html_nodes('table')%>%
  html_table()%>%
  .[[1]]
  
  return(data)
}

#4. Get team bowling stats
team_bowling<-function(teamid){
  
  data<-html(paste0("http://www.lastmanstands.com/team-bowling-stats?teamid=",teamid,"#team-stats-content"))%>%
    html_nodes('#team-stats-content')%>%
    html_nodes('table')%>%
    html_table()%>%
    .[[1]]
  
  return(data)
}

#5. Get TBONTB next fixture
next_team_ID<-function(){
  
  return(html('http://www.lastmanstands.com/team-results?teamid=6746#team-stats-content')%>%
  html_node('#team-top-stats-right')%>%
  html_nodes('p a')%>%
  html_attr('href')%>%
  as.vector()%>%
  gsub(".*teamid=","",.))
}

#6. Get top three batsmen from a team page
get_top_three_batsmen<-function(teamid){

  data<-html(paste0('http://www.lastmanstands.com/team-results?teamid=',teamid,'#team-stats-content'))%>%
  html_node('#team-top-stats-left')%>%
  html_nodes('p a')%>%
  html_attr('href')%>%
  as.vector()%>%
  gsub(".*userid=","",.)
  
return(data)
}

#7. Get top three bowlers from a team page
get_top_three_bowlers<-function(teamid){
  
  data<-html(paste0('http://www.lastmanstands.com/team-results?teamid=',teamid,'#team-stats-content'))%>%
    html_node('#team-top-stats-mid')%>%
    html_nodes('p a')%>%
    html_attr('href')%>%
    as.vector()%>%
    gsub(".*userid=","",.)
  
  return(data)
}

#8. Lookup ID numbers of players
get_player_id_lookup<-function(){
  
  ids<-html("http://www.lastmanstands.com/team-batting-stats?teamid=6746#team-stats-content")%>%
    html_nodes('#team-stats-content')%>%
    html_nodes('table,a')%>%
    html_attr('href')%>%
    as.vector()%>%
    gsub(".*userid=","",.)%>%
    .[!is.na(.)]
  
  player_lookup<-html("http://www.lastmanstands.com/team-batting-stats?teamid=6746#team-stats-content")%>%
    html_nodes('#team-stats-content')%>%
    html_nodes('table')%>%
    html_table()%>%
    .[[1]]%>%
    select(Player)%>%
    cbind(.,ids)
  
  return(player_lookup)
}


#8. Lookup MVP table
batting_mvp<-html("http://www.lastmanstands.com/league-batting&leagueid=128&seasonid=62&divisionid=0")%>%
  html_nodes('#content-page-main-content-mid')%>%
  html_nodes('table')%>%
  html_table()%>%
  .[[1]]
names(batting_mvp)<-c('ranking','player','team','batting_points')
batting_mvp<-filter(batting_mvp,team=='Two Bats Or Not To Bat')

bowling_mvp<-html("http://www.lastmanstands.com/league-bowling&leagueid=128&seasonid=62&divisionid=0")%>%
  html_nodes('#content-page-main-content-mid')%>%
  html_nodes('table')%>%
  html_table()%>%
  .[[1]]
names(bowling_mvp)<-c('ranking','player','team','bowling_points')
bowling_mvp<-filter(bowling_mvp,team=='Two Bats Or Not To Bat')

keeping_mvp<-html("http://www.lastmanstands.com/league-keeping&leagueid=128&seasonid=62&divisionid=0")%>%
  html_nodes('#content-page-main-content-mid')%>%
  html_nodes('table')%>%
  html_table()%>%
  .[[1]]
names(keeping_mvp)<-c('ranking','player','team','keeping_points')
keeping_mvp<-filter(keeping_mvp,team=='Two Bats Or Not To Bat')

mvp<-left_join(bowling_mvp,batting_mvp,by='player')%>%
  left_join(keeping_mvp,by='player')%>%
  select(player,batting_points,bowling_points,keeping_points)

#Now assemble some data sets we will use throughought
#Player to ID lookup
player_lookup<-get_player_id_lookup()
dropdown_choices<-setNames(player_lookup$Player,player_lookup$Player)


#Combine team bowling and batting statistics
batting<-team_batting(6746)
bowling<-team_bowling(6746)

team_batting_bowling<-inner_join(batting,bowling,by='Player')%>%
  left_join(mvp,by=c('Player'='player'))

names(team_batting_bowling)<-c('player',
                               'batting_world_ranking',
                               'batting_innings',
                               'not_outs',
                               'total_runs',
                               'batting_average',
                               'balls_faced',
                               'strike_rate',
                               'fifties',
                               'bowling_world_ranking',
                               'bowling_innings',
                               'overs_bowled',
                               'runs_conceded',
                               'wickets',
                               'best_figures',
                               'bowling_average',
                               'economy',
                               'batting_points',
                               'bowling_points',
                               'keeping_points')


#read how-out csv
how_out<-read.csv('how_out.csv')
