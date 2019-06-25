# Use '# symbol' to denote comments in scripts. The '# symbol' tells R to ignore anything remaining on a 
# given line of the script when running commands. 
# Since comments are ignored when running script, they allow you to leave yourself notes in your code 
# or tell collaborators what you did. A script with comments is a good step towards reproducible science 
# and annotating someone's script is a good way to learn. 


# It is recommended that you use comments to put a header at the beginning of your script
# with essential information: project name, author, date, version of R.

## QCBS R Workshop ##
## Workshop 2 - Loading and manipulating data
## Author: Quebec Center for Biodiversity Science
## Date: Fall 2018

if(!require(tidyr)){install.packages("tidyr")}
require(tidyr)

if(!require(dplyr)){install.packages("dplyr")}
require(dplyr)

if(!require(magrittr)){install.packages("magrittr")}
require(magrittr)


# Heading name
# You can use four # signs in a row to create section headings to help organize your script.
# For example:

#### Housekeeping ####

# Notice the small arrow next to the line number of the section heading we just created. 
# If you click on it, you hide this section of the script.

# It is good practice to have a command at the top of your script to clear R memory. This will help prevent errors such as using old data that has been left in your workspace. The command rm(list=ls()) will clear memory. 

rm(list=ls())  # Clears R workspace
?rm
?ls

# Remember: R is ready for commands when you see the chevron '>'.
# If the chevron isn't displayed, it means you typed an incomplete command and it is waiting for more input.  Press "Escape" to exit and get R ready for a new command.

A<-"Test"     # Put some data into workspace, to see how rm(list=ls()) removes it
A <- "Test"   # Note that you can use a space before or after <-
A = "Test"    # <- or = can be used equally
## Best practice is to use <- for assignment instead of the "=" sign
A
rm(list=ls())
A

# Remember that R is case sensitive. i.e. "A" is a different object than "a" 
a<-10  
A<-5
a
A

rm(list=ls())  # Clears R workspace again

#### LOADING DATA ####

getwd() # This commands shows the directory you are currently working in

# You can type the path of the directory in the brackets of the command setwd().
setwd('/Users/vincentfugere/Desktop/QCBS_R_Workshop2') # Mac example
setwd('C:/Users/Johanna/Documents/PhD/R_Workshop2')   # Windows Example
# **Note that this path will NOT work on your computer!

# Or you can use choose.dir() to get a pop up to navigate to the appropriate directory.
setwd(choose.dir()) # This may not work on a Mac.

CO2<-read.csv("CO2_good.csv") # Create an object called CO2 by loading data from a file called "CO2_good.csv"
CO2<-read.csv(file.choose()) # Alternatively, you can choose the file to load interactively using this command 

?read.csv # Use the question mark to pull up the help page for a command  

CO2<-read.csv("CO2_good.csv", header = TRUE) 
# Adding header = TRUE tells R that the first line of the spreadsheet contains column names and not data

# NOTE: if you have a french OS or CSV editor and read.csv does not work, try read.csv2 instead

#### LOOKING AT DATA ####

CO2 # Look at the whole dataframe
head(CO2) # Look at the first few rows
names(CO2) # Names of the columns in the dataframe
attributes(CO2) # Attributes of the dataframe
ncol(CO2) # Number of columns
nrow(CO2) # Number of rows
summary(CO2) # Summary statistics

str(CO2) # Structure of the dataframe 
# Useful to check mode of all columns, i.e. to check that all factors are factors and continuous data is integer or numeric

plot(CO2) # Plot of all variable combinations

# Is the response variable normally distributed? Try:
hist(CO2$uptake) # Remember that $ is used to extract a specific column from a dataframe

conc_mean<-mean(CO2$conc) # Calculate mean of the "conc" column of the "CO2" object. Save as "conc_mean"
conc_mean # Display object "conc_mean"
# The concentration mean is 435.

conc_sd<-sd(CO2$conc) # Calculate sd of "conc" column and save as "conc_sd"
conc_sd
# The concentration standard deviation is 295.92.

# Want to calculate mean or sd of all columns at once? Try apply()
?apply
apply(CO2[,4:5], MARGIN = 2, FUN = mean) # calculate mean of the two columns in the dataframe that contain continuous data

## Save your workspace ##

save.image(file="CO2_project_Data.RData") # Save workspace

rm(list=ls())  # Clears R workspace

load("CO2_project_Data.RData") # Reload everything that was in your workspace

head(CO2) # Looking good :)

write.csv(CO2,file="CO2_new.csv") # Save object CO2 to a file named CO2_new.csv

