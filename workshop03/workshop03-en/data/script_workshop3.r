# QCBS R Workshop Series ##

## ggplot2 // tidyr // dplyr ##

## Author: Quebec Center for Biodiversity Science
## Materials Generated & Amalgamated by: 
## Xavier Giroux-Bougard, Monica Granados,
## Maxwell Farrell, Etienne Low-Decarie
## Last updated: November 2018
## Built under R version 3.3.3 

#### 0. Housekeeping ####

# Clean up your current working directory
rm(list=ls())

# Install and/or load required packages

if(!require(ggplot2)){install.packages("ggplot2")}
require(ggplot2)

if(!require(tidyr)){install.packages("tidyr")}
require(tidyr)

if(!require(dplyr)){install.packages("dplyr")}
require(dplyr)

if(!require(magrittr)){install.packages("magrittr")}
require(magrittr)

if(!require(gridExtra)){install.packages("gridExtra")}
require(gridExtra)

if(!require(devtools)){install.packages("devtools")}
require(devtools)


#------------------------------------------------------------#
#### 1. Plotting in R using grammar of graphics (ggplot2) ####
#------------------------------------------------------------#

#### 1.1 Intro to ggplot2 ####

#### 1.2 Simple plots using qplot() ####

# Explore the qplot help file
?qplot

# Explore the Iris dataset
data(iris)
?iris
head(iris)
str(iris)
names(iris)

# Most basic scatter plot
qplot(data = iris,
         x = Sepal.Length,
         y = Sepal.Width)

# Most basic scatter plot (categorical data)
qplot(data = iris,
         x = Species,
         y = Sepal.Width)

# Basic scatter plot with labels/title
qplot(data = iris,
         x = Sepal.Length,
      xlab = "Sepal Length (mm)",
         y = Sepal.Width,
      ylab = "Sepal Width (mm)",
      main = "Sepal dimensions")


#------------------------------------------------------------------------------#
#-----------------------------#
#### ggplot2 - Challenge 1 #### 
#-----------------------------#

# Using the qplot() function, build a basic scatter plot with a title
# and axis labels from one of the CO2 or BOD data sets in R. You can load
# these and explore their contents as follows:

?CO2
data(CO2)
?BOD
data(BOD)

# SOLUTION:
qplot(data = CO2,
         x = conc,
      xlab = "Concentration de CO2 (mL/L)",
         y = uptake,
      ylab = "Absorption de CO2 (umol/m^2 sec)",
      main = "Absorption de CO2 chez une espèce de graminée")

#------------------------------------------------------------------------------#
#### 1.3 The Grammar of Graphics ####

#### 1.4 Advanced plots using ggplot() ####

# using qplot()
qplot(data = iris,
      x = Sepal.Length,
      xlab = "Sepal Length (mm)",
      y = Sepal.Width,
      ylab = "Sepal Width (mm)",
      main = "Sepal dimensions")

# equivalent code using ggplot()
ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width)) +
    geom_point() +
    xlab("Sepal Length (mm)") +
    ylab("Sepal Width (mm)") +
    ggtitle("Sepal dimensions")

# Assign ggplot to object
basic.plot <- ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width)) +
    geom_point()+
    xlab("Sepal Length (mm)")+
    ylab("Sepal Width (mm)")+
    ggtitle("Sepal dimensions")

#### 1.5 Adding colours and shapes ####
basic.plot <- basic.plot +
              aes(colour = Species, shape = Species)
basic.plot
#### 1.6 Adding geometric objects ####    
linear.smooth.plot <- basic.plot + 
                      geom_smooth(method = "lm", se = FALSE)
linear.smooth.plot

#------------------------------------------------------------------------------#
#------------------------------#
#### ggplot2 - Challenge 2 ####
#------------------------------#

# Produce a colourful plot with linear regression (or other smoother) 
# from built in data such as the CO2 dataset or the msleep dataset:

# Explore the CO2 dataset
data(CO2)
?CO2
head(CO2)
str(CO2)
names(CO2)

