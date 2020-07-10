## Using data from the nycflights13 package
install.packages("nycflights13")
library(nycflights13)
library(tidyverse)

nycflights13::flights

## dplyr functions that allow you to solve the vast majority of your data manipulation challenges:

# Pick observations by their values (filter()).
Feb1 <- filter(flights, month == 2, day == 1)

# R either prints out the results, or saves them to a variable. If you want to do both, you can wrap the assignment in parentheses:
(Feb1 <- filter(flights, month == 2, day == 1))

# R provides the standard suite: >, >=, <, <=, != (not equal), and == (equal)

# x %in% y. This will select every row where x is one of the values in y

oct_dec <- filter(flights, month %in% c(10,12))

# find flights that weren't delayed (on arrival or departure) by more than two hours, you could use either of the following two filters:
filter(flights, !(arr_delay > 120 | dep_delay > 120))
filter(flights, arr_delay <= 120, dep_delay <= 120)
between_jan_to_march <- filter(flights, between(flights$month, 1, 3))

# determine if a value is missing, use is.na() and to count them use Sum
sum(is.na(flights$dep_time))


# Avoid NA in calculation otherwise the result will always be NA if any missing value in the data set
sum(flights$dep_time, na.rm = T)

# Computers obviously can't store an infinite number of digits! every number you see is an approximation. Instead of relying on ==, use near():
sqrt(2)^3 == 2 # instead use the following

near(sqrt(2)^3, 2)



## Reorder the rows with arrange(), works similarly to filter() except that instead of selecting rows, it changes their order.

arrange(flights, year, dep_time, dep_delay) # by default arranges with ascending order with multiple columns

arrange(flights, year, desc(month), desc(day)) # to order in descending order by each column


## Pick variables by their names (select()).

# select() allows you to rapidly zoom in on a useful subset using operations based on the names of the variables.

select(flights, year, day, dep_time)

# Select all columns between year and day (inclusive)
select(flights, year:day)

# Select all columns except those from year to day (inclusive)
select(flights, -(year:day))

# There are a number of helper functions you can use within select():

# starts_with("abc"): matches names that begin with "abc".
select(flights, starts_with("dep"))


# ends_with("xyz"): matches names that end with "xyz".
select(flights, ends_with("time"))

# contains("ijk"): matches names that contain "ijk".
select(flights, contains("time"))


# matches("(.)\\1"): selects variables that match a regular expression. This one matches any variables that contain repeated characters. You'll learn more about regular expressions in strings.
select(flights, matches("."))

# num_range("x", 1:3): matches x1, x2 and x3
select(flights, num_range("Type", 1:2))

rename(flights, tail_num = tailnum) # renaming a variable by keeping others intact

# if you have a handful of variables you'd like to move to the start of the data frame.
select(flights, day, month, year, everything())


## Create new variables with functions of existing variables (mutate()).

# mutate() always adds new columns at the end of your data set 
flights_sml <- select(flights, 
                      year:day, 
                      ends_with("delay"), 
                      distance, 
                      air_time
)
flights_sml_calculation <- mutate(flights_sml,
       gain = dep_delay - arr_delay,
       speed = distance / air_time * 60,
       hours = air_time / 60,
       gain_per_hour = gain / hours # you can refer to columns that you've just created
)


# If you only want to keep the new variables, use transmute()

transmute(flights,
          gain = dep_delay - arr_delay,
          hours = air_time / 60,
          gain_per_hour = gain / hours
)

# Modular arithmetic: %/% (integer division) and %% (remainder)
transmute(flights,
          dep_time,
          hour = dep_time %/% 100,
          minute = dep_time %% 100
)


# lead() and lag() allow you to refer to leading or lagging values.
x <- 1:15

lead(x)
lag(x)


# cumsum(), cumprod(), cummin(), cummax(); and dplyr provides cummean() for cumulative means

cumsum(x)
cummean(x)


# If you need rolling aggregates (i.e. a sum computed over a rolling window), try the RcppRoll package.

install.packages("RcppRoll")

library(RcppRoll)


roll_mean(x, n = 3)



# If min_rank() doesn't do what you need, look at the variants row_number(), dense_rank(), percent_rank(), cume_dist(), ntile()

min_rank(x) # default ascending
min_rank(desc(x)) # descending


## Collapse many values down to a single summary (summarize())

# summarise() is not terribly useful unless we pair it with group_by()

by_day <- group_by(flights, year, month, day)
summarise(by_day, delay = mean(dep_delay, na.rm = TRUE)) # na.rm will ignore NA

by_dest <- group_by(flights, dest)
delay <- summarise(by_dest,
                   count = n(),
                   dist = mean(distance, na.rm = TRUE),
                   delay = mean(arr_delay, na.rm = TRUE)
)
delay <- filter(delay, count > 20, dest != "HNL")

delay

# There's another way to tackle the same problem with the pipe, %>%
# Behind the scenes, x %>% f(y) turns into f(x, y), and x %>% f(y) %>% g(z) turns into g(f(x, y), z) and so on. 

delays <- flights %>%  # that sign means precedent stuff in second one
  group_by(dest) %>% 
  summarise(
    count = n(),
    dist = mean(distance, na.rm = TRUE),
    delay = mean(arr_delay, na.rm = TRUE)
  ) %>% 
  filter(count > 20, dest != "HNL")

# Another way to calculate without being affected by NA
not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay)) # filtering out NA

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay))

# Note:  it's always a good idea to include either a count (n()), or a count of non-missing values (sum(!is.na(x)))


install.packages("Lahman")
library("Lahman")

batting <- as_tibble(Lahman::Batting) # converting to tibble

batters <- batting %>%
  group_by(playerID) %>%
  summarise(
    ba = sum(H, na.rm = T) / sum(AB, na.rm = T),
    ab = sum(AB, na.rm = T)
  )


batters %>%
  filter(ab > 100) %>%
  ggplot(mapping = aes(x = ab, y = ba)) +
  geom_point() +
  geom_smooth(se = F)
  

## aggregation with logical subsetting

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(
    avg_delay1 = mean(arr_delay),
    avg_delay2 = mean(arr_delay[arr_delay > 0]) # the average positive delay
  )


## Measures of rank: min(x), quantile(x, 0.25), max(x). 

# Quantiles are a generalisation of the median. quantile(x, 0.25) will find a value of x that is greater than 25% of the values, and less than the remaining 75%

# Measures of position: first(x), nth(x, 2), last(x). These work similarly to x[1], x[2], and x[length(x)]

# To count size of the group n() or sum(is.na(x)) 

# To count non-missing values sum(!is.na(x))

# To count distinct(unique) values, use n_distinct


## Grouping is most useful in conjunction with summarise(), but you can also do convenient operations with mutate() and filter()

flights_sml %>% 
  group_by(year, month, day) %>%
  filter(rank(desc(arr_delay)) < 10)


popular_dests %>% 
  filter(arr_delay > 0) %>% 
  mutate(prop_delay = arr_delay / sum(arr_delay)) %>% 
  select(year:day, dest, arr_delay, prop_delay)

