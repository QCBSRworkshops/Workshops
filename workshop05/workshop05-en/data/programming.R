### QCBS Workshops ###
### Programming in R ###

#  Developed by Johanna Bradie, Sylvain Christin, Ben Haller and Guillaume Larocque

### Housekeeping ###

rm(list=ls())
setwd("C:/Users/Johanna/Documents/PhD/R_Workshops")  # Insert your path here.

##############################
##     Flow Control         ##
##############################

##
## if and if/else statements
##

# Simple example of "if"

if (2 + 2 == 4) {
  print("Arithmetic works.") }

if (2 + 1 == 4) {
  print("Arithmetic works.") }

# The importance of curly brackets:  an example of how *not* to do if-else

if (2 + 1 == 4) print("Arithmetic works.")
else print("Houston, we have a problem.")

# By using curly brackets, the expression is evaluated with the else statement.

if (2 + 2 == 4) {
  print("Arithmetic works.")
} else {
  print("Houston, we have a problem.")
}

# Note that if and if/else test a single condition.  If you want to test a vector of conditions (and get a vector of results), you can use ifelse:

a<-1:10
ifelse(a>5,"yes","no")


# You can also use ifelse within a function to apply a function only under certain conditions: 

a<-(-4):5
sqrt(ifelse(a>=0,a,NA))

## Exercise 1 ##

Paws<-"cat"
Scruffy<-"dog"
Sassy<-"cat"
animals<-c(Paws,Scruffy,Sassy)

# 1. Use an if statement to write "meow" if Paws is a "cat".

# 2. Use an if/else statement to write "woof" if you supply an object that is a "dog" and "meow" if it is not.  Try it out with Paws and Scruffy.

# 3. Use an ifelse statement to display "woof" for animals that are dogs and "meow" for animals that are cats.

## Exercise answers are at bottom of script ##


##
## for loops
##

## Examples of for loops ##

for (i in 1:5) {
  print(i) }

##In the above example, R evaluates the expression 5 times.  In the first iteration, R replace each instance of i with 1.  In the second iteration i is replaced with 2, and so on.  

##  You can start and end at any number in your loop and your variable does not need to be called i

for (m in 4:10) {
  print(m*2) 
}

## You can also loop through vectors of text:
for (a in c("Hello","R","Programmers")) {
  print(a) 
}

## In this example, you will have R draw a value from the normal distribution in each iteration and then assign that value to a, and print this value.
for (z in 1:30) {
  a<-rnorm(n=1,mean=5,sd=2) # draw a value from a normal distribution with mean 5 and sd 2
  print(a)
}

## Loops are often used to loop over data in a dataset.  We will import CO2 data and then use it in a loop.

data(CO2) # This loads the built in dataset that we used previously in workshop 2.

# The dataset contains concentration and uptake values for plants in Quebec and Mississippithat received a treatment ("chilled" or "nonchilled").

for (i in 1:length(CO2[,1])) { # for each row in the CO2 dataset
  print(CO2$conc[i]) #print the CO2 concentration
}

for (i in 1:length(CO2[,1])) { # for each row in the CO2 dataset
  if(CO2$Type[i]=="Quebec") { # if the type is "Quebec"
    print(CO2$conc[i]) #print the CO2 concentration }
  }
}

# Tip 1 : to get the number of rows of a data frame, we can also use the function nrow
for (i in 1:nrow(CO2)) { # for each row in the CO2 dataset
  print(CO2$conc[i]) #print the CO2 concentration
}

# Tip 2 : If we want to perform operations on only the elements of one column, we can directly
# iterate over it.
for (i in CO2$conc) { # for every element of the concentration column of the CO2 dataset
  print(i) # print the ith element
}


## The expression part of the loop can be almost anything and is usually a compound statement containing many commands.

for (i in 4:5) { # for i in 4 to 5
  print(colnames(CO2[i]))  
  print(mean(CO2[,i])) #print the mean of that column from the CO2 dataset
}
### Note that this could be done more quickly using apply(), but that wouldn't teach you about loops.

