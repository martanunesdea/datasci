### SP500 ###
sp500 <- read.csv("spy.csv", stringsAsFactors=FALSE)

## Format char dates into date format
sp500$Date <- parse_date(sp500$Date, locale = locale("en"))

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
