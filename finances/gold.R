data <- read.csv("DailyGoldPrice.csv", stringsAsFactors=FALSE)
library(readr)

pacman::p_load(
  parsedate)        # data import/export
library(parse_load)

### Format date from "mmm, dd yyyy" to "dd-mm-yyyy"
col1_char <- pull(data, Date)
col1_nocommas <- sub(",","", col1_char)
col1_date <- parse_date(col1_nocommas, "%b %d %Y", locale = locale("en"))
col1_date_formatted <- format(col1_date, "%d-%m-%Y")
data[1] <- col1_date_formatted

### Convert price data from Format to Numeric
price <- data$Close
price_num <- as.numeric(sub(",", "", price))

#### Filter out: date, end daily prices
date <- data.frame(year = as.numeric(format(col1_date, format = "%Y")),
                month = as.numeric(format(col1_date, format = "%m")),
                day = as.numeric(format(col1_date, format = "%d")))
new_data <- data.frame(year = date[1], month = date[2], day = date[3], price = data$Close)
new_data <- data.frame(date=col1_date, price=price_num)


#### Plotting
ggplot(new_data, position="dodge") + 
  geom_point(aes(y=price, x=date), color="blue", size=0.1, alpha=0.1, stat="identity") +
  geom_smooth(aes(y=price, x=date), color="blue", alpha=0.2, stat="identity") +
  scale_x_date(date_breaks = "6 months", date_labels = "%m-%Y") +
  labs(x="Date", y="Price (USD)", title="Price of Gold from 2018 to 2023")