# Solution using a loess smoother
data(CO2)
CO2.plot <- ggplot(data = CO2, aes(x = conc, y = uptake, colour = Treatment)) +
    geom_point() +
    xlab("CO2 Concentration (mL/L)") +
    ylab("CO2 Uptake (umol/m^2 sec)") +    
    ggtitle("CO2 uptake in grass plants") +
    geom_smooth(method = "loess")
CO2.plot

# Could also create a smoothed curve and add colour you SE intervals by factor
CO2.plot <- ggplot(data = CO2, aes(x = conc, y = uptake, colour = factor(Treatment))) +
    geom_point() +
    xlab("CO2 Concentration (mL/L)") +
    ylab("CO2 Uptake (umol/m^2 sec)") +    
    ggtitle("CO2 uptake in grass plants") +
    geom_smooth(method = "loess", aes(fill = factor(Treatment)))
CO2.plot
#------------------------------------------------------------------------------#

#### 1.7 Adding multiple facets ####

# basic plot from CO2
data(CO2)
CO2.plot <- ggplot(data = CO2, aes(x = conc, y = uptake, colour = Treatment)) +
    geom_point() +
    xlab("CO2 Concentration (mL/L)") +
    ylab("CO2 Uptake (umol/m^2 sec)") +    
    ggtitle("CO2 uptake in grass plants")
CO2.plot

# Adding facets
CO2.plot <- CO2.plot + facet_grid(. ~ Type)
CO2.plot

#### 1.8 Adding groups ####

# Adding line geoms
CO2.plot + geom_line()

# Specifying groups
CO2.plot <- CO2.plot + 
  geom_line(aes(group = Plant))
CO2.plot

#------------------------------------------------------------------------------#
#-----------------------------#
#### ggplot2 - Challenge 3 #### 
#-----------------------------#

# Explore a new geom and other plot elements with your own data or built in data
?msleep
data(msleep)
?OrchardSprays
data(OrchardSprays)

# SOLUTION
data(OrchardSprays)
box.plot  <- ggplot(data = OrchardSprays, aes(x = treatment, y = decrease)) +
    geom_boxplot()
box.plot
#------------------------------------------------------------------------------#

#### 1.9 Saving plots ####


pdf("./plots/todays_plots.pdf")
print(basic.plot)
print(linear.smooth.plot)
print(CO2.plot)
graphics.off()

# with the ggsave() function
ggsave("./plots/CO2_plot.pdf", CO2.plot, height = 8.5, width = 11, units = "in")

#### 1.10 Fine tuning - colours ####

# manually 
CO2.plot + scale_colour_manual(values = c("nonchilled" = "red","chilled" = "blue"))

# with hex colours 
CO2.plot + scale_colour_manual(values = c("#FF0000", "#1111e5"))

# with RColorBrewer
if(!require(RcolorBrewer)) {install.packages("RColorBrewer")}
require(RColorBrewer)

basic.plot + scale_color_brewer(palette="Dark2")


# Bonus!!! Wes Anderson colour palette
if(!require(devtools)) {install.packages("devtools")}
library(devtools)
devtools::install_github("karthik/wesanderson", force = TRUE)
library(wesanderson)

basic.plot + 
    scale_color_manual(values = wes_palette("GrandBudapest1", 3)) 

#### 1.11 Fine tuning axes and scales ####
CO2.plot + scale_y_continuous(name = "CO2 uptake rate",
                              breaks = seq(5, 50, by = 10),
                              labels = seq(5, 50, by = 10), 
                              trans = "log10")

#### 1.12 Fine tuning themes ####

# black and white ggplot2 theme
CO2.plot + theme_bw()

# building your own theme
mytheme <- theme_bw() + 
    theme(plot.title = element_text(colour = "red")) +
    theme(legend.position = c(0.9, 0.9))
CO2.plot + mytheme

# BONUS: ggtheme package
if(!require(ggthemes)) {install.packages("ggthemes")}
library(ggthemes)

CO2.plot + theme_tufte()


# base R plots

