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
    plot$series(data = toJSONArray2(to_plot,json=F),name="Players",color='rgba(51, 51, 51, 0.5)')
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
      mutate(label=paste0(date,', ',Opposition))%>%
      select(x=order,y=RS,label)%>%
      top_n(10,x)
  
    
    plot <- rCharts:::Highcharts$new()
    plot$chart(type="line")
    plot$series(data = toJSONArray2(data,json=F),name="Runs scored",color='rgba(51, 51, 51, 1)')
    plot$yAxis(title="{text: 'Bowling economy'}", gridLineColor="#FFFFFF", floor=0)
    plot$xAxis(gridLineColor="#FFFFFF",lineColor="#FFFFFF",tickColor="#FFFFFF",labels=list(enabled=F))
    plot$plotOptions(
      line = list(
        lineWidth=3,
        marker=list(
          symbol="circle",
          radius= 2,
          color='rgba(51, 51, 51, 1)'))
    )
    
    
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
      mutate(label=paste0(date,', ',Opposition))%>%
      select(x=order,y,label)%>%
      top_n(10,x)
    
    plot <- rCharts:::Highcharts$new()
    plot$chart(type="line")
    plot$series(data = toJSONArray2(data,json=F),name="Bowling economy",color='rgba(51, 51, 51, 1)')
    plot$yAxis(title="{text: 'Bowling economy'}", gridLineColor="#FFFFFF", floor=0)
    plot$xAxis(gridLineColor="#FFFFFF",lineColor="#FFFFFF",tickColor="#FFFFFF",labels=list(enabled=F))
    plot$plotOptions(
      line = list(
        lineWidth=3,
        marker=list(
          symbol="circle",
          radius= 2,
          color='rgba(51, 51, 51, 1)'))
    )
    plot
  })
  
  
}) 