### Nested loops ###
  
# In some cases, you may want to use nested loops to accomplish a task.

for (i in 1:5) {
  for (n in 1:5) {
    print (i*n)
  }
}

# When using nested loops, it is important to use different variables as counters for each of your loops (here we used i and n).  

## Exercise 2 ## - Loops

# 1. You have realized that your tool for measuring uptake was not calibrated properly at Quebec sites and all measurements are 2 units higher than they should be.  Use a loop to correct these measurements for all Quebec sites.

## Exercise answers are at bottom of script ##

# Make sure you reload the data so that we are working with the raw data for the rest of the exercise: 

data(CO2)


##############################
##    Loop Modifications    ##
##############################

count=0
for (i in 1:length(CO2[,1])) {
  if (CO2$Treatment[i]=="nonchilled") next #Skip to next iteration if treatment is nonchilled
  count=count+1
  print(CO2$conc[i])
}
print(count) # The count and print command were performed 42 times.

### This could be equivalently written using a repeat loop: 

count=0
i=0
repeat {
  i <- i + 1
  if (CO2$Treatment[i]=="nonchilled") next  # skip this loop
  count=count+1
  print(CO2$conc[i])
  if (i == length(CO2[,1])) break     # stop looping
}  

### This could also be written using a while loop: 

i <- 0
count=0
while (i < length(CO2[,1]))
{
  i <- i + 1
  if (CO2$Treatment[i]=="nonchilled") next  # skip this loop
  count=count+1
  print(CO2$conc[i])
}

## Exercise 3 ## - Loop modifications


# 1. You have realized that your tool for measuring concentration didn't work properly.  At Mississippi sites, concentrations less than 300 were measured correctly but concentrations>=300 were overestimated by 20 units.  Use a loop to correct these measurements for all Mississippi sites.

## Answers are at the bottom of script ##

# Make sure you reload the data so that we are working with the raw data for the rest of the exercise: 

data(CO2)

#### Using flow control to make a complex plot ### 

# The idea here is that we have a dataset we want to plot, with conc and uptake values, 
# but each point has a type (Quebec or Mississippi) and a treatment ("chilled" or
# "nonchilled" and we want to plot the points differently for these cases.  
# You can read more about mathematical typesetting with ?plotmath, 
# and more about the way # that different colors, sizes, rotations, 
# etc. are used in ?par.

head(CO2)
unique(CO2$Type)
unique(CO2$Treatment)

# plot the dataset, showing each type differently

plot(x=CO2$conc, y=CO2$uptake, type="n", cex.lab=1.4,xlab="CO2 concentration", ylab="CO2 uptake") # Type "n" tells R to not actually plot the points.

for (i in 1:length(CO2[,1]))
{
  if (CO2$Type[i]=="Quebec"&CO2$Treatment[i]=="nonchilled") {
    points(CO2$conc[i],CO2$uptake[i],col="red",type="p") }
  if (CO2$Type[i]=="Quebec"&CO2$Treatment[i]=="chilled") {
    points(CO2$conc[i],CO2$uptake[i],col="blue") }
  if (CO2$Type[i]=="Mississippi"&CO2$Treatment[i]=="nonchilled") {
    points(CO2$conc[i],CO2$uptake[i],col="orange") }
  if (CO2$Type[i]=="Mississippi"&CO2$Treatment[i]=="chilled") {
    points(CO2$conc[i],CO2$uptake[i],col="green") }
}

## Exercise 4 ## - Generate a plot using if statements

# 1. Generate a plot of showing concentration versus uptake where each plant is shown using a different colour point.  Bonus points for doing it with nested loops!

## Answers are at the bottom of script ##







#### EXERCISE ANSWERS #### 

## Exercise 1- if, if/else, and ifelse ##

Paws<-"cat"
Scruffy<-"dog"
Sassy<-"cat"
animals<-c(Paws,Scruffy,Sassy)

