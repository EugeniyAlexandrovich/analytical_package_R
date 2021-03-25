library('shiny')

data <- read.csv('./new_comtrade_data.csv', header = TRUE, sep = ',')
#data

# Фильтр кода продукции
code.filter <- as.character(unique(data$Commodity.Code))
names(code.filter) <- code.filter
code.filter <- as.list(code.filter)
#code.filter

# Фильтр для года
year.filter <- as.character(unique(data$Year))
names(year.filter) <- year.filter
year.filter <- as.list(year.filter)
#year.filter

# Фильтар для (ре-)экпорт/(ре-)импорт
trade.flow.filter <- as.character(unique(data$Trade.Flow))
names(trade.flow.filter) <- trade.flow.filter
trade.flow.filter <- as.list(trade.flow.filter)
#trade.flow.filter

shinyUI(
  pageWithSidebar(
    headerPanel("График динамики суммарной массы поставок по годам"),
    sidebarPanel(
      # Выбор кода продукции
      selectInput('sp.to.plot',
                  'Выберите код продукта',
                  list('Рыба; живая (0301)' = '301',
                       'Рыба; свежая, охлажденная (0302)' = '302',
                       'Рыба; замороженная (0303)' = '303',
                       'Рыбное филе и прочая рыба (0304)' = '304',
                       'Рыба; сушеная, соленая, копченая (0305)' = '305',
                       'Ракообразные (0306)' = '306',
                       'Моллюски (0307)' = '307',
                       'Водные беспозвоночные (0308)' = '308'),
                  selected = '301'),
      # Выбор экпорт/импорт
      selectInput('trade.to.plot',
                  'Выберите Экспорт/Импорт',
                  trade.flow.filter),
      # Период, по годам
      sliderInput('year.range', 'Года:',
                  min = 2010, max = 2020, value = c(2010, 2020),
                  width = '100%', sep = '')
      ),
      mainPanel(
        textOutput('sp.text'),
        plotOutput('sp.ggplot')
      )
  )
)
