##### DPLYR DEMO ##############################################################
install.packages("nycflights13")
library(nycflights13)
# group_by()
# filter() 
# arrange() - lets you reorder rows
# select() - lets you pick variables by their names
# mutate() - creates variables with functions of variables
# summarise() - collapse several values into a single summary

## using filter() ####
my_flights <- flights
filter(flights)
jan1 <- filter(flights, flights$month == 1)
summer <- filter(flights, month > 5 & month < 10)

# explicit variables if using very long expressions inside functions

# missing values in datasets: NA
# or if casting datatypes you may get NA 
# eg operating on a row of characters or something
# is.na() is TRUE if element is NA
# many functions have na-related arguments like exclude NA or make NA if not possible..

## using arrange() ####
# re-orders a dataset
# NA elements get sorted in the end
new_order <- arrange(flights, year, dep_time)

## using select() ####
delays <- select(flights, carrier, dep_delay, arr_delay)
# other uses:
select(flights, year:day)
select(flights, -(year:day))
# helper functions for select() can manipulate columns quickly
# move a few columns to the front and keep the rest with everything
select(flights, time_hour, air_time, everything())
delays2 <- select(flights, carrier, contains("delay"))
# also exist: starts_with, ends_with, matches, num_range

## using mutate() ####
# adds new columns at the end of the dataset
flights2 <- select(flights,
                   year:day,
                   ends_with("delay"),
                   distance,
                   air_time)

flights2 <- mutate(flights2, 
                   gain = dep_delay - arr_delay,
                   speed = distance / air_time * 60,
                   hours = air_time * 60,
                   gain_per_hour = gain / hours )

# to keep the new variables created only, transmute()
flights2_processed <- transmute(flights,
                                gain = dep_delay - arr_delay,
                                hours = air_time / 60,
                                gain_per_hour = gain / hours)

# can use modular arithmetic here:
flights3_processed <- transmute(flights,
                                dep_time,
                                hour = dep_time %/% 100,
                                minute = dep_time %% 100
) 

## using summarise() ####
avg_delay <- summarise(flights, delay = mean(dep_delay, na.rm = TRUE))
# note: na.rm means ignore the NA when calculating
# all aggregating functions have it as a way to not duplicate NAs all over
# more useful when combined with group_by: get a new structure summarising info.
by_day <- group_by(flights, year, month, day)
delay <- summarise(by_day, delay = mean(dep_delay, na.rm = TRUE))



## intercept - the pipeline operator #######
delays <- flights %>% 
  group_by(dest) %>% 
  summarise(
    count = n(),
    dist = mean(distance, na.rm = TRUE),
    delay = mean(arr_delay, na.rm = TRUE)
  ) %>% 
  filter(count > 20, dest != "HNL")

not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay))

# count with summarise
# include a n( ) or a sum(!is.na(x))
# check not getting results based on small amounts of data
delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay)
  )

ggplot(data = delays, mapping = aes(x = delay)) + 
  geom_freqpoly(binwidth = 10)
# some delays for more than 2 hours..

delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay, na.rm = TRUE),
    n = n()
  )

ggplot(data = delays, mapping = aes(x = delay, y = n)) + 
  geom_point(alpha = 1/10)
# actually most of the planes are less than 1h30m delay

delays %>% 
  filter(n > 25) %>% 
  ggplot(mapping = aes(x = n, y = delay)) + 
  geom_point(alpha = 1/10)

# helper summary functions: 
# measures of location, spread, rank, position
# mean example
not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(
    avg_delay1 = mean(arr_delay),
    avg_delay2 = mean(arr_delay[arr_delay > 0]) # the average positive delay
  )

# spread
not_cancelled %>% 
  group_by(dest) %>% 
  summarise(distance_sd = sd(distance)) %>% 
  arrange(desc(distance_sd))

# counts!! 
sum(!is.na(flights$dep_delay)) # counts number of non missing values
n_distinct(x)                  # counts number of distinct values
# function count() also exists
# provides a weighting factor

# and proportions of logical values:
# e.g. sum(x > 10) number of TRUEs
# mean( y == 0 ) gives the proportion
not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(n_early = sum(dep_time < 500))


## grouping and ungrouping ####
daily <- group_by(flights, year, month, day)
(per_day   <- summarise(daily, flights = n()))
(per_month <- summarise(per_day, flights = sum(flights)))
(per_year  <- summarise(per_month, flights = sum(flights)))
# works only for sums and counts, not rank-based statistics 
daily %>% 
  ungroup() %>%             # no longer grouped by date
  summarise(flights = n())  # all flights


## grouped mutates and filters #####
# standardise to compute per group metrics
popular_dests %>% 
  filter(arr_delay > 0) %>% 
  mutate(prop_delay = arr_delay / sum(arr_delay)) %>% 
  select(year:day, dest, arr_delay, prop_delay) 