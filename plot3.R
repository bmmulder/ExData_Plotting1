# create temp file
temp <- tempfile()
# download the zip into the temp file
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp)
# read the unzipped file into a datatable

# hpc <- read.table(unz(temp, "household_power_consumption.txt"), header=TRUE, sep=";", na.strings="?")
hpc <- read.table(unz(temp, "household_power_consumption.txt"), header=TRUE, sep=";", na.strings="?")

# unlink the temp file
unlink(temp)

# add datetime column for easier selection of the part needed for the graphs
hpc <- within(hpc, Datetime <- as.POSIXlt(paste(Date, Time), 
                                          format = "%d/%m/%Y %H:%M:%S"))

# load sqldf for data analysis
# install.packages("sqldf")
library(sqldf)

# construct part of data needed for the graphs
period.interest <- subset(hpc, Datetime >= as.POSIXct('2007-02-01 00:00') & Datetime <=
                            as.POSIXct('2007-02-02 23:59'))

# plot 3
png('plot3.png', width=480, height=480, res=72)

plot(period.interest$Datetime, period.interest$Sub_metering_1, col="black", type="l", xlab="", ylab="Energy Sub Metering", main="")
lines(period.interest$Datetime, period.interest$Sub_metering_2, col="red", type="l")
lines(period.interest$Datetime, period.interest$Sub_metering_3, col="blue", type="l")

legend("topright", # places a legend at the appropriate place and scale without border
       c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), # puts text in the legend
       lty=c(1,1,1), # gives the legend appropriate symbols (lines)
       lwd=c(2,2,2),col=c("black", "red", "blue")) # gives the legend lines the correct color and width

dev.off()