#### CHALLENGE: FIXING BROKEN dataframe ####

# Read a broken CO2 csv file into R and find the problems

CO2<-read.csv("CO2_broken.csv") # Overwrite CO2 object with broken CO2 data

## What are the problems?  Hint: There are 4.

## Useful functions

# Note: for these functions, you have to put the name of the data object in the parantheses (i.e. head(CO2)).
# Also remember that you can use "?" to look up help for a function (i.e. ?str).

?read.csv
head() 
str()  
class()
unique()
levels()
which()
droplevels()

#### ANSWERS BELOW-- No peaking!  ###
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#

## Broken CO2 data Problems ##

## Problem #1: the data appears to be lumped into one column.

# Re-import the data, but specify the separation among entries .
# The sep argument tells R what character separates the values on each line of the file.
# Here, "TAB" was used instead of ",".
CO2 <- read.csv("CO2_broken.csv",sep = "")
?read.csv

## Problem #2: the data does not start until the third line of the txt file, so you end up with notes on the file as the headings.

head(CO2) # The head() command allows you to see that the data has not been read in with the proper headings
# To fix this problem, you can tell R to skip the first two rows when reading in this file.
CO2<-read.csv("CO2_broken.csv",sep = "",skip=2)  # By adding the skip argument into the read.csv function, R knows to skip the first two rows
head(CO2) # You can now see that the CO2 object has the appropriate headings

## Problem #3: "conc" and "uptake" variables are considered factors instead of numbers, because there are comments/text in the numeric columns.

str(CO2) # The str() command shows you that both 'conc' and 'uptake' are labelled as factors
class(CO2$conc)
unique(CO2$conc) # By looking at the unique values in this column, you see that it contains "cannot_read_notes" 
unique(CO2$uptake) #This column contains both "cannot_read_notes" and "na"
?unique

CO2 <- read.csv("CO2_broken.csv",sep = "",skip = 2,na.strings = c("NA","na","cannot_read_notes")) 
# By identifying "cannot_read_notes" and "na" as NA data, R reads these columns properly.
# Remember that NA stands for not available.
head(CO2)
str(CO2) # You can see that the conc variable is now an integer and the uptake variable is now treated as numeric

## Problem #4: There are only two treatments (chilled and nonchilled) but there are spelling errors causing it to look like 4 different treatments.

str(CO2) # You can see that 4 levels are listed for Treatment
levels(CO2$Treatment)
unique(CO2$Treatment) # The 4 different treatments are "nonchilled", "nnchilled", "chilled", and "chiled"  

# You can use which() to find rows with the typo "nnchilled".
which(CO2$Treatment=="nnchilled") # Row number ten
# You can then correct the error using indexing:
CO2$Treatment[10]="nonchilled"
# Alternatively, doing it with a single command:
CO2$Treatment[which(CO2$Treatment=="nnchilled")]="nonchilled"
# Now doing the same for "chiled":
CO2$Treatment[which(CO2$Treatment=="chiled")]="chilled" 

# Have we fixed the problem?
str(CO2)  # Structure still identifies 4 levels of the factor
unique(CO2$Treatment) # But, unique says that only two are used
CO2<-droplevels(CO2) # This command drops the unused levels from all factors in the dataframe
str(CO2) # Fixed!


#------------------------------------------------------------------------------#
#------------------------------------------------#
#### 2. Using tidyr to manipulate data frames ####
#------------------------------------------------#

# Source materials:

# tidyr
#https://blog.rstudio.org/2014/07/22/introducing-tidyr/

#### 2.1 Why "tidy" your data? ####

# Load and explore the "airquality" datasets
?airquality
str(airquality)
head(airquality)
names(airquality)

#### 2.2 Wide vs long data ####

# We can use the "tidyr" package by Hadley Wickham to:
# 1."gather" our data (wide --> long)
# 2."spread" our data (long --> wide)

# Example: Let's pretend you send out your field assistant to measure the
# diameter at breast height (DBH) and height of three tree species for you.
# They return with the following messy (wide) dataset:
messy <- data.frame(Species = c("Oak", "Elm", "Ash"),
                    DBH = c(12, 20, 13),
                    Height = c(56, 85, 55))
messy

#### 2.3 Gather: Making your data long ####
?gather

# "gather()" the DBH and Height columns
messy.long <- gather(messy, Measurement, cm, DBH, Height)
messy.long

# Let's try this with the C02 dataset. Here we might want to collapse the 
# last two quantitative variables "conc" and "uptake":
CO2.long <- gather(CO2, response, value, conc, uptake)  
head(CO2) 
head(CO2.long) 
tail(CO2.long)

