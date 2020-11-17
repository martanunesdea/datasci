#### Coding Basics ###############################
## Arithmetics #### 
# (output displayed on console)
1 / 200 * 30
(59 + 73 + 2) / 3
# create new objects with format:
# object_name <- value
a <- sin(pi - 2)
x <- 3*4
( y <- sqrt(356))

double_x <- x*x

# logical comparisons and bools
my_Var1 <- sqrt(2) ^2 == 2
bool2 <- 1 / 40 * 49 < 100
bool3 <- near(sqrt(2) ^ 2, 2)

## logical operators ( | is OR, & is AND, ! is not)

## arithmetic operators
# +, -, *, /, ^ are vectorised
# ie. if using a shorter parameter, it will be extended to match
# useful in conjunction with aggregate functions
# x / sum(x) gives proportion
# y - mean(x) gives difference from the mean

## modular arithmetic 
# useful - breaks integer up into pieces 
# %/% integer division 
# %% remainder

## logs 
log2(4)  # a difference of 1 corresponds to doubling the original scale
log(4)
log10(4)

## offsets 
# lead() and lag() 
x <- 1:20
x_prime <- lag(x)
x_prime2 <- lead(x, 3)

## Cumulative and rolling aggregates ####
x_sum <- cumsum(x)
x_prod <- cumprod(x)
x_min <- cummin(x)
x_max <- cummax(x)
x_cum_mean <- cummean(x)
# RcppRoll package gives functions for rolling windows

## Ranking ####
y <- c(1, 2, 2, NA, 3, 4)
min_rank(y)
min_rank(desc(y))
row_number(y)
dense_rank(y)
percent_rank(y)
cume_dist(y)

## Measures of location ####
x <- rnorm(100, 0, 1)
mean(x)
median(x)
# of spread
sd(x)     # standard measure of spread
IQR(x)    # interquartile range
mad(x)    # median absolute deviation (for outliers)
# of rank
min(x)
quantile(x, 0.25) # generalisation of the median
max(x)
# of position
first(x)
last(x)
nth(x, 4)

## Function calls ####
# fun_name(arg_1, arg_2)
seq(1, 10)

## intercept - coding style #### 
# use of spaces
# naming conventions: camel case, underscores, prefixes

