library(tidyverse)
library(tidyr)
library(magrittr)
data <- read_csv("data.csv")

df <- select(data, "Transaction Date", "Debit Amount", "Credit Amount", "Transaction Description") %>%
  separate(. , "Transaction Date", c("day", "month", "year"), sep = "/") 
  
colnames(df) <- c("day", "month", "year", "out", "in", "desc")


df$month <- as.numeric(df$month)
diffmonths <- cut(df$month, c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12), drop = FALSE)


ind_months <- split(df, cut(df$month, c(2, 3, 4, 5, 6)), drop = FALSE )
march <- ind_months[[1]]
april <- ind_months[[2]]
