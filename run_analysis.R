# Getting and Cleaning Data
# Peer-graded Assignment
#
# Course Project: Wearable Computing
#
# Data is collected from the accelerometers from the Samsung Galaxy S smartphone.
# A full description is available at the site where the data was obtained:
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
#
#
# This R script does the following:
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each 
#    measurement.
# 3. Uses descriptive activity names to name the activities in the data set.
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with
#    the average of each variable for each activity and each subject.
#

# Libraries
library(dplyr)

# Source
zipUrl = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

mainDir <- "UCI HAR Dataset/"
testDir <- "UCI HAR Dataset/test/"
trainDir <- "UCI HAR Dataset/train/"

# Retrieve zip file and unpack data
if (!file.exists("Dataset.zip")) {
        print("Downloading dataset...")
        download.file(zipUrl, destfile = "Dataset.zip", method = "curl")
        dateDownloaded <- date()
        #print("...DONE")
                } else {
                        print("Dataset already downloaded.")
}
if (!file.exists(mainDir)) {
        print("Unzipping data...")
        unzip("Dataset.zip")
        #print("...DONE")
                } else {
                        print("Dataset already unzipped.")
}

# Import Data - Presets
print("Importing data...")
activityLabels <- read.table(paste0(mainDir, "activity_labels.txt"))
activityLabels[,2] <- tolower(gsub("_", "", activityLabels[,2]))

features <- read.table(paste0(mainDir, "features.txt"),
                       stringsAsFactors = FALSE,
                       header = FALSE)
featuresOrig <- features

testSubjects <- as.numeric(readLines(paste0(testDir, "subject_test.txt")))
testLabels <- readLines(paste0(testDir, "y_test.txt"))
testData <- read.table(paste0(testDir, "X_test.txt"))

trainSubjects <- as.numeric(readLines(paste0(trainDir, "subject_train.txt")))
trainLabels <- readLines(paste0(trainDir, "y_train.txt"))
trainData <- read.table(paste0(trainDir, "X_train.txt"))
#print("...DONE")

# Step 1        Merges the training and the test sets to create one data set.
print("Step 1... Merges the training and the test sets to create one data set.")
DF <- rbind(testData, trainData)
#print("...DONE")

# Step 2        Extracts only the measurements on the mean and standard
#               deviation for each measurement.
print("Step 2... Extracts only mean and standard deviation for each measurement,")
print("...and ignores all meanFreq() measurements.")
#featuresWanted <- grep("mean()|std()", features[,2])
#featuresNotWanted <- grep("meanFreq()", features[,2])
featuresWanted <- setdiff(grep("mean()|std()", features[,2]),
                               grep("meanFreq()", features[,2]))
                               
wantedDF <- DF[featuresWanted]
#print("...DONE")

# Step 3        Uses descriptive activity names to name
#               the activities in the data set.
print("Step 3... Applying descriptive activity names.")
wantedDF <- cbind(activity = c(testLabels, trainLabels), wantedDF)
wantedDF <- cbind(subject = c(testSubjects, trainSubjects), wantedDF)

wantedDF$activity <- factor(wantedDF$activity, 
                            levels = activityLabels[,1],
                            labels = activityLabels[,2])
#print("...DONE")

# Step 4        Appropriately labels the data set with
#               descriptive variable names.
print("Step 4... Labeling data set with descriptive variable names.")
features[,2][featuresWanted] <- gsub("-mean", "Mean", features[,2][featuresWanted])
features[,2][featuresWanted] <- gsub("-std", "Stdev", features[,2][featuresWanted])

features[,2][featuresWanted] <- gsub("[-()]", "", features[,2][featuresWanted])

features[,2][featuresWanted] <- gsub("^t", "Time", features[, 2][featuresWanted])
features[,2][featuresWanted] <- gsub("^f", "Freq", features[, 2][featuresWanted])

features[,2][featuresWanted] <- gsub("BodyBody", "Body", features[, 2][featuresWanted])

colnames(wantedDF) <- c("subject", "activity", features[,2][featuresWanted])
#print("...DONE")

# Step 5        From the data set in step 4, creates a second, independent
#               tidy data set with the average of each variable for each
#               activity and each subject.
print("Step 5... Creating independent tidy data set with averages.")
groupedDF <- wantedDF %>%
        group_by(subject, activity) %>%
        summarize_all(list(~mean(.)))

print("... and re-labeling the column names by adding 'meanOf'.")
oldColNames <- colnames(groupedDF)
newColNames <- sapply(oldColNames, function(x) {paste("meanOf",x,sep="")})

colnames(groupedDF) <- newColNames
colnames(groupedDF)[1:2] <- oldColNames[1:2]


#print("...DONE")

# Save tidy data to disk
print("Saving tidy data to txt file and emptying environment...")
write.table(groupedDF, "tidy.txt", row.names = FALSE, quote = FALSE)
rm(list = ls())
#print("...DONE")

# Read tidy data into R - to double-check functionality
print("Loading tidy data into R to check format...")
tidyData <- read.table("tidy.txt", header = TRUE)
View(tidyData)
print("...SUCCESS")


