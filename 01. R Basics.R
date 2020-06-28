# An addition
a <- 10 + 5 

# A subtraction
b <- 4 - 5 

# A multiplication

multi = a*b

# A division
divi = (a + b) / 2 

# Exponentiation

Expo <- divi^2

# Modulo

8%%6

# Functions
sum(a, b)

my_charac <- "Couch"

my_logic <- FALSE 


# Check classes
class(multi)
class(my_charac)
class(my_logic)

# Vectors are one-dimension arrays that can hold numeric data, character data, or logical data
# you create a vector with the combine function c(), contains one type of data at a time.

numeric_vector <- c(1, 8, 21, 26, 10, 49)
character_vector <- c("Arab", "Dhaka",  "Chimni", "Fakhirhat")
boolean_vector <-c(TRUE,FALSE,TRUE, TRUE, FALSE)

# lottery winnings from Monday to Friday
lottery_vector <- c(160, -60, 50, -190, 120, 49)

# Bonus from Monday to Friday
bonus_vector <- c(-123, -40, 410, -270, 30, 56)

# Assign days as names of poker_vector
names(lottery_vector) <- c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday")

# or creating days_vector
days_vector <- c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday")

# Assign days_vactor as names of roulette_vectors
names(bonus_vector) <- days_vector

# Sum of vectors
(lottery_vector + bonus_vector)
sum(lottery_vector) # will give you total winning in a week

# Select lottery results for Tuesday, Wednesday and Saturday (using c to select multiple names or headings)
lottery_partial <- lottery_vector[c("Tuesday","Wednesday","Saturday")]

# Calculate the average of the elements in lottery_partial
mean(lottery_partial)

lottery_partial

# Which days did you win money on lottery?
lottery_selection <- lottery_vector > 0

lottery_selection 

# This will give you the amount you won 
Winning_days <- lottery_vector[lottery_selection]
Winning_days


# matrix is called two-dimensional, using matrix(data = NA, nrow = 1, ncol = 1, byrow = FALSE, dimnames = NULL).
help(matrix) # to learn more about a topic

matrix(1:9,nrow=3, byrow=F) # False or F (default value here), True or T

mix <- c(lottery_vector, bonus_vector)
matrix_construct <- matrix(mix, nrow = 2, byrow = T) # matrix only contains one type of data

# Name the columns with region
colnames(matrix_construct)<- days_vector

# Name the rows with titles
rownames(matrix_construct)<- c("Lottery", "Bonus")

# Besides rownames & colnames, use dimnames = list(c("AB", "CK", "RJ"), c("US", "non-US"))

matrix_construct # printing to see

# coloumn and row bind functions

Sunday <- rowSums(matrix_construct) # creating a new vector to add in column in next statement

all <- cbind(matrix_construct, Sunday)

copy_all <- all

rowbind <- rbind(all, copy_all)

# index or position selection from the database

all[1,2]  # selects the element at the first row and second column.
rowbind[1:3,2:4] # results in a matrix with the data on the rows 1, 2, 3 and columns 2, 3, 4.

rowbind[,1] # selects all elements of the first column.
rowbind[1,] # selects all elements of the first row.

# matrix calculation
# 2 * my_matrix multiplied every element of my_matrix by two, and 
# my_matrix1 * my_matrix2 creates a matrix where each element is the product of the corresponding elements

# Creating categorical variables with factor()

sex_vector <- c("Male", "Female", "Female", "Male", "Female", "Male", "Male")

# Convert sex_vector to a factor
factor_sex_vector <- factor(sex_vector)

# Print out factor_sex_vector
factor_sex_vector

# Two types of categorical (nominal-no implied order, ordinal-natural order)
nominal_vector <- c("Elephant", "Tiger", "Giraffe", "Deer", "Donkey", "Crocodile", "Horse")
factor_nominal_vector <- factor(nominal_vector)
factor_nominal_vector

# Ordering and show how to order through level option
ordinal_vector <- c("High", "Low", "High","Low", "Medium")
factor_ordinal_vector <- factor(ordinal_vector, order = TRUE, levels = c("Low", "Medium", "High"))
factor_ordinal_vector

# Data Frame: built-in example data frame- mtcars
# head() shows the first observations of a data frame. tail() prints out the last observations.
head(mtcars)
tail(mtcars)

# function str() shows you the structure of your data set.
str(mtcars)

# Definition of vectors
name <- c("Mercury", "Venus", "Earth", "Mars", "Jupiter", "Saturn", "Uranus", "Neptune")
type <- c("Terrestrial planet", "Terrestrial planet", "Terrestrial planet", 
          "Terrestrial planet", "Gas giant", "Gas giant", "Gas giant", "Gas giant")
diameter <- c(0.382, 0.949, 1, 0.532, 11.209, 9.449, 4.007, 3.883)
rotation <- c(58.64, -243.02, 1, 1.03, 0.41, 0.43, -0.72, 0.67)
rings <- c(FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, TRUE, TRUE)

# Create a data frame from the vectors (data frames can contain all types of data)
planets_df <- data.frame(name,type,diameter,rotation,rings)

# Selection or subsetting
planets_df[,3]
planets_df[,"diameter"]
#short-cut. If your columns have names, you can use the $ sign:
planets_df$diameter
subset(planets_df, subset = rings) # or using diameter to achieve similar subsetting like above

# Use order() to create positions
positions <- order(planets_df$diameter)

# Use positions to sort planets_df
planets_df[positions,]


# Creating list with list(), can contain vector, matrix, data frame all together

# Vector with numerics from 1 up to 10
my_vector <- 1:10 

# Matrix with numerics from 1 up to 9
my_matrix <- matrix(1:9, ncol = 3)

# First 10 elements of the built-in data frame mtcars
my_df <- mtcars[1:10,]

# Adapt list() call to give the components names
my_list <- list(my_vector, my_matrix, my_df)
my_list<- list(vec=my_vector, my_matrix=mat, my_df=df) 
names(my_list)<- c("vec", "mat", "df")
# Print out my_list
my_list

# Selecting something from lists
my_list[["df"]][[3,2]]
my_list$df[[3,2]]
