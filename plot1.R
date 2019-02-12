# plot_1.R : Histogram
# Practical portion part 1 of week 1 of "EDA"
#
# Replicate plot #1 as specified
#
#  Use the “Individual household electric power consumption Data Set” which are 
#   made available on the course web site:
# https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip
#
## Soup to Nuts exercise ... create directory and download data....
#
#load libraries
       library(dplyr)
       library(data.table)
#
# Create data directory if it does not exists
#
       if(!file.exists('./data')) dir.create('./data')
#
# Get data if needed.
#
       if(!file.exists('./data/exdata_Fhousehold_power_consumption.zip')) {
          fileURL <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
          download.file(fileURL, destfile = './data/exdata_Fhousehold_power_consumption.zip')
       }
#
# Unzip data if needed
#
       if(!file.exists('./data/household_power_consumption.txt')) {
          unzip('./data/exdata_Fhousehold_power_consumption.zip', exdir = './data')
       }
# 
# Note: Inspected txt file to see that data is semi-colin separated
       namefile = "./data/household_power_consumption.txt"
#
# Only use data from the dates 2007-02-01 and 2007-02-02.               
# Only read in columns: Date, Time, and Global_active_power      
       data <- read.csv(namefile,sep=";", colClasses = "character", na.strings ="?")[,c(1,3)]
#
# Change Date from character to Date class
#       
       data$FixedDate <- as.Date(data$Date,format="%d/ %m/ %Y")       
# Change Global Active Power to numeric
       data$Global_active_power <- as.numeric(data$Global_active_power)
#
# Subset data according to date requirement into new table 'newdata'
       newdata <-subset(data,FixedDate >=as.Date("2007-02-01") & FixedDate <= as.Date("2007-02-02"))
# 
# Plot histogram with appropriate data, color, title and label 
# Construct the plot and save it to a PNG file with a width of 480 pixels and a height of 480 pixels.
       #
       png("plot1.png", width= 480, height = 480)      
       hist(newdata$Global_active_power,col="red", xlab="Global active power (kilowatts)",main = "Global Active Power")
       dev.off()
# if wanted... pdf would be as follows...
#dev.copy2pdf(file="Plot1.pdf", width = 7, height = 5)

