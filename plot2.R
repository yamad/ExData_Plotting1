## Plot global active power over time, save to PNG

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
png("plot2.png", height=480, width=480)
plot(hpower$DateTime, hpower$Global_active_power, type="l",
     ylab="Global Active Power (kilowatts)", xlab="")
dev.off()
