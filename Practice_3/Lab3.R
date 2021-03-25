# Загрузка пакетов
library('shiny')               # создание интерактивных приложений
library('lattice')             # графики lattice
library('data.table')          # работаем с объектами "таблица данных"
library('ggplot2')             # графики ggplot2
library('dplyr')               # трансформации данных
library('lubridate')           # работа с датами, ceiling_date()
library('zoo')                 # работа с датами, as.yearmon()


data <- read.csv('./data/comtrade_data.csv', header = TRUE, sep = ',')
data <- data[, c(2, 4, 8, 10, 22, 30)]
data

# Фильтр кода продукции
code.filter <- as.character(unique(data$Commodity.Code))
names(code.filter) <- code.filter
code.filter <- as.list(code.filter)
code.filter

# Фильтр для года
year.filter <- as.character(unique(data$Year))
names(year.filter) <- year.filter
year.filter <- as.list(year.filter)
year.filter

# Фильтар для (ре-)экпорт/(ре-)импорт
trade.flow.filter <- as.character(unique(data$Trade.Flow))
names(trade.flow.filter) <- trade.flow.filter
trade.flow.filter <- as.list(trade.flow.filter)
trade.flow.filter

# Заменяем путые значения медианой и суммируем массу для каждого года, экспорта/импорта, кода продукта
DF <- data.frame()
for (code in code.filter){
  for (year in year.filter){
    for (trade.flow in trade.flow.filter){
      # DF <- rbind(DF, data.frame(Year = year, Trade.Flow = trade.flow, Commodity.Code = code,
      #                            Netweight..kg. = sum(data[data$Year == year & data$Trade.Flow == trade.flow & data$Commodity.Code == code, ]$Netweight..kg.)))
      temp_df <- data[data$Year == year & data$Trade.Flow == trade.flow & data$Commodity.Code == code, ]
      mediana <- median(temp_df$Netweight..kg[!is.na(temp_df$Netweight..kg.)])
      temp_df[is.na(temp_df)] <- mediana
      DF <- rbind(DF, data.frame(Year = year, Trade.Flow = trade.flow, Commodity.Code = code,
                                 Netweight..kg. = sum(temp_df$Netweight..kg.)))
    }
  }
}
DF

file.name <- paste('./data/new_comtrade_data.csv', sep = '')
write.csv(DF, file.name, row.names = FALSE)

# Фильтруем данные
new.DF <- DF[DF$Commodity.Code == code.filter[1] & DF$Trade.Flow == trade.flow.filter[1], ]
new.DF

# Строим график
ggplot(data=new.DF, aes(x = Year, y = Netweight..kg., group = 1)) +
  geom_line() + geom_point() +
  labs(title = "График динамики суммарной массы поставок по годам",
       x = 'Года', y = 'Сумма массы') +
  theme_dark()

# Запуск приложения
runApp('./UN_COMTRADE_APP', launch.browser = TRUE,
       display.mode = 'showcase')