#### 2.4 Spread: Making your data wide ####
?spread 

# spread uses the same syntax as gather (they are complements)
messy.wide <- spread(messy.long, Measurement, cm)
messy.wide

#------------------------------------------------------------------------------#
#-------------------------#
#### tidyr Challenge 4 ####
#-------------------------#

# Using the ''airquality'' dataset, ''gather()'' all the columns
# (except Month and Day) into rows. Then ''spread()'' the resulting
# dataset to return the same data format as the original data.

# SOLUTION: 
?airquality
names(airquality)
air.long <- gather(airquality, variable, value, -Month, -Day)
head(air.long)
air.wide <- spread(air.long , variable, value)
head(air.wide)

# Now air.wide is back in the same format as the original airquality
# (although the order of columns is changed)
#------------------------------------------------------------------------------#


# some times you might have really messy data which has two varaiables in
# one column. Thankfully the separate function can (wait for it) 
# separate the two variables into two columns 

#### 2.5 separate(): Separate two (or more) variables in a single column ####

# lets say you have this really messy data set 
set.seed(8)
really.messy <- data.frame(id = 1:4,
                           trt = sample(rep(c('control', 'farm'), each = 2)),
                           zooplankton.T1 = runif(4),
                           fish.T1 = runif(4),
                           zooplankton.T2 = runif(4),
                           fish.T2 = runif(4))

# first we want to convert this wide dataset to long 
really.messy.long <- gather(really.messy, taxa, count, -id, -trt)

# then we want to split those two sampling time (T1 & T2). The syntax we use here is to tell R seperate(data, what column, into what, by what)
# the tricky part here is telling R where to separate the character string in your column entry 
# using a regular expression to describe the character that separates them
# here the string should be separated by the period (.)
really.messy.long.sep <- separate(really.messy.long, taxa, into = c("species", "time"), sep = "\\.") 

#### 2.6 Combining ggplot with tidyr ####

##Example with the air quality dataset on using both wide and long data formats 
head(airquality)
# The dataset is in wide format, where measured variables
# (ozone, solar.r, wind and temp) are placed in their own columns.


#------------------------------------------------------------------------------#
#---------------------------------------#
#### 3. Data manipulation with dplyr ####
#---------------------------------------#

## MEGA DATA MANIPULATION ##

#### 3.1 Intro - the dplyr mission ####

#### 3.2 Basic dplyr functions ####

# Select a subset of columns with select()
ozone <- select(airquality, Ozone, Month, Day)
head(ozone)

# Select a subset of rows with filter()
august <- filter(airquality, Month == 8, Temp >= 90)
head(august)

# Sort columns with arrange()
air_mess <- sample_frac(airquality, 1)
head(air_mess)

air_chron <- arrange(air_mess, Month, Day)
head(air_chron)

# Create and populate columns with mutate()
airquality_C <- mutate(airquality, Temp_C = (Temp-32)*(5/9))
head(airquality_C)


#### 3.3 dplyr and magrittr, a match made in heaven ####

# two steps wrapped
june_C <- mutate(filter(airquality, Month == 6), Temp_C = (Temp-32)*(5/9))

# steps linked using magrittr
june_C <- airquality %>%
  filter(Month == 6) %>%
  mutate(Temp_C = (Temp-32)*(5/9)) 

#### 3.4 dplyr - Summaries and grouped operations ####
month_sum <- airquality %>% 
  group_by(Month) %>% 
  summarise(mean_temp = mean(Temp),
            sd_temp = sd(Temp)) 
month_sum

#------------------------------------------------------------------------------#
#### dplyr Challenge # 5 ####
# Using the ChickWeight dataset, create a summary table which displays the
# difference in weight between the maximum and minimum weight of each chick
# in the study. Employ dplyr verbs and the %>% operator.
weight_gain <- ChickWeight %>% 
  group_by(Chick) %>% 
  summarise(weight_gain = max(weight) - min(weight))
weight_gain

#------------------------------------------------------------------------------#
#### dplyr Ninja Challenge # 6 ####
# Using the ChickWeight dataset, create a summary table which displays, for
# each diet, the average individual difference in weight between the end and
# the beginning of the study. Employ dplyr verbs and the %>% operator.
# (Hint: first() and last() may be useful here.)
diet_summ <- ChickWeight %>% 
  group_by(Diet, Chick) %>% 
  summarise(weight_gain = max(weight) - min(weight)) %>%
  summarise(mean_gain = mean(weight_gain))
diet_summ

#------------------------------------------------------------------------------#
