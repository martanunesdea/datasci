### Oil data ###
oil_data <- read.csv("BrentOilPrices.csv", stringsAsFactors=FALSE)

oil_data_cpy1 <- oil_data[0:8360, ]
oil_data_cpy1$Date <- parse_date(oil_data_cpy1$Date, format="%d-%b-%y", locale = locale("en"))

oil_data_cpy2 <- oil_data[8361:9011, ]
oil_data_cpy2$Date <- sub(",","", oil_data_cpy2$Date)
oil_data_cpy2$Date <- parse_date(oil_data_cpy2$Date, "%b %d %Y", locale = locale("en"))

oil_data <- as.data.frame(rbind(oil_data_cpy1, oil_data_cpy2))

ggplot() + 
  geom_point(aes(y=oil_data$Price, x=oil_data$Date), color="darkgrey", size=0.1, alpha=0.7) +
  geom_smooth(aes(y=oil_data$Price, x=oil_data$Date), color="darkgrey", alpha=0.2, stat="identity") +
  scale_x_date(date_breaks = "5 years", date_labels = "%Y") +
  labs(x="Date", y="Price (USD)", title="Price of Brent Crude Oil from 1987 to 2023")
