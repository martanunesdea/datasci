library(tidyverse)
library(tidyr)
library(magrittr)
library(ggplot2)

#### Import data and tidy up#####
data <- read_csv("data.csv")
df <- select(data, "Transaction Date", "Debit Amount", "Credit Amount", "Transaction Description") %>%
  separate(. , "Transaction Date", c("day", "month", "year"), sep = "/") 
colnames(df) <- c("day", "month", "year", "out", "incoming", "desc")
df[is.na(df)] <- 0

# Expenditure in each month
df$month <- as.numeric(df$month)
ggplot(data = df) +
  geom_point(mapping = aes(x = day, y = out, color = month))


df <- mutate(df, 
             added_up = -out+incoming) 

invested <- filter(df, desc=="AJ BELL" | desc=="M NUNES DE ABREU") %>%
  group_by(month) %>%
  summarise(
    invested = sum(out)
  )

by_month <- group_by(df, month) %>% 
  summarise( 
    total_out = sum(added_up),
    total_in = sum(incoming)) %>%
  full_join(invested)
  
ggplot(data = by_month) +
  geom_line(mapping = aes(x = month, y = total_out), color = "red") +
  geom_line(mapping = aes(x = month, y = invested), color = "blue") +
  ggtitle("Expenditure across months") +
  xlab("Months") +
  ylab("Expenses")



