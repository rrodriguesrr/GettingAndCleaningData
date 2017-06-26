# GettingAndCleaningData

## This repository includes the following files:
=========================================

* 'README.txt';

* CodeBook.md: This files includes all the informartion about the TidyDataset.txt file and the R Code used in order to generate the Dataset;

* TidyDataset.txt: A copy of the TidyDataset in text file format;

* run_analysis.R: The R code used to generate the TidyDataset.

## How the script works (Also included in the CoodBook.md file)

## R Code

The following R Code was built in order to create the TidyDataset.txt file

1. Setting up the work directory:
```R
## Setting the working directory
setwd("C:/Users/rrodriguesrr/Documents/Courses/Data Science/3 - Getting and Cleaning Data/WorkDirectory/data/Assignment")
```

2. Downloading and unzipping the files from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

```R
## Downloading the ZIP file
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, "UCI-HAR-dataset.zip")
unzip("UCI-HAR-dataset.zip")
```

3. Merges the training and the test sets to create one data set.

```R
Xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
Xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")
Xmerge <- rbind(Xtrain, Xtest)

Ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt")
Ytest <- read.table("./UCI HAR Dataset/test/y_test.txt")
Ymerge <- rbind(Ytrain, Ytest)

subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
subject_merge <- rbind(subject_train, subject_test)
```

4. Extracts only the measurements on the mean and standard deviation for each measurement.

```R
features <- read.table("./UCI HAR Dataset/features.txt")
measurements <- grep("mean\\(\\)|std\\(\\)", features$V2) ## Getting the variables indexes
mean_sd <- Xmerge[, measurements] #Extracting from the Xmerge dataset (means and sd variables)
```

5. Uses descriptive activity names to name the activities in the data set

```R
activities <- read.table("./UCI HAR Dataset/activity_labels.txt")
Ymerge[,1] <- activities[Ymerge[, 1], 2]
names(Ymerge) <- "activity"
```

6. Appropriately labels the data set with descriptive variable names.

```R
names(mean_sd) <- features[measurements, 2]
names(subject_merge) <- "subject_id"
dataset <- cbind(subject_merge, Ymerge, mean_sd)
```

7. From the data set in the step above, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

```R
TidyDataset <- dataset %>% 
    group_by(subject_id, activity) %>% 
    summarise_all(funs(mean))

## Tidy File submitted
write.table(TidyDataset, "TidyDataset.txt", row.names = FALSE)
```