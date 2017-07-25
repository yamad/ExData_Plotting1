## Plot 4 panels, save to PNG
##   1. global active power over time
##   2. voltage over time
##   3. sub metering over time
##   4. global reactive power over time

fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
localZip <- "household_power_consumption.zip"
localPath <- "household_power_consumption.txt"

# get data, if needed
if (!file.exists(localPath)) {
    if (!file.exists(localZip))
        download.file(fileUrl, destfile=localPath, method="curl")
    unzip(localZip)
}

# read data, subset to dates from Feb 1 and 2, 2007
firstRow <- 66638
lastRow <- 69517
hpower <- read.table(localPath, sep=";", na.strings="?", 
                     skip=firstRow-1, nrows=lastRow-firstRow)
names <- read.table(localPath, sep=";", nrows=1, 
                    header=FALSE, stringsAsFactors=FALSE)

# clean data
names(hpower) <- as.character(names)
hpower$Global_active_power <- as.numeric(hpower$Global_active_power)
hpower$DateTime <- strptime(paste(hpower$Date, hpower$Time), "%d/%m/%Y %H:%M:%S")

# plot
png("plot4.png", height=480, width=480)
par(mfrow=c(2,2))

# plot 1, global active power over time
with(hpower, plot(DateTime, Global_active_power, type="l",
     ylab="Global Active Power", xlab=""))

# plot 2, voltage over time
with(hpower, plot(DateTime, Voltage, type="l", xlab=""))

# plot 3, sub metering over time
with(hpower, plot(DateTime, Sub_metering_1, type="n",
     ylab="Energy sub metering", xlab=""))
with(hpower, lines(DateTime, Sub_metering_1, col="black"))
with(hpower, lines(DateTime, Sub_metering_2, col="red"))
with(hpower, lines(DateTime, Sub_metering_3, col="blue"))
legend("topright", lwd=1, bty="n",
       legend=paste("Sub metering", c(1, 2, 3)), 
       col=c("black", "red", "blue"))

# plot 4, global reactive power over time
with(hpower, plot(DateTime, Global_reactive_power, type="l",
                  ylab="Global reactive power", xlab=""))
dev.off()
