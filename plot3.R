# plot3.R : Line
# Practical portion part 3 of week 1 of "EDA"
#
# Replicate plot #3 as specified
#
#  Use the “Individual household electric power consumption Data Set” which are 
#   made available on the course web site:
# https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip
#
# Soup to Nuts exercise ... create directory and download data....
#
# load libraries
       library(dplyr)
       library(data.table)
       library(lattice)
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
# Inspect txt file to see that data is semi-colin separated
       namefile = "./data/household_power_consumption.txt"
#             
# Column 1 Date: Date in format dd/mm/yyyy
# Column 2 Time: time in format hh:mm:ss
# Column 3 Global_active_power: household global minute-averaged active power (in kilowatt)
# Column 4 Global_reactive_power: household global minute-averaged reactive power (in kilowatt)
# Column 5 Voltage: minute-averaged voltage (in volt)
# Column 6 Global_intensity: household global minute-averaged current intensity (in ampere)
# Column 7 Sub_metering_1: energy sub-metering No. 1 (in watt-hour of active energy). 
# Column 8 Sub_metering_2: energy sub-metering No. 2 (in watt-hour of active energy). 
# Column 9 Sub_metering_3: energy sub-metering No. 3 (in watt-hour of active energy). 
#
# Only use data from the dates 2007-02-01 and 2007-02-02.               
# Only read in needed columns: Date, Time, and Sub_metering[1-3]      
       data <- read.csv(namefile,sep=";", colClasses = "character", na.strings ="?")[,c(1,2,7,8,9)]
#
# Concatonate date and time to use the striptime and convert to posixct       
       x <- paste(data$Date, data$Time)
       data$ptime<-as.POSIXct(strptime(x, "%d / %m /%Y %H:%M:%S"))
#
# Change date from character to Date class - use for subsetting.
#       
       data$Date <- as.Date(data$Date,format="%d/ %m/ %Y")       
# Change Sum_metering data to numeric
       data$Sub_metering_1 <- as.numeric(data$Sub_metering_1)
       data$Sub_metering_2 <- as.numeric(data$Sub_metering_2)
       data$Sub_metering_3 <- as.numeric(data$Sub_metering_3)
#
# Subset data according to date requirement into new table 'newdata'
       newdata <-subset(data,Date >=as.Date("2007-02-01") & Date <= as.Date("2007-02-02"))
#
# Construct the LINE plot and save it to a PNG file with a width of 480 pixels and a height of 480 pixels.
#
       png("plot3.png", width= 480, height = 480) 
       plot(newdata$ptime, newdata$Sub_metering_1,type ="l",
            xlab="", ylab="Energy sub metering")
          lines(newdata$ptime,newdata$Sub_metering_2,col="red",type ="l")
          lines(newdata$ptime,newdata$Sub_metering_3,col="blue",type ="l")
          legend("topright",c(names(newdata[3:5])),col=c("black","red","blue"), lty = 1 )
       dev.off()
       