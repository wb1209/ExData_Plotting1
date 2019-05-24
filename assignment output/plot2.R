# 
# Note: this script downloads and unzips the file retrieved from https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip
# The data will be downloaded in a subdirectory of the working directory called data
# The plot will be saved to the working directory 
#
#
#----------DOWNLOAD, UNZIP AND READ DATA-----------------------------------------------------------------

# Create directory which the data will be downloaded to if it doesn't already exists
if(!file.exists("./data")) {
    dir.create ("./data")
}

# Download and extract files if the file has not been downloaded already
if(!file.exists("./data/dataset.zip")){
    
    # Download file
    fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(fileUrl,"./data/dataset.zip",method = "curl")
    
    #extract file
    unzip("./data/dataset.zip",exdir = "./data") 
} 

data <- read.table("./data/household_power_consumption.txt",header=TRUE,sep = ";",stringsAsFactors = FALSE)



#----------FILTER DATA AND DATA PREPARATION---------------------------------------------------------------

#Add DataTime Variable as POSIXlt format
data$DateTime <- strptime(paste(data$Date,data$Time),format = "%d/%m/%Y %H:%M:%S")

#To ensure days are presented in English despite settings. Original setting are restored

old_locale <- Sys.getlocale(category = "LC_TIME")
Sys.setlocale("LC_TIME", "en_US")
data$Day <- weekdays(data$DateTime)
Sys.setlocale(category = "LC_TIME",old_locale)

#Convert datatypes, "?" in data will be converted to NA values hence the warnings
data$Date <- as.Date(as.character(data$Date),"%d/%m/%Y")
data$Global_active_power <- as.numeric(data$Global_active_power)
data$Global_reactive_power <- as.numeric(data$Global_reactive_power,na.omit =TRUE)
data$Voltage <- as.numeric(data$Voltage,na.omit=TRUE)
data$Global_intensity <- as.numeric(data$Global_intensity,na.omit=TRUE)
data$Sub_metering_1 <- as.numeric(data$Sub_metering_1,na.omit=TRUE)
data$Sub_metering_2 <- as.numeric(data$Sub_metering_2,na.omit=TRUE)

#Only select 2007-02-01 and 2007-02-02
data <-data[data$Date == "2007-02-01"|data$Date == "2007-02-02",]



#----------CREATE PLOT------------------------------------------------------------------------------------


#To ensure days are presented in English
old_locale <- Sys.getlocale(category = "LC_TIME")
Sys.setlocale("LC_TIME", "en_US")

#Create plot
png(file="plot2.png")
plot(data$DateTime,data$Global_active_power,type="n",ylab = "Global Active Power (kilowatts)",xlab="")
lines(data$DateTime,data$Global_active_power,type="l")
dev.off()

#Return to original setting
Sys.setlocale(category = "LC_TIME",old_locale)