# 1. Use an if statement to write "meow" if Paws is a "cat".

if(Paws=="cat") {
  print("meow")}

# 2. Use an if/else statement to write "woof" if you supply an object that is a "dog" and "meow" if it is not.  Try it out with Paws and Scruffy.

if(Scruffy=="dog") {
  print("woof") 
} else {
  print ("meow")
}

# 3. Use an ifelse statement to display "woof" for animals that are dogs and "meow" for animals that are cats.

ifelse(animals=="dog","woof","meow")

## Exercise 2 ## - Loops

# 1. You have realized that your tool for measuring uptake was not calibrated properly at Quebec sites and all measurements are 2 units higher than they should be.  Use a loop to correct these measurements for all Quebec sites.

for (i in 1:length(CO2[,1])) {
  if(CO2$Type[i]=="Quebec") {
    CO2$uptake[i]=CO2$uptake[i]-2}
}

## Exercise 3 ## - Loop modifications

# 1. You have realized that your tool for measuring concentration didn't work properly.  At Mississippi sites, concentrations less than 300 were measured correctly but concentrations>=300 were overestimated by 20 units.  Use a loop to correct these measurements for all Mississippi sites.

for (i in 1:length(CO2[,1])) {
  if(CO2$Type[i]=="Mississippi") {
    if(CO2$conc[i]<300) next 
    CO2$conc[i]=CO2$conc[i]-20 }
}

## Exercise 4 ## - Generate a plot using if statements

# 1. Generate a plot of showing concentration versus uptake where each plant is shown using a different colour point.  Bonus points for doing it with nested loops!

plot(x=CO2$conc, y=CO2$uptake, type="n", cex.lab=1.4,xlab="CO2 concentration", ylab="CO2 uptake") # Type "n" tells R to not actually plot the points.

plants<-unique(CO2$Plant)

for (i in 1:length(CO2[,1])) 
{
  for (p in 1:length(plants)) { 
    if (CO2$Plant[i]==plants[p]) {
      points(CO2$conc[i],CO2$uptake[i],col=p,type="p") }
  }
}


##############################
##  How to write functions  ##
##############################

##
## Simple function
##
print_number <- function(number) {
  print(number)
}
print_number(2)
print_number(231)


## 
## Multiple arguments
##
operations <- function(number1, number2, number3) {
  result <- (number1 + number2) * number3
  print(result)
}

operations(1, 2, 3)
operations(17, 23, 2)


##
## Default values for arguments
##
operations <- function(number1, number2, number3=3) {
  result <- (number1 + number2) * number3
  print(result)
}

operations(1, 2, 3) # becomes equivalent to
operations(1, 2)
operations(1, 2, 2) # we can still change the value of number3 if needed


##
## The ... Argument
##

## Used to pass on arguments to other functions
plot.CO2 <- function(CO2, ...) {
  plot(x=CO2$conc, y=CO2$uptake, type="n", ...)  # We do not specify any other information for plot. We use ... instead
  
  for (i in 1:length(CO2[,1])){
    if (CO2$Type[i] == "Quebec") {
      points(CO2$conc[i], CO2$uptake[i], col="red", type="p", ...)
    } else if (CO2$Type[i] == "Mississippi") {
      points(CO2$conc[i], CO2$uptake[i], col="blue", type="p", ...)
    }
  }
}

plot.CO2(CO2, cex.lab=1.4, xlab="CO2 concentration", ylab="CO2 uptake")
plot.CO2(CO2, cex.lab=1.4, xlab="CO2 concentration", ylab="CO2 uptake", pch=20)


## Or to use unlimited arguments
sum2 <- function(...) {
  args <- list(...)
  result <- 0
  for (i in args)  {
    result <- result + i
  }
  return (result)
}

sum2(2,3)
sum2(2, 4, 5, 7688, 1)


##
## Return values
##
returntest <- function(a, b) {
  return (a)  # The function exits here
  a <- a + b  # Not interpreted
  return (a + b)  # Not interpreted
}

