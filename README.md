# ProgrammingAssignment4

A repository for the Programming Assignment 4 from the *Getting And Cleaning Data* course offered by Johns Hopkins University's School of Public Health hosted on Coursera. The Objective of the course project is to demonstrate the ability to clean a pre-collected data set and to convert this into a ***tidy*** format.

---

## Course Project: Wearable Computing

The data was collected from 30 individuals' Samsung Galaxy S smartphones and the built-in accelerometers.

>The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

>The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

A full description is available at the site where the data was obtained: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

---

## Contents

This [repository](https://github.com/mawoz/ProgrammingAssignment4/) hosts the following files:

| file    | description |
| --------|-------------|   
| [run_analysis.R](https://github.com/mawoz/ProgrammingAssignment4/blob/main/run_analysis.R)| R script to perform the analysis|
| [README.md](https://github.com/mawoz/ProgrammingAssignment4/blob/main/README.md)| this README file with a general overview on the analysis, workflow and requirements|
| [Codebook.md](https://github.com/mawoz/ProgrammingAssignment4/blob/main/Codebook.md)| a CODEBOOK file that modifies and updates existing codebooks with the data to indicate all the variables and summaries calculated |
| [tidy.txt](https://github.com/mawoz/ProgrammingAssignment4/blob/main/tidy.txt)| independent tidy data set with the average of each variable for each activity and each subject|

*Please note: the independent tidy data set 'tidy.txt' was also uploaded on the course's website on Coursera as part of the submission. I included the file in this  repository for easy reference.*

---

## Workflow

Following the instructions given the R script does (must do) the following:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

---

## Requirements
The script requires the R package 'dplyr'. As this should be installed on almost every system running R, I refused to install this package automatically. It will only be loaded if it was installed previously. To install the package manually use the following code:

    install.packages('dplyr')

There is no need to download the original data set from the UCI site manually, as the R script checks whether there is the zip file called 'Dataset.zip' in your working directory or a folder called '/UCI HAR Dataset'. It should be clear that this is no *real* evidence for the data set being in the right place, especially when the original zip file is named otherwise. This routine was only implemented to prevent from downloading the full data set with every iteration / repetition of this script. So if neither can be found, the script initiates the download and then unzips the data set into the folder '/UCI HAR Dataset'.

---

*last updated 21 April 2021*
