## Plot all 3 sub metering series over time, save to PNG

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
png("plot3.png", height=480, width=480)
with(hpower, plot(DateTime, Sub_metering_1, type="n",
     ylab="Energy sub metering", xlab=""))
with(hpower, lines(DateTime, Sub_metering_1, col="black"))
with(hpower, lines(DateTime, Sub_metering_2, col="red"))
with(hpower, lines(DateTime, Sub_metering_3, col="blue"))
legend("topright", lwd=1,
       legend=paste("Sub metering", c(1, 2, 3)), 
       col=c("black", "red", "blue"))
dev.off()
