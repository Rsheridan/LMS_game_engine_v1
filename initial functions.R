#Functions required

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

#2. get statistics for a given player
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
get_top_three_batsmen<-function(teamid){
  
  data<-html(paste0('http://www.lastmanstands.com/team-results?teamid=',teamid,'#team-stats-content'))%>%
    html_node('#team-top-stats-mid')%>%
    html_nodes('p a')%>%
    html_attr('href')%>%
    as.vector()%>%
    gsub(".*userid=","",.)
  
  return(data)
}

get_player_stats(get_top_three_batsmen(next_team_ID())[1])


