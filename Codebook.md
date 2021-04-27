# Codebook

## A codebook for the Programming Assignment 4
***Getting and Cleaning Data***


**Note: This codebook describes those data and variables that were used to build the final tidy data set. It modifies and updates the available codebooks with the data to indicate all the variables.** 

For further information on the original data set please refer to the [README](https://github.com/mawoz/ProgrammingAssignment4/blob/main/README.md) file within this [repository](https://github.com/mawoz/ProgrammingAssignment4/) or visit the website were the data was obtained from:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

---
### **Data Processing**

#### Prelude: Data folder content and preparation

The following files can be found in the `/UCI HAR Dataset` folder. 

|File   |Description|
|-------|-----------|
|`activity_labels.txt`    |The file contains six rows of data, where each row contains one activity identifier (`numeric`) and one corresponding activity description (`character`), a text label to associate with the train and test data.
|`features.txt`           |Contains a listing of the 561 different measurements (`character`) taken from the smartphone to analyse the six different activities.
|`subject_test.txt`       |Contains 1 column of data that identifies the subject (i.e. person, as `numeric`) corresponding to each row of data in the test measurement `X_test.txt` file.
|`X_test.txt`             |Contains 561 measurements (`numeric`) for each observed experiment (activity & person).
|`y_test.txt`	          |Contains 1 column of data that identifies the activity (`numeric`) corresponding to each row of data in the test measurement `X_test.txt` file.
|`subject_train.txt`      |Contains 1 column of data that identifies the subject (i.e. person, as `numeric`) corresponding to each row of data in the train measurement `X_train.txt` file.
|`X_train.txt`            |Contains 561 measurements (`numeric`) for each observed experiment (activity & person).
|`y_train.txt`            |Contains 1 column of data that identifies the activity (`numeric`) corresponding to each row of data in the train measurement `X_train.txt` file.

As mentioned on the dataset website, for each record in the dataset it is provided:
> - Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
> - Triaxial Angular velocity from the gyroscope.
> - A 561-feature vector with time and frequency domain variables.
> - Its activity label.
> - An identifier of the subject who carried out the experiment.

During the preparation to process the data in accordance to the course's assignment the data stored within these files is loaded into R using the script.

#### 1. Original data set (training and test sets)
The script combines the training and the test data row-wise to create one data frame. At this point, there is no direct linking to activity or subject (person). 

#### 2. The measurements on the mean and standard deviation (for each measurement)
The script extracts the measurements on the mean and standard deviation for each measurement. In fact, there are further measurements on the mean frequency, indicated by the variable `meanFreq()`, which are not exactly the values we want, and thus were skipped. This is achieved by comparing the vector with features (original variable names) including the character strings `mean()` **or** `std()` as first argument and that vector including the character string `meanFreq()`as second argument of the `setdiff` function.
```{R}
featuresWanted <- setdiff(  grep("mean()|std()", features[,2]),
                            grep("meanFreq()", features[,2]))
```
All in all, there are 66 variables, derived from 33 key measurements from the original data set, one for the mean and one for the standard deviation. 

#### 3. Name the activities appropriately
The script transforms and adds descriptive names for the observed activities. In the original data set activities were spelled all upper case and with underscore where two words needed to be combined. Beforehand the activity labels where stripped of the underscore and transposed to all lower case letters.
```{R}
activityLabels <- read.table(paste0(mainDir, "activity_labels.txt"))
activityLabels[,2] <- tolower(gsub("_", "", activityLabels[,2]))
```
In this third step the now existing data frame containing train and test data was enhanced by the column `activity` reflecting the observed activities in the occurring order taken from the `activity_labels.txt` file. The variable `activity`is converted to type `factor` as well.

#### 4. Labelling the data set with descriptive variable names.
In this step the existing ("wanted") features were adjusted to a more "reader friendly" typing. The following adjustments were made:
```{R}
features[,2][featuresWanted] <- gsub("-mean", "Mean", features[,2][featuresWanted])
features[,2][featuresWanted] <- gsub("-std", "Stdev", features[,2][featuresWanted])
features[,2][featuresWanted] <- gsub("[-()]", "", features[,2][featuresWanted])
features[,2][featuresWanted] <- gsub("^t", "Time", features[, 2][featuresWanted])
features[,2][featuresWanted] <- gsub("^f", "Freq", features[, 2][featuresWanted])
features[,2][featuresWanted] <- gsub("BodyBody", "Body", features[, 2][featuresWanted])
```
Afterwards the columns names of the final data frame were re-named accordingly.

#### 5. Independent tidy data set with the average of each variable for each activity and each subject.
From the data set in step 4, the script creates a second, independent ***tidy*** data set. This is archieved by grouping the data set by subject and by activity and calculating the mean for each of the 180 groups (30 subjects x 6 activities).

```{R}
groupedDF <- wantedDF %>%
        group_by(subject, activity) %>%
        summarize_all(list(~mean(.)))
```
Finally we re-name the column names for the tidy data set by adding the string '`meanOf`'to the features used.

---
### **Tidy data Description**

The tidy data file contains 180 observations, combinations of 30 research subjects and 6 activities. Data consists of the mean across multiple repetitions of physical activities.  A row represents an observation in the tidy data set and is a unique combination of `subject` and `activity`, plus the means for the in ***step 2*** identified 66 variables representing either means or standard deviations of the 33 key features. In the original data, features were normalized to a range from `-1` to `1` resulting in a mean value equally within this range.

|subject    |activity   |meanOfTimeBodyAccMeanX |. . .  |meanOfFreqBodyGyroJerkMagStdev |
|:---------:|:---------:|----------------------:|:------|------------------------------:|
|1          |walking    |0.277330758736842      |. . .  |-0.381601911789474             |
|.          |.          |.                      |.      |.                              |
|.          |.          |.                      |.      |.                              |
|.          |.          |.                      |.      |.                              |

This codebook describes each variable (column) in the tidy data file. In all of the original features, the meaning of the text tokes have a certain meaning.
For easy reference the following ***tokens*** are described to avoid a repetition in the final table with all variables below.

|Token      |Description    |
|-----------|---------------|
|Body       |Signal based on the body of the subject, one of two components derived from the time based signals on the phone's accelerometer
|Freq       |Measurement based on the "frequency" domain, taken as a Fast Fourier Transform of the time-based signals
|Gravity    |Signal based on gravity, second of the two measurement components derived from the phone's accelerometer
|Gyro       |Measurement taken from the gyroscope on the phone
|Jerk       |Measurement of sudden movement, based on body acceleration and angular velocity
|Mag        |Measurement of the magnitude using the Euclidean norm
|Mean       |Indicates that the measurement is a mean within the original Human Activity Recognition data set
|meanOf     |Indicates that the measurement is a mean in the tidy data taken over all experiments for a particular activity, person and feature
|Stdev      |Indicates that the measurement is a standard deviation within the original Human Activity Recognition data set
|Time       |Measurement based on the "time" domain. Measurements taken from the phone were measured at a constant rate of 50Hz.
|X          |Measurement taken along the X axis (3-dimensional)
|Y          |Measurement taken along the Y axis (3-dimensional)
|Z          |Measurement taken along the Z axis (3-dimensional)

>Reference: `features_info.txt` and `features.txt` files from the downloaded data folder.

---
### **Variables in the Course Project Tidy Data Set**

The following table lists all columns (`subject`, `activity` and identified features) in the final result, the tidy data stored in [tidy.txt](https://github.com/mawoz/ProgrammingAssignment4/blob/main/tidy.txt).

|Position   |Column Name       |Type    |Description    |
|-----------|------------------|--------|---------------|
|1          |`subject`         |integer|unique identifier for the participant with a range of `1` to `30`
|2          |`activity`        |character| `walking` \\ `walkingupstairs` \\ `walkingdownstairs` \\ `sitting` \\ `standing` \\ `laying`
|3          |`meanOfTimeBodyAccMeanX`|numeric|mean of the time domain body acceleration means (X axis)
|4          |`meanOfTimeBodyAccMeanY`|numeric|mean of the time domain body acceleration means (Y axis)
|5          |`meanOfTimeBodyAccMeanZ`|numeric|mean of the time domain body acceleration means (Z axis)
|6          |`meanOfTimeBodyAccStdevX`|numeric|mean of the time domain body acceleration standard deviations (X axis)
|7          |`meanOfTimeBodyAccStdevY`|numeric|mean of the time domain body acceleration standard deviations (Y axis)
|8          |`meanOfTimeBodyAccStdevZ`|numeric|mean of the time domain body acceleration standard deviations (Z axis)
|9          |`meanOfTimeGravityAccMeanX`|numeric|mean of the time domain gravity acceleration means (X axis)
|10         |`meanOfTimeGravityAccMeanY`|numeric|mean of the time domain gravity acceleration means (Y axis)
|11         |`meanOfTimeGravityAccMeanZ`|numeric|mean of the time domain gravity acceleration means (Z axis))
|12         |`meanOfTimeGravityAccStdevX`|numeric|mean of the time domain gravity acceleration standard deviations (X axis)
|13         |`meanOfTimeGravityAccStdevY`|numeric|mean of the time domain gravity acceleration standard deviations (Y axis)
|14         |`meanOfTimeGravityAccStdevZ`|numeric|mean of the time domain gravity acceleration standard deviations (Z axis)
|15         |`meanOfTimeBodyAccJerkMeanX`|numeric|mean of the time domain body acceleration jerk means (X axis)
|16         |`meanOfTimeBodyAccJerkMeanY`|numeric|mean of the time domain body acceleration jerk means (Y axis)
|17         |`meanOfTimeBodyAccJerkMeanZ`|numeric|mean of the time domain body acceleration jerk means (Z axis)
|18         |`meanOfTimeBodyAccJerkStdevX`|numeric|mean of the time domain body acceleration jerk standard deviations (X axis)
|19         |`meanOfTimeBodyAccJerkStdevY`|numeric|mean of the time domain body acceleration jerk standard deviations (Y axis)
|20         |`meanOfTimeBodyAccJerkStdevZ`|numeric|mean of the time domain body acceleration jerk standard deviations (Z axis)
|21         |`meanOfTimeBodyGyroMeanX`|numeric|mean of the time domain body gyroscope means (X axis)
|22         |`meanOfTimeBodyGyroMeanY`|numeric|mean of the time domain body gyroscope means (Y axis)
|23         |`meanOfTimeBodyGyroMeanZ`|numeric|mean of the time domain body gyroscope means (Z axis)
|24         |`meanOfTimeBodyGyroStdevX`|numeric|mean of the time domain body gyroscope standard deviations (X axis)
|25         |`meanOfTimeBodyGyroStdevY`|numeric|mean of the time domain body gyroscope standard deviations (Y axis)
|26         |`meanOfTimeBodyGyroStdevZ`|numeric|mean of the time domain body gyroscope standard deviations (Z axis)
|27         |`meanOfTimeBodyGyroJerkMeanX`|numeric|mean of the time domain body gyroscope jerk means (X axis)
|28         |`meanOfTimeBodyGyroJerkMeanY`|numeric|mean of the time domain body gyroscope jerk means (Y axis)
|29         |`meanOfTimeBodyGyroJerkMeanZ`|numeric|mean of the time domain body gyroscope jerk means (Z axis)
|30         |`meanOfTimeBodyGyroJerkStdevX`|numeric|mean of the time domain body gyroscope jerk standard deviations (X axis)
|31         |`meanOfTimeBodyGyroJerkStdevY`|numeric|mean of the time domain body gyroscope jerk standard deviations (Y axis)
|32         |`meanOfTimeBodyGyroJerkStdevZ`|numeric|mean of the time domain body gyroscope jerk standard deviations (Z axis)
|33         |`meanOfTimeBodyAccMagMean`|numeric|mean of the time domain body acceleration magnitude means
|34         |`meanOfTimeBodyAccMagStdev`|numeric|mean of the time domain body acceleration magnitude standard deviations
|35         |`meanOfTimeGravityAccMagMean`|numeric|mean of the time domain gravity acceleration magnitude means
|36         |`meanOfTimeGravityAccMagStdev`|numeric|mean of the time domain gravity acceleration magnitude standard deviation
|37         |`meanOfTimeBodyAccJerkMagMean`|numeric|mean of the time domain body acceleration jerk magnitude means
|38         |`meanOfTimeBodyAccJerkMagStdev`|numeric|mean of the time domain body acceleration jerk magnitude standard deviation
|39         |`meanOfTimeBodyGyroMagMean`|numeric|mean of the time domain body gyroscope magnitude means
|40         |`meanOfTimeBodyGyroMagStdev`|numeric|mean of the time domain body gyroscope magnitude standard deviations
|41         |`meanOfTimeBodyGyroJerkMagMean`|numeric|mean of the time domain body gyroscope jerk magnitude means
|42         |`meanOfTimeBodyGyroJerkMagStdev`|numeric|mean of time domain body gyroscope jerk magnitude standard deviations
|43         |`meanOfFreqBodyAccMeanX`|numeric|mean of the frequency domain body acceleration means (X axis)
|44         |`meanOfFreqBodyAccMeanY`|numeric|mean of the frequency domain body acceleration means (Y axis)
|45         |`meanOfFreqBodyAccMeanZ`|numeric|mean of the frequency domain body acceleration means (Z axis)
|46         |`meanOfFreqBodyAccStdevX`|numeric|mean of the frequency domain body acceleration standard deviations (X axis)
|47         |`meanOfFreqBodyAccStdevY`|numeric|mean of the frequency domain body acceleration standard deviations (Y axis)
|48         |`meanOfFreqBodyAccStdevZ`|numeric|mean of the frequency domain body acceleration standard deviations (Z axis)
|49         |`meanOfFreqBodyAccJerkMeanX`|numeric|mean of the frequency domain body acceleration jerk means (X axis)
|50         |`meanOfFreqBodyAccJerkMeanY`|numeric|mean of the frequency domain body acceleration jerk means (Y axis)
|51         |`meanOfFreqBodyAccJerkMeanZ`|numeric|mean of the frequency domain body acceleration jerk means (Z axis)
|52         |`meanOfFreqBodyAccJerkStdevX`|numeric|mean of the frequency domain body acceleration jerk standard deviations (X axis)
|53         |`meanOfFreqBodyAccJerkStdevY`|numeric|mean of the frequency domain body acceleration jerk standard deviations (Y axis)
|54         |`meanOfFreqBodyAccJerkStdevZ`|numeric|mean of the frequency domain body acceleration jerk standard deviations (Z axis)
|55         |`meanOfFreqBodyGyroMeanX`|numeric|mean of the frequency domain body gyroscope means (X axis)
|56         |`meanOfFreqBodyGyroMeanY`|numeric|mean of the frequency domain body gyroscope means (Y axis)
|57         |`meanOfFreqBodyGyroMeanZ`|numeric|mean of the frequency domain body gyroscope means (Z axis)
|58         |`meanOfFreqBodyGyroStdevX`|numeric|mean of the frequency domain body gyroscope standard deviations (X axis)
|59         |`meanOfFreqBodyGyroStdevY`|numeric|mean of the frequency domain body gyroscope standard deviations (Y axis)
|60         |`meanOfFreqBodyGyroStdevZ`|numeric|mean of the frequency domain body gyroscope standard deviations (Z axis)
|61         |`meanOfFreqBodyAccMagMean`|numeric|mean of the frequency domain body acceleration magnitude means
|62         |`meanOfFreqBodyAccMagStdev`|numeric|mean of the frequency domain body acceleration magnitude standard deviations
|63         |`meanOfFreqBodyAccJerkMagMean`|numeric|mean of the frequency domain body acceleration jerk magnitude means
|64         |`meanOfFreqBodyAccJerkMagStdev`|numeric|mean of the frequency domain body acceleration jerk magnitude standard deviations
|65         |`meanOfFreqBodyGyroMagMean`|numeric|mean of the frequency domain body gyroscope magnitude means
|66         |`meanOfFreqBodyGyroMagStdev`|numeric|mean of the frequency domain body gyroscope magnitude standard deviations
|67         |`meanOfFreqBodyGyroJerkMagMean`|numeric|mean of the frequency domain body gyroscope jerk magnitude means
|68         |`meanOfFreqBodyGyroJerkMagStdev`|numeric|mean of the frequency domain body gyroscope jerk magnitude standard deviations

---

>**Citation Request:**
>Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th >European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013.

---
*last updated 27 April 2021*
