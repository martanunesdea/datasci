### SP500 ###
sp500 <- read.csv("spy.csv", stringsAsFactors=FALSE)

## Format char dates into date format
sp500$Date <- parse_date(sp500$Date, locale = locale("en"))


### Oil data ###
oil_data <- read.csv("BrentOilPrices.csv", stringsAsFactors=FALSE)

oil_data_cpy1 <- oil_data[0:8360, ]
oil_data_cpy1$Date <- parse_date(oil_data_cpy1$Date, format="%d-%b-%y", locale = locale("en"))

oil_data_cpy2 <- oil_data[8361:9011, ]
oil_data_cpy2$Date <- sub(",","", oil_data_cpy2$Date)
oil_data_cpy2$Date <- parse_date(oil_data_cpy2$Date, "%b %d %Y", locale = locale("en"))

oil_data <- as.data.frame(rbind(oil_data_cpy1, oil_data_cpy2))

## Plot
ggplot() + 
  geom_point(aes(y=sp500$Close, x=sp500$Date), color="blue", size=0.1, alpha=0.7) +
  geom_smooth(aes(y=sp500$Close, x=sp500$Date), color="blue", alpha=0.2, stat="identity") +
  scale_x_date(date_breaks = "1 year", date_labels = "%y") +
  labs(x="Date", y="Price (USD)", title="Price of S&P500 from 1993 to 2023")


### Combined plot w/ other data frames in project
ggplot() + 
  geom_point(aes(y=new_gold_data$price, x=new_gold_data$date), color="red", size=0.1, alpha=0.1, stat="identity") +
  geom_smooth(aes(y=new_gold_data$price, x=new_gold_data$date), color="red", alpha=0.2, stat="identity") +
  scale_x_date(date_breaks = "6 months", date_labels = "%m-%Y") +
  labs(x="Date", y="Price (USD)") +
  geom_point(aes(y=sp500$Close, x=sp500$Date), color="blue", size=0.1, alpha=0.7) +
  geom_smooth(aes(y=sp500$Close, x=sp500$Date), color="blue", alpha=0.2, stat="identity") +
  scale_x_date(date_breaks = "1 year", date_labels = "%y") +
  labs(x="Date", y="Price (USD)", title="Price of Gold (red) and S&P500 (blue) from 1993 to 2023")

### Oil and S&P500 comparison ###
ggplot() + 
  geom_point(aes(y=oil_data$Price, x=oil_data$Date), color="darkgrey", size=0.1, alpha=0.7) +
  geom_smooth(aes(y=oil_data$Price, x=oil_data$Date), color="darkgrey", alpha=0.2, stat="identity") +
  geom_point(aes(y=sp500$Close, x=sp500$Date), color="blue", size=0.1, alpha=0.7) +
  geom_smooth(aes(y=sp500$Close, x=sp500$Date), color="blue", alpha=0.2, stat="identity") +
  scale_x_date(date_breaks = "5 years", date_labels = "%Y") +
  labs(x="Date", y="Price (USD)", title="Price of Brent Crude Oil (blue) and SP500 from 1987 to 2023")


### Select only from year 2018 to 2022
oil_data_trimmed <- filter(oil_data, Date > '2018-01-01')
sp500_trimmed <- filter(sp500, Date > '2018-01-01')

ggplot() + 
  geom_point(aes(y=oil_data_trimmed$Price, x=oil_data_trimmed$Date), color="darkgrey", size=0.1, alpha=0.7) +
  geom_smooth(aes(y=oil_data_trimmed$Price, x=oil_data_trimmed$Date), color="darkgrey", alpha=0.2, stat="identity") +
  geom_point(aes(y=sp500_trimmed$Close, x=sp500_trimmed$Date), color="blue", size=0.1, alpha=0.7) +
  geom_smooth(aes(y=sp500_trimmed$Close, x=sp500_trimmed$Date), color="blue", alpha=0.2, stat="identity") +
  geom_point(aes(y=new_gold_data$price, x=new_gold_data$date), color="orange", size=0.1, alpha=0.1, stat="identity") +
  geom_smooth(aes(y=new_gold_data$price, x=new_gold_data$date), color="orange", alpha=0.2, stat="identity") +
  scale_x_date(date_breaks = "6 months", date_labels = "%m-%Y") +
  labs(x="Date", y="Price (USD)", title="Price of Brent Crude Oil (blue) and SP500 from 1987 to 2023")