returntest(2, 3) # R will by default print the return value of your function
c <- returntest(2, 3) # to save it, don't forget to assign it to another variable
c


##
##  Accessibility of variables
##
rm(list=ls()) # first let's remove everything to avoid any confusion
var1 <- 3     # var1 is defined outside our function
vartest <- function() {
  a <- 4      # a is defined inside
  print(a)    # print a
  print(var1) # print var1
}
a             # print a. It doesn't work, a can be seen only inside the function
vartest()     # calling vartest() will print a and var1 
rm(var1)      # remove var1
vartest()     # calling the function again doesn't work anymore


var1 <- 3     # var1 is defined outside our function
vartest <- function(var1) {
  print(var1) # print var1
}

vartest(8)   # Inside our function var1 is now our argument and takes its value
var1         # var1 is still the same


# Be careful when creating variable in conditional statements
a <- 3
if (a > 5) {
  b <- 2 # b is not defined if a < 5
} 
a + b # Error

# define variables outside instead
a <- 3
b <- 0
if (a > 5) {
  b <- 2
} 
a + b


######################
##  Good practices  ##
######################

##
## Keep a clean and well indented code
##

# That's a little bit hard to read...
a<-4;b=3
if(a<b){
if(a==0)print("a zero") } else {
if(b==0){print("b zero")} else print(b)}


# That's better
a <- 4
b <- 3
if(a < b){
  if(a == 0) {
    print("a zero")
  }
} else {
  if(b == 0){
    print("b zero")
  } else {
    print(b)
  }
}


##
## Use functions
##

## Instead of repeating chunks of code like this
for (i in 1:length(CO2[,1])) {
  if(CO2$Type[i] == "Mississippi") {
    CO2$conc[i] <- CO2$conc[i] - 20 
  }
}
for (i in 1:length(CO2[,1])) {
  if(CO2$Type[i] == "Quebec") {
    CO2$conc[i] <- CO2$conc[i] + 50 
  }
}


## Create a function to do it
recalibrate <- function(CO2, type, bias) {
  for (i in 1:nrow(CO2)) {
    if(CO2$Type[i] == type) {
      CO2$conc[i] <- CO2$conc[i] + bias 
    }
  }
  # we have to return our new dataset because the original is not modified
  return (CO2)
}

newCO2 <- recalibrate(CO2, "Mississipi", -20)
# Note that we recalibrate our newCO2 dataset here because the original CO2 is not modified
newCO2 <- recalibrate(newCO2, "Quebec", +50)



##
## Give meaningful variable and function names
##

# Because code not easily understandable == loss of time
rc <- function(c, t, b) {
  for (i in 1:nrow(c)) {
    if(c$Type[i] == t) {
      c$uptake[i] <- c$uptake[i] + b 
    }
  }
  return (c)
}


##
## Add Comments
##

## recalibrates the CO2 dataset by modifying the CO2 uptake concentration
## by a fixed amount depending on the region of sampling
# Arguments
# CO2: the CO2 dataset
# type: the type that need to be recalibrated. Values: "Mississippi" or "Quebec"
# bias: the amount to add to the concentration uptake. Use negative values for overestimations 
recalibrate <- function(CO2, type, bias) {
  for (i in 1:nrow(CO2)) {
    if(CO2$Type[i] == type) {
      CO2$uptake[i] <- CO2$uptake[i] + bias 
    }
  }
  # we have to return our new dataset because the original is not modified
  return (CO2)
}



#############################
##  Speeding up your code  ##
#############################

##
## Profiling
##

## system.time
system.time(replicate(1000, {
  a <- 0
  for (i in 1:1000) {
    a <-  a + i
  }
}))

## Rprof
Rprof("profile.txt")  # you can change profile.txt by the filename you want
a <- 0
for (i in 1:1000000) {
  a <-  a + i
}
Rprof(NULL)               # This ends the profiling
summaryRprof("profile.txt")  # Use the filename previously recorded to display the summary of the tasks



