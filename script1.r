library(ggplot2)
library(dplyr)
library(readr)
# or just download: library(tidyverse) which include all of the above
library(datasets)
# setting our working directory
setwd("/Users/martanunesdeabreu/r_dataviz")
# load dataset to rstudio
my_data <- read_csv("set1.csv")

data(sleep)
data(discoveries)
data(airquality)

# blindly to plot everything 
ggplot(airquality) +
  geom_point(mapping = aes(x=Day, y=Temp)) + 
  xlab("Days in the month") + 
  ylab("Temperature in Fahrenheit") +
  ggtitle("Temperature in NY for 5 months")

# but we can´t distinguish between different months
airquality$Month <- as.character(airquality$Month)
# add different colors for each month
ggplot(airquality) +
  geom_point(mapping = aes(x=Day, y=Temp, color = Month)) + 
  xlab("Days in the month") + 
  ylab("Temperature in Fahrenheit") +
  ggtitle("Temperature in NY for 5 months")
# so august and july look like the higher months, we could calculate this...


# work out a way to gauge temperatures in one of the months 
avg_month7 <- mean(as.matrix(select(filter(airquality, Month == "7"), Temp)))
# ... we could turn this into a function if we think we´ll be doing this with all the months


get_month_temp_average <- function(x, magnitude){
  res <- mean(as.matrix(select(filter(airquality, Month == x), magnitude)))
}

avg_month5 <- get_month_temp_average("5", "Temp")
avg_month9 <- get_month_temp_average("9", "Temp")

# anyway, let´s visualise months differently..
ggplot(airquality) +
  geom_point(mapping = aes(x=Day, y=Temp)) + 
  facet_wrap(~ Month, nrow = 2)




