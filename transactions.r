library(tidyverse)
library(tidyr)
library(magrittr)
library(ggplot2)

#### Functions #####
filter_month <- function(month_number)
{
  df2 <- filter(df, month == month_number)
  return(df2)
}

#### Import data and tidy up#####
data <- read_csv("data.csv")
df <- select(data, "Transaction Date", "Debit Amount", "Credit Amount", "Transaction Description") %>%
  separate(. , "Transaction Date", c("day", "month", "year"), sep = "/") 
colnames(df) <- c("day", "month", "year", "out", "incoming", "desc")
df[is.na(df)] <- 0

# Expenditure in each month
df$month <- as.numeric(df$month)
ggplot(df) +
  geom_point(mapping = aes(x = day, y = out, color = month))

# Separate months into separate data frames 
months <- c("january", "february", "march", "april", "may", "june", "july", "august", 
            "september", "october", "november", "december")
months_number <- c("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12")

for(i in 1:6){
  assign(months[i], filter_month(months_number[i]) )
}

# Expenditure across months
by_month <- group_by(df, month) %>% 
  summarise( 
    total_out = sum(out),
    total_in = sum(incoming))


ggplot(data = by_month) +
  geom_bar(mapping = aes(x = month, y = total_out), stat = "identity") +
  ggtitle("Expenditure across months") +
  xlab("Months") +
  ylab("Expenses")