## microbenchmark
library(microbenchmark)

f1 <- function() {
  a <- 0
  for (i in 1:1000) {
    a <-  a + i
  }
}

microbenchmark(f1(), times=1000) # the argument times allow us to determine how many iterations we want


##
## First step : Thinking a bit
##

## First attempt

f2 <- function(a) {
  # initialize our result
  result <- 0
  # iterate on the sequence from 1 to 100
  for (i in 1:100) {
    if (a < 5) {
      # a is < 5, we add 2 * a to the sequence element and to a. We save it in result 
      result <- result + i + (2 * a)
    } else {
      # a is >= 5, we do not add 1 
      result <- result + i + a
    }
  }
  return(result)
}
f2(4)


## Second attempt : remove useless operations
f3 <- function(a) {
  # initialize our result
  result <- 0
  
  # Check if a < 5 and add 1 if true
  if (a < 5) {
   a <- 2 * a
  } 
  # We don't even need an else here since a remains the same otherwise
  
  # iterate on the sequence from 1 to n
  for (i in 1:100) {
      result <- result + i + a 
  }
  return(result)
}

f3(4)
## f3() is faster than f2()
microbenchmark(f2(4), 
               f3(4), times=1000)


## Third attempt : use some R power
f4 <- function(a) {
  result <- 0
  if (a < 5) {
    a <- a * 2
  } 
  result <- sum(1:100 + a)
  return(result)
}


f4(4)
## f4() is way faster than f3()
microbenchmark(f3(4), f4(4), times=10000)


#####################
##  Vectorization  ##
#####################

## Simple operations on vectors
v1 <- 1:5
v2 <- 2:6
v3 <- 1:3
v1 + 2      # Addition on a vector : adds 2 to all elements
v1 + v2     # Adds each element of v2 to v
v1 + v3     # v1 and v3 are not the same length, then we add from the start of v3 again
sum(v1)     # Adds all elements of v1 together
sum(v1, v2) # Sums all elements of v1 and v2 
mean(v1)    # Average of elements in v1
mean(c(v1, v2)) # Average of elements of v1 and v2. Unlike sum, we have to combine them beforehand


## Subsetting
v1 <- 1:10
v1[7]      # Extracts the 7th value
v1[v1 > 5] # Extracts values > 5 only
v1[which(v1 > 5)]  # same as before

## With data frames
data(CO2)
CO2$Type  # Prints columns Type
CO2[, "Type"] # Same as above
CO2[CO2$Type == "Quebec", ] #Extracts all rows of the CO2 dataset where the Type is "Quebec"


#######################
##  Growing objects  ##
#######################

## With a growing object
growing <- function(n) {
  # declare our result
  result <- NULL
  for (i in 1:n) {
    # create our result by growing our object
    result <- c(result, i)
  }
  return(result)
}

## With preallocation of our result
growing2 <- function(n) {
  # declare our result : here we create a vector of length n with 0 in it
  result <- numeric(n)
  for (i in 1:n) {
    # now we just modify our value instead of recreating the vector
    result[i] <- i
  }
  return(result)
}


system.time({
  growing(10000)
})
system.time({
  growing2(10000)
})

## Time spent gets substantially higher with only 5x data
system.time({
  growing(50000)
})
system.time({
  growing2(50000)
})



## Growing data frame
growingdf <- function(n, row) {
  # preallocate our dataframe
  df <- data.frame(numeric(n), character(n), stringsAsFactors=FALSE)
  for (i in 1:n) {
    # replace the ith row with row
    df[i,] <- row 
  }
  return(df)
}

## Preallocating a data frame : first store rows in a list, then combine them
## all in one go
growingdf2 <- function(n, row) {
  # this is the way to allocate a list with n elements
  df <- vector("list", n)
  for (i in 1:n) {
    # put row in the ith element
    df[[i]] <- row
  }
  return(do.call(rbind, df))
}


row <- list(1, "Hello World")
microbenchmark(growingdf(5000, row),
               growingdf2(5000, row),
               times=10)