plot(iris)
lm <- lm(Sepal.Length~Petal.Width, data = iris)
x11()
plot(lm)

# Bonus! - Ecologists who may become vegan users #

install_github("ggvegan", "gavinsimpson")
library(ggvegan)
data(dune)
data(dune.env)
sol <- cca(dune ~ A1 + Management, data = dune.env)
autoplot(sol)
data(mite)
data(mite.env)
mite.hel = decostand(mite, "hel")
rda <- rda(mite.hel ~ WatrCont + Shrub, mite.env)  # Model with all explanatory variables
x11()
ggvegan.plot <- autoplot(rda) + theme_bw()
normal.plot <- plot(rda)


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


# Diagnostic plots using the wide format + ggplot2

# 1:  Visualize each individual variable and the range it displays for each month in the timeseries

fMonth <- factor(airquality$Month) #Convert the Month variable to a factor. 

ozone.box <- ggplot(airquality, aes(x = fMonth, y = Ozone)) + geom_boxplot()
solar.box <- ggplot(airquality, aes(x = fMonth, y = Solar.R)) + geom_boxplot()
temp.box  <- ggplot(airquality, aes(x = fMonth, y = Temp)) + geom_boxplot()
wind.box  <- ggplot(airquality, aes(x = fMonth, y = Wind)) + geom_boxplot()


# You can use grid.arrange() in the package gridExtra to put these plots into 1 figure. 
combo.box <- grid.arrange(ozone.box, solar.box, temp.box, wind.box, nrow = 2) 
# nrow = number of rows you would like the plots displayed on.
# This arranges the 4 separate plots into one panel for viewing. 
# Note that the scales on the individual y-axes are not the same. 


# 2: You can continue using the wide format of the airquality dataset to make 
#    individual plots of each variable showing day measurements for each month. 
ozone.plot <- ggplot(airquality, aes(x = Day, y = Ozone)) +
    geom_point() +
    geom_smooth() +
    facet_wrap(~ Month, nrow = 2)

solar.plot <- ggplot(airquality, aes(x = Day, y = Solar.R)) +
    geom_point() +
    geom_smooth() +
    facet_wrap(~ Month, nrow = 2)

wind.plot <- ggplot(airquality, aes(x = Day, y = Wind)) +
    geom_point() +
    geom_smooth() +
    facet_wrap(~ Month, nrow = 2)

temp.plot <- ggplot(airquality, aes(x = Day, y = Temp)) +
    geom_point() +
    geom_smooth() +
    facet_wrap(~ Month, nrow = 2)

# You could even then combine these different faceted plots together:
# (though it looks pretty ugly at the moment) 
combo.facets <- grid.arrange(ozone.plot, solar.plot, wind.plot, temp.plot, nrow = 4)

# BUT, what if I'd like to use facet_wrap() for the variables 
# as opposed to by month or put all variables on oneplot? 
air.long <- gather(airquality, variable, value, -Month, -Day)
head(air.long)
air.wide <- spread(air.long , variable, value)
head(air.wide)

# Use air.long
fMonth.long <- factor(air.long$Month)
weather <- ggplot(air.long, aes(x = fMonth.long, y = value)) +
    geom_boxplot() +
    facet_wrap(~ variable, nrow = 2)

# Compare the "weather" plot with "combo.box"
# This is the same data but working with it in wide versus long format has allowed us to make different looking plots.

# The weather plot uses facet_wrap to put all the individual variables on the same scale. 
# This may be useful in many circumstances. However, using the facet_wrap means that 
# we don't see all the variation present in the wind variable.
# In that case, you can modify the code to allow the scales to be determined per facet.
weather <- weather + facet_wrap(~ variable, nrow = 2, scales = "free")
weather

# We can also use the long format data (air.long) to create a plot with 
# all the variables included on a single plot:
weather2 <- ggplot(air.long, aes(x = Day, y = value, colour = variable)) +
    geom_point() + #this plot will put all the day measurements on one plot
    facet_wrap(~ Month, nrow = 1) #add this part and again, the observations are split by month
weather2

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
