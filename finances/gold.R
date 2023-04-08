
# Data sources:
# Gold prices: https://www.kaggle.com/datasets/arslanr369/daily-gold-price-2018-2023?resource=download
# Brent Oil Prices: https://www.kaggle.com/datasets/mabusalah/brent-oil-prices
# S&P500: https://www.kaggle.com/datasets/youcanttouchthis/s-p-500-dataset

gold_data <- read.csv("DailyGoldPrice.csv", stringsAsFactors=FALSE)
library(readr)
library(dplyr)
library(ggplot2)

pacman::p_load(
  parsedate)        # data import/export

### Format date from "mmm, dd yyyy" to "dd-mm-yyyy"
col1_char <- pull(gold_data, Date)
col1_nocommas <- sub(",","", col1_char)
col1_date <- parse_date(col1_nocommas, "%b %d %Y", locale = locale("en"))
col1_date_formatted <- format(col1_date, "%d-%m-%Y")
gold_data[1] <- col1_date_formatted

### Convert price data from Format to Numeric
price <- gold_data$Close
price_num <- as.numeric(sub(",", "", price))

#### Filter out: date, end daily prices
gold_date <- data.frame(year = as.numeric(format(col1_date, format = "%Y")),
                month = as.numeric(format(col1_date, format = "%m")),
                day = as.numeric(format(col1_date, format = "%d")))
new_gold_data <- data.frame(date=col1_date, price=price_num)

#### Plotting
ggplot() + 
  geom_point(aes(y=new_gold_data$price, x=new_gold_data$date), color="orange", size=0.1, alpha=0.1, stat="identity") +
  geom_smooth(aes(y=new_gold_data$price, x=new_gold_data$date), color="orange", alpha=0.2, stat="identity") +
  scale_x_date(date_breaks = "6 months", date_labels = "%m-%Y") +
  labs(x="Date", y="Price (USD)", title="Price of Gold from 2018 to 2023")
