require(shiny)
require(rCharts)
require(lubridate)
shinyServer(function(input, output) {
 
  output$scatter<-renderChart2({
    x<-team_batting_bowling[,input$xaxis]
    y<-team_batting_bowling[,input$yaxis]
    player<-team_batting_bowling[,'player']
    
    to_plot<-data.frame(x,y,player)
    
    plot <- rCharts:::Highcharts$new()
    plot$chart(type="scatter")
    plot$series(data = toJSONArray2(to_plot,json=F),name="Players",color='rgba(26, 152, 5, 0.5)')
    plot$tooltip(useHTML = T, formatter = "#! function() { return this.point.player; } !#")
    plot$plotOptions(
      scatter = list(
        cursor = "pointer", 
#         point = list(
#           events = list(
#             click = "#! function() { window.open(this.options.link); } !#")), 
        marker = list(
          symbol = "circle", 
          radius = 5        )
      )
    )
    
    
    plot
  })
  
  output$batting_time<-renderChart2({
    
    id<-filter(player_lookup,Player==input$player_name)%>%
      select(ids)%>%
      .[,1]%>%
      as.vector()
    
    data<-get_player_stats(id)%>%
      mutate(date=dmy(Date))%>%
      mutate(order=min_rank(date))%>%
      select(x=order,y=RS)%>%
      top_n(10,x)
  
    
    plot <- rCharts:::Highcharts$new()
    plot$chart(type="line")
    plot$series(data = toJSONArray2(data,json=F),name="Runs scored - Last 10 games",color='rgba(26, 152, 5, 0.5)')
    
    plot
  })
  
  output$bowling_time<-renderChart2({
    id<-filter(player_lookup,Player==input$player_name)%>%
      select(ids)%>%
      .[,1]%>%
      as.vector()
    
    data<-get_player_stats(id)%>%
      mutate(date=dmy(Date))%>%
      mutate(order=min_rank(date))%>%
      mutate(y=RC/OB)%>%
      select(x=order,y)%>%
      top_n(10,x)
    
    plot <- rCharts:::Highcharts$new()
    plot$chart(type="line")
    plot$series(data = toJSONArray2(data,json=F),name="Bowling economy - Last 10 games",color='rgba(26, 152, 5, 0.5)')
    
    plot
  })
  
  
}) 
