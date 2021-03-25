library('shiny')
library('dplyr')
library('data.table')
library('RCurl')

#data <- read.csv('./new_comtrade_data.csv', header = TRUE, sep = ',')
#data <- data.table(data)

fileURL <- 'https://raw.githubusercontent.com/EugeniyAlexandrovich/analytical_package_R/master/Practice_3/data/new_comtrade_data.csv'

data <- read.csv(fileURL)
data <- data.table(data)

shinyServer(function(input, output){
  DT <- reactive({
    DT <- data[between(Year, input$year.range[1], input$year.range[2]) & Commodity.Code == input$sp.to.plot & Trade.Flow == input$trade.to.plot, ]
    DT <- data.table(DT)
  })
  output$sp.ggplot <- renderPlot({
    ggplot(data=DT(),
           aes(x = Year, y = Netweight..kg., group = 1)) +
      geom_line() + geom_point() +
      labs(title = "График динамики суммарной массы поставок по годам",
           x = 'Года', y = 'Сумма массы') +
      theme_dark() +
      scale_x_yearqtr(format = "%Y")
  })
})