########################
##  The apply family  ##
########################
df <- data.frame(1:100, 101:200)
# Sum on rows
apply(df, 1, sum)
# Mean on columns
apply(df, 2, mean)
# we can also supply additionnal arguments to the function
apply(df, 2, mean, na.rm=TRUE)
# we can also define a function directly. The first argument is always what 
# we iterate on. Here each row is treated as a vector of numbers
apply(df, 1, function(x){str(x)})
# We can also add other arguments
apply(df, 1, function(x, y){x[2] - x[1] + y}, y=5)


a <- list(1:100, 101:200)
# apply mean to each element of the list
lapply(a, mean)  # we get a list as a result
unlist(lapply(a, mean)) # use unlist to get a vector instead
# You could also use
sapply(a, mean)
# Sometimes, vapply can be faster 
vapply(a, mean, numeric(1)) # the result of mean is a single number, we tell vapply our result will be a number



#### EXERCISE ANSWERS #### 

## Exercise 1- if, if/else, and ifelse ##

Paws<-"cat"
Scruffy<-"dog"
Sassy<-"cat"
animals<-c(Paws,Scruffy,Sassy)

# 1. Use an if statement to write "meow" if Paws is a "cat".

if(Paws=="cat") {
  print("meow")}

# 2. Use an if/else statement to write "woof" if you supply an object that is a "dog" and "meow" if it is not.  Try it out with Paws and Scruffy.

if(Scruffy=="dog") {
  print("woof") 
} else {
  print ("meow")
}

# 3. Use an ifelse statement to display "woof" for animals that are dogs and "meow" for animals that are cats.

ifelse(animals=="dog","woof","meow")

## Exercise 2 ## - Loops

# 1. You have realized that your tool for measuring uptake was not calibrated properly at Quebec sites and all measurements are 2 units higher than they should be.  Use a loop to correct these measurements for all Quebec sites.

for (i in 1:length(CO2[,1])) {
  if(CO2$Type[i]=="Quebec") {
    CO2$uptake[i]=CO2$uptake[i]-2}
}

## Exercise 3 ## - Loop modifications

# 1. You have realized that your tool for measuring concentration didn't work properly.  At Mississippi sites, concentrations less than 300 were measured correctly but concentrations>=300 were overestimated by 20 units.  Use a loop to correct these measurements for all Mississippi sites.

for (i in 1:length(CO2[,1])) {
  if(CO2$Type[i]=="Mississippi") {
    if(CO2$conc[i]<300) next 
    CO2$conc[i]=CO2$conc[i]-20 }
}

## Exercise 4 ## - Generate a plot using if statements

# 1. Generate a plot of showing concentration versus uptake where each plant is shown using a different colour point.  Bonus points for doing it with nested loops!

plot(x=CO2$conc, y=CO2$uptake, type="n", cex.lab=1.4,xlab="CO2 concentration", ylab="CO2 uptake") # Type "n" tells R to not actually plot the points.

plants<-unique(CO2$Plant)

for (i in 1:length(CO2[,1])) 
{
  for (p in 1:length(plants)) { 
    if (CO2$Plant[i]==plants[p]) {
      points(CO2$conc[i],CO2$uptake[i],col=p,type="p") }
  }
}




##############################
##  Interesting R packages  ##
##############################

# Run this code only once to install packages used below
# install.packages(c('reshape2','data.table','ggplot2','RgoogleMaps','spocc','knitr','plyr','dplyr','rgdal','taxize','geonames'))


##
## Data table
## Package to very efficiently perform queries on a dataset. A data table is like an optimized version of a data frame,
## with optimized and easier methods for subsetting and performing grouping operations. 
##
library(data.table)
# We create a very long data frame with two columns. One with letters and one with random numbers. 
mydf=data.frame(a=rep(LETTERS,each=1e5),b=rnorm(26*1e6))
mydt=data.table(mydf)
setkey(mydt,a) # We set the column that will be used as a key for the data table

