# plot4.R : Line
# Practical portion part 4 of week 1 of "EDA"
#
# Replicate plot #4 as specified
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
# note: Inspect txt file to see that data is semi-colin separated
       namefile = "./data/household_power_consumption.txt"
#
#  The following descriptions of the 9 variables in the dataset from the UCI web site:
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
# Only read in needed columns: (not  6)      
       data <- read.csv(namefile,sep=";", colClasses = "character", na.strings ="?")[,c(1,2,3,4,5,7,8,9)]
#
# Concatonate date and time to use the striptime and convert to posixct       
       x <- paste(data$Date, data$Time)
       data$ptime<-as.POSIXct(strptime(x, "%d / %m /%Y %H:%M:%S"))
#
# Change date from character to Date class - use for subsetting.
#       
       data$Date <- as.Date(data$Date,format="%d/ %m/ %Y")       
# Change Sum_metering data to numeric
       data$Global_reactive_power <- as.numeric <- (data$Global_reactive_power)
       data$Global_active_power <- as.numeric(data$Global_active_power)
       data$Voltage <- as.numeric(data$Voltage)
       data$Sub_metering_1 <- as.numeric(data$Sub_metering_1)
       data$Sub_metering_2 <- as.numeric(data$Sub_metering_2)
       data$Sub_metering_3 <- as.numeric(data$Sub_metering_3)
#
# Subset data according to date requirement into new table 'newdata'
       newdata <-subset(data,Date >=as.Date("2007-02-01") & Date <= as.Date("2007-02-02"))
#
# Construct the LINE plot and save it to a PNG file with a width of 480 pixels and a height of 480 pixels.
#
# PLOT  
# NOTE: There seems to be a mac/R issue with the legend... This code has legend tweaked
       # for optimal match in PNG plot (course directions).
       # For plot to screen to achieve same - replace legend with ##mac lines in section with legend.
       
#Clear all graphical devices
       if(!dev.cur()==1) dev.off()
#open graphical devices
       dev.new()
       # See grahical devices with dev.list()
       # See current devices with dev.cur()
#Construct the LINE plot and save it to a PNG file with a width of 480 pixels and a height of 480 pixels.
       png("plot4.png", width= 480, height = 480)
# Save current png device integer
       pngDevice=dev.cur()
# Set device back to RStudioGD
       dev.set(which = 2)
# now plot set 2 by 2 region that plots right to left from top using mfrow parameter.
       par(mfrow = c(2,2))
#       
       # Top Left plot
       plot(newdata$ptime, newdata$Global_active_power,type ="l",
            xlab="", ylab="Global Active Power (kilowatts)")
       
       # Top Right plot
       plot(newdata$ptime, newdata$Voltage,type ="l",
            xlab="datatime", ylab="Voltage")
       
       # Bottom Left plot
       plot(newdata$ptime, newdata$Sub_metering_1,type ="l",
            xlab="", ylab="Energy sub metering")
       lines(newdata$ptime,newdata$Sub_metering_2,col="red",type ="l")
       lines(newdata$ptime,newdata$Sub_metering_3,col="blue",type ="l")
# Use this legend for clean plot to RStudio mac screen.
##mac       legend("topright",c(names(newdata[6:8])), col=c("black","red","blue"),
##mac               pt.cex=1, cex = 1, lty=1, bty="n", inset=0.1)
#    
# Use this legend to have legend placement behave as desired in PNG.
# xposition(1000) found through trial and error.
       legend(newdata$ptime[1000],40,legend =c(names(newdata[6:8])),
              col=c("black","red","blue"), pt.cex=1, cex = 1, lty=1, bty="n", inset=0)
             # Bottom Right Plot
       plot(newdata$ptime, newdata$Global_reactive_power,type ="l",
            xlab="datetime", ylab="Global_reactive_power")
#
       dev.copy(which = pngDevice)
#
       dev.off()