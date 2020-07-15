# You only need to install a package once

install.packages("tidyverse", dependencies = T)

# You need to reload it every time you start a new session
library(tidyverse)

# Loading a built in data frame 
ggplot2::mpg


# Plotting displ on the x-axis and hwy on the y-axis
ggplot(ddata = mpg) +
  geom_point(mapping = aes(x=mpg$displ, y =mpg$hwy))

## Visualising distributions

# A variable is categorical if it can only take one of a small set of values
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut))

# A variable is continuous if it can take any of an infinite set of ordered values
ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = carat), binwidth = 0.5) # You can compute this by hand by combining dplyr::count() and ggplot2::cut_width()

# You can set the width of the intervals in a histogram with the binwidth argument
smaller <- diamonds %>% 
  filter(carat < 3)

ggplot(data = smaller, mapping = aes(x = carat)) +
  geom_histogram(binwidth = 0.1)

# geom_freqpoly() performs the same calculation as geom_histogram(), but instead of displaying the counts with bars, uses lines instead
ggplot(data = smaller, mapping = aes(x = carat, colour = cut)) +
  geom_freqpoly(binwidth = 0.1)

# The histogram below shows the length (in minutes) of 272 eruptions of the Old Faithful Geyser in Yellowstone National Park. 
# Eruption times appear to be clustered into two groups: there are short eruptions (of around 2 minutes) and long eruptions (4-5 minutes), but little in between.
ggplot(data = faithful, mapping = aes(x = eruptions)) + 
  geom_histogram(binwidth = 0.25)

# A box that stretches from the 25th percentile of the distribution to the 75th percentile, a distance known as the interquartile range (IQR). 
# In the middle of the box is a line that displays the median, i.e. 50th percentile, of the distribution.

ggplot(data = diamonds, mapping = aes(x = cut, y = price)) +
  geom_boxplot()

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + # checking cars variation with its mileage
  geom_boxplot()

# To make the trend easier to see, we can reorder class based on the median value of hwy
ggplot(data = mpg) +
  geom_boxplot(mapping = aes(x = reorder(class, hwy, FUN = median), y = hwy))

# If you have long variable names, geom_boxplot() will work better if you flip it 90°. You can do that with coord_flip()
ggplot(data = mpg) +
  geom_boxplot(mapping = aes(x = reorder(class, hwy, FUN = median), y = hwy)) +
  coord_flip()

# To visualise the covariation between categorical variables, you'll need to count the number of observations for each combination
ggplot(data = diamonds) +
  geom_count(mapping = aes(x = cut, y = color))

# alpha aesthetic to add transparency
ggplot(data = diamonds) + 
  geom_point(mapping = aes(x = carat, y = price), alpha = 1 / 100)

## Patterns and models

ggplot(data = faithful) + 
  geom_point(mapping = aes(x = eruptions, y = waiting))


# residuals give us a view of the price of the diamond, once the effect of carat has been removed
library(modelr)

mod <- lm(log(price) ~ log(carat), data = diamonds)

diamonds2 <- diamonds %>% 
  add_residuals(mod) %>% 
  mutate(resid = exp(resid))

ggplot(data = diamonds2) + 
  geom_point(mapping = aes(x = carat, y = resid))

# Once you've removed the strong relationship between carat and price, you can see what you expect in the relationship between cut and price: relative to their size, better quality diamonds are more expensive.
ggplot(data = diamonds2) + 
  geom_boxplot(mapping = aes(x = cut, y = resid))
