require(shiny)
require(rCharts)
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
        point = list(
          events = list(
            click = "#! function() { window.open(this.options.link); } !#")), 
        marker = list(
          symbol = "circle", 
          radius = 5        )
      )
    )
    
    
    plot
  })
  
  
}) 
