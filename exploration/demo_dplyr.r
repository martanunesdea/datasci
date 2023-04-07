# Title: Data Transformation with Dplyr
# Author: Marta

install.packages("https://cran.r-project.org/src/contrib/nycflights13_1.0.1.tar.gz", repos=NULL, method="libcurl")
library(nycflights13)
library(dplyr)
library(ggplot2)
flights

### Filter ##############
# Allows you to subset observations based on their values
# Arguments:
# first - name of data frame/tibble
# second and subsequent - expressions that filter the data frame
jan1 <- filter(flights, month == 1, day == 1)

# with logical operator - OR
autumn_flights <- filter(flights, month == 10 | month == 11 | month == 12)

# short-hand notation
autumn_flights <- filter(flights, month %in% c(10, 11, 12))

# with logical operator - AND
ontime_flights <- filter(flights, arr_delay <= 5 & dep_delay <= 5)

## NOTE: NA represents missing values ####
#  any operation done on NA will then result also in NA

houston_flights <- filter(flights, dest == "IAH" | dest == "HOU")
delta_flights <- filter(flights, carrier == "DL")
arrived_late_flights <- filter(flights, arr_delay > 120 & dep_delay < 1)
made_up_for_it_flights <- filter(flights, arr_delay < 30 & dep_delay >= 60)

# use between
early_morning_flights <- filter(flights, between(flights$dep_time, 500, 700))

## NOTE: use of pipe operator ####
#  breaks down commands 
evening_flights <- flights %>%
  filter(arr_time > 2300)

### Arrange #########################################
# Re-arranges a dataset by changing order of rows
# Arguments:
# first - data frame/tibble
# second and subsequent - columns to order by (subsequent break ties)
by_date <- arrange(flights, day, month, year)

# can also use a second column as a tie breaker with this format:
by_date <- arrange(flights, year, month, day, desc(dep_delay))

# organise by least delayed flights
sorted_by_least_delay <- arrange(flights, arr_delay)

### Select #############################################
# Selects sub-sets of the dataset from given column names
# Arguments:
# first - data frame/tibble
# second and subsequent - columns to select 

dates <- select(flights, year, month, day)
#short-hand notation
dates <- select(flights, year:day)

## Helper functions to use with select() #####
# starts_with("abc") - e.g. starts_with("dep")
# ends_with("abc") - e.g. ends_with("delay")
# contains("abc") - e.g. contains("time")
# matches("(.)\\1") - e.g. using regex
# num_range("x", 1:3) - e.g. matches x1, x2, x3

# the everything() function also serves as a helper
# move a few columns to the front and keep everything else to the right
new_flights <- flights %>%
  select(time_hour, air_time, everything())

# rename() is a variant of select
rename(flights, plane_number = tailnum)

select(flights, contains("TIME"))

# using any_of to concatenate the columns we want
vars <- any_of("year", "month", "day", "dep_delay", "arr_delay")
select(flights, vars)

### Mutate ############################################
# Adds new columns that are functions of existing columns
# These are placed at the end of the dataset
# Arguments:
# first - data set 
# second and subsequent - formula(s) to create new column

# make a narrower dataset to be able to see difference
flights_sml <- select(flights,
                      year:day,
                      ends_with("delay"),
                      distance,
                      air_time)
mutate(flights_sml,
       gain = dep_delay - arr_delay,
       speed = distance / air_time * 60)

# refer to columns that you've just created
mutate(flights_sml,
       gain = dep_delay - arr_delay,
       hours = air_time / 60,
       gain_per_hour = gain / hours )

# The transmute() function will keep the new variables only
new_metrics <- flights %>%
  transmute( gain = dep_delay - arr_delay,
             hours = air_time / 60 )

### Summarise & Group_by #########################################
# Collapses a the rows in the data frame
# More powerful when combined with the group_by() function
avg_delay <- summarise(flights, delay = mean(dep_delay, na.rm = TRUE))
# note: na.rm means ignore the NA when calculating
# all aggregating functions have it as a way to not duplicate NAs all over

## Group by ###
# Changes the unit of analysis from the complete dataset to individual groups
# Arguments:
# first            - data set
# second and later - columns to group by
by_dates <- group_by(flights, year, month, day)
# returns avg delay in group
delayed_by_dates <- summarise(by_dates, avg_delay=mean(dep_delay, na.rm = TRUE))
#  returns the size of the current group
flights_by_dates <- summarise(by_dates, count=n())  


## The pipeline operator #######
# Say we want to analyse how the delay varies across distance travelled

