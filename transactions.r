library(tidyverse)
library(tidyr)
library(magrittr)
library(ggplot2)
#### Import data and tidy up#####
df <- read_csv("data.csv") %>%
  select(. , "Transaction Date", "Debit Amount", "Credit Amount", "Transaction Description") %>%
  separate(. , "Transaction Date", c("day", "month", "year"), sep = "/") %>%
  rename(out = "Debit Amount",
        incoming = "Credit Amount",
        description = "Transaction Description") %>%
  mutate(out = replace_na(out, 0),
         incoming = replace_na(incoming, 0)) %>%
  mutate(total = -out+incoming)


# Expenditure in each month
# df$month <- as.numeric(df$month)
invested <- filter(df, description=="AJ BELL" | description=="M NUNES DE ABREU") %>%
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
  geom_point(mapping = aes(x = month, y = total_out), color = "red") +
  geom_point(mapping = aes(x = month, y = invested), color = "blue") +
  ggtitle("Expenditure across months") +
  xlab("Months") +
  ylab("Expenses")
