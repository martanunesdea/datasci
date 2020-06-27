install.packages("ggplot2")
library(ggplot2)  # to plot
library(dplyr)    # to clean up
library(readr)    # to open csv
library(datasets)

#setwd() # set working directory 

data(airquality)

# data frame is a type of data structure
# lists are a different type of data structure
# vectors are a more basic type of data structure (chars or numeric)

ggplot(airquality) +
  geom_point(mapping = aes(x = Day, y = Temp)) +
  xlab("days in the month") +
  ylab("Temperature") +
  ggtitle("Temperature for 5 months")
 
# make month a discrete variable 
airquality$Month <- as.character(airquality$Month)

# use colour to classify data points from different months
ggplot(airquality) +
  geom_point(mapping = aes(x=Day, y=Temp, color=Month))

# visualise months in separate plots
ggplot(airquality) +
  geom_point(mapping = aes(x=Day, y=Temp)) +
  facet_wrap(~ Month, ncol = 2)

# can also use facet_grid for crossing different plots into 1 image
data(mpg)
ggplot(mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ cyl)

# depicting mean and spread of series 
ggplot(airquality, mapping = aes(x=Day, y=Temp)) +
  geom_smooth() + 
  geom_point()

# statistical graphing
data(diamonds)
ggplot(data = diamonds) +
  geom_bar(mapping= aes(x=cut))

ggplot(diamonds) +
  stat_summary(
    mapping = aes(x =cut, y=depth),
    fun.ymin = min,
    fun.ymax = max,
    fun.y = median
  )
# note: fun.ymin, fun.ymax, fun.y may be deprecated in newer versions of R