mydt['F']
# Returns all rows with column a (the key) equal to F 

##
## Perfomance comparison of different methods
##
mydt[,mean(b),by=a]
# Gives the mean value of column b for each letter in column a. 
# Compare the performance of data table using
system.time(t1<-mydt[,mean(b),by=a])

##
## With tapply()
##
system.time(t2<-tapply(mydf$b,mydf$a,mean))

##
## With reshape2
## Used to: transform data between wide and long formats, and some grouping operations
##
library(reshape2)
meltdf=melt(mydf)
system.time(t3<-dcast(meltdf,a~variable,mean))

##
## With plyr
## Used to: easily transform and manipulate datasets, grouping operations
##
library(plyr)
system.time(t4<-ddply(mydf,.(a),summarize,mean(b)))

##
## With dplyr
## Similar to plyr, but adapted only to data frames, simpler to use and more efficient
##
library(dplyr)
ti1<-proc.time()
groups <- group_by(mydf, a)
t5 <- summarise(groups, total = mean(b))
eltime<-proc.time()-ti1

##
## With sqldf
## Use Structured Query Language operations, normally used for databases, on data frames. 
##
library(sqldf)
system.time(t6<-sqldf('SELECT a, avg(b) FROM mydf GROUP BY a'))

##
## With a FOR loop
##
ti1<-proc.time()
t7<-data.frame(letter=unique(mydf$a),mean=rep(0,26))
for (i in t7$letter ){
  t7[t7$letter==i,2]=mean(mydf[mydf$a==i,2])
}
eltime<-proc.time()-ti1

##
## With a parallelized FOR loop
## Each loop iteration is sent to one of the four cores of the computer. This can make the code faster on multi-core systems
##
library(foreach)
library(doMC)
registerDoMC(4) #Four-core processor
ti1<-proc.time()
t8<-data.frame(letter=unique(mydf$a),mean=rep(0,26))
t8[,2] <- foreach(i=t8$letter, .combine='c') %dopar% {
  mean(mydf[mydf$a==i,2])
}
eltime<-proc.time()-ti1

##
## RgoogleMaps
## Easily display Google maps or satellite images in R, or geocode addresses, placenames or postal codes
##
library(RgoogleMaps)
myhome=getGeoCode('Olympic stadium, Montreal');
mymap<-GetMap(center=myhome, zoom=14)
PlotOnStaticMap(mymap,lat=myhome['lat'],lon=myhome['lon'],cex=5,pch=10,lwd=3,col=c('red'));

##
## Taxize 
## Connect R to taxonomic databases like ITIS, EOL, tropicos or ncbi.
##
library(taxize)
spp<-tax_name(query=c("american beaver","sugar maple"),get="species")
fam<-tax_name(query=c("american beaver","sugar maple"),get="family")
correctname <- tnrs(c("fraxinus americanus"))
cla<-classification("acer rubrum", db = 'itis')

##
## Spocc
## Connect R to species occurrence databases like GBIF
##
library(spocc)
occ_data <- occ(query = 'Acer nigrum', from = 'gbif')
mapggplot(occ_data)

## Combine spocc and RgoogleMaps
occ_data <- occ(query = 'Puma concolor', from = 'gbif')
occ_data_df=occ2df(occ_data)
occ_data_df<-subset(occ_data_df,!is.na(latitude) & latitude!=0)
mymap<-GetMap(center=c(mean(occ_data_df$latitude),mean(occ_data_df$longitude)), zoom=2)
PlotOnStaticMap(mymap,lat=occ_data_df$latitude,lon=occ_data_df$longitude,cex=1,pch=16,lwd=3,col=c('red'));

##
## Geonames
## Connect R to the Geonames.org database of place names and toponymic information 
##
library(geonames)
options(geonamesUsername="glaroc")
res<-GNsearch(q="Mont Saint-Hilaire")
dc<-GNcities(45.4, -73.55, 45.7, -73.6, lang = "en", maxRows = 10)