# First: Group flights by destination.
by_dest <- group_by(flights, dest)
# Second: Summarise to compute distance, average delay, and number of flights.
delay <- summarise(by_dest,
                   count = n(),
                   dist = mean(distance, na.rm = TRUE),
                   delay = mean(arr_delay, na.rm = TRUE)
)

# Third: Use geom_smooth with method 'loess' and formula 'y ~ x'
ggplot(data = delay, mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = FALSE)

# OK - but this could be much simpler with the pipeline operator (%>%)
# which funnels the output of one line to the input of the next line
by_destination <- flights %>% 
  group_by(dest) %>% 
  summarise(
    count = n(),
    dist = mean(distance, na.rm = TRUE),
    delay = mean(arr_delay, na.rm = TRUE)
  ) %>% 
  filter(count > 20, dest != "HNL")

# Now produce graph
ggplot(data = delay, mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = FALSE)


## NA and na.rm #########
# NA stands for 'Not available' it represents missing values
# If the input to an operation is NA, the output becomes NA
# For this reason, we set "na.rm" to TRUE to remove the NA in our calculations
# Example of not adding na.rm:
wrong_summary <- flights %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay))

# Since NA represent cancelled flights, we can first remove these flights 
not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))
# now we don't need to set na.rm because there aren't any missing values
not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay)) 

## Counts #############
# When doing aggregation, include a n() or a sum(!is.na(x))
# To check the results obtained are not based on small amounts of data
delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay)
  )
# This graph makes it look like that there are flights with 300 minutes of delay
ggplot(data = delays, mapping = aes(x = delay)) + 
  geom_freqpoly(binwidth = 10)

delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay, na.rm = TRUE),
    n = n()
  )
# get more detail drawing a scatterplot of number of flights vs. average delay
# actually most of the planes are less than 1h30m delay ;
# the variation decreases as the sample size increases
ggplot(data = delays, mapping = aes(x = n, y = delay)) + 
  geom_point(alpha = 1/10)

# filter out groups (flight plane number) with less than 25 flights
# see more of the pattern, less of the extreme variation in the smallest groups
delays %>% 
  filter(n > 25) %>% 
  ggplot(mapping = aes(x = n, y = delay)) + 
  geom_point(alpha = 1/10)

## Summary helper functions #####
# measures of location, spread, rank, position
# Average ###
not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(
    avg_delay1 = mean(arr_delay),
    avg_delay2 = mean(arr_delay[arr_delay > 0]) # the average positive delay
  )
# Spread ###
# sd(x) standard dev 
# IQR(x) interquartile range
# mad(x) median absolute deviation 
not_cancelled %>% 
  group_by(dest) %>% 
  summarise(distance_sd = sd(distance)) %>% 
  arrange(desc(distance_sd))

# Measures of rank ###
# min(x), max(x) - minimum and maximum
# quantile(x, 0.25) - value that is greater than 25% of the rest 
first_and_last_flights <- not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(
    first = min(dep_time),
    last = max(dep_time)
  )

# Counts ###
# n_distinct counts the number of distinct values
not_cancelled %>% 
  group_by(dest) %>% 
  summarise(carriers = n_distinct(carrier)) %>% 
  arrange(desc(carriers))

sum(!is.na(flights$dep_delay)) # counts number of non missing values in dep_delay

# easy count short-hand notation
not_cancelled %>% 
  count(dest)

# and proportions of logical values: 
# e.g. sum(x > 10) number of TRUEs
# mean( y == 0 ) gives the proportion
not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(n_early = sum(dep_time < 500))


## Grouping and ungrouping ####
# When you group by multiple variables, each summary peels off one level of the grouping. That makes it easy to progressively roll up a dataset:
daily <- group_by(flights, year, month, day)
(per_day   <- summarise(daily, flights = n()))
(per_month <- summarise(per_day, flights = sum(flights)))
(per_year  <- summarise(per_month, flights = sum(flights)))
# need to be careful when doing this;
# works well for sums and counts, but not for rank-based statistics: 
# the sum of groupwise sums is the overall sum, but the median of groupwise medians is not the overall median.

# how to ungroup ?
daily %>% 
  ungroup() 


## grouped mutates and filters #####
# Find the worst members of each group:
flights_sml <- flights %>% 
  group_by(year, month, day) %>%
  filter(rank(desc(arr_delay)) < 10)

# Find all groups bigger than a threshold:
popular_dests <- flights %>% 
group_by(dest) %>% 
  filter(n() > 365)

# standardise to compute per group metrics
popular_dests <- flights %>% 
  filter(arr_delay > 0) %>% 
  mutate(prop_delay = arr_delay / sum(arr_delay)) %>% 
  select(year:day, dest, arr_delay, prop_delay) 
