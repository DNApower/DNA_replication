# libraries
library(data.table)
library(dplyr)
library(tidyr)
# Set the working directory
setwd("~/Documents/lab/codes")
filename = readline('Microarray data file name:  ')
# Read microarray data
mydata<-fread(filename, header = TRUE)
# Isolate the target columns
df <- mydata[, c(10,12,23,24,33,34,43,44)]
# Rename the columns
colnames(df) = c("ProbeName", "SystematicName", "gProcessedSignal", "rProcessedSignal", "gMedianSignal", "rMedianSignal", "gBGMedianSignal", "rBGMedianSignal")
# Remove the non-nuclear chromsome info
df = df[-1,]
df <- df[order(df[,2])]
df <- df[3445:44924]
# Create Chr, Start, and End columns
df <- df %>% separate(col = SystematicName, c("Chr", "a"), ":")
df <- df %>% separate(col = a, c("Start", "End"), "-")
df$Chr <- substring(df$Chr, 4)
df <- transform(df, Chr = as.numeric(Chr), Start = as.numeric(Start),End = as.numeric(End), gProcessedSignal = as.numeric(gProcessedSignal),rProcessedSignal = as.numeric(rProcessedSignal))
# Calulate the Mid coordinate
df$Mid <- ceiling((df$Start + df$End)/2)
# output filename
outputfilename = readline('Output file name:  ')
# write output file
write.table(df, sprintf("%s_edited.txt", outputfilename), sep = "\t", row.names = FALSE)