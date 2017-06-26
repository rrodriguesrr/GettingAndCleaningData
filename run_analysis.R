
## Setting the working directory
setwd("C:/Users/rrodriguesrr/Documents/Courses/Data Science/3 - Getting and Cleaning Data/WorkDirectory/data/Assignment")


## Downloading the ZIP file
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, "UCI-HAR-dataset.zip")
unzip("UCI-HAR-dataset.zip")

## 1. Merges the training and the test sets to create one data set.

Xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
Xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")
Xmerge <- rbind(Xtrain, Xtest)

Ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt")
Ytest <- read.table("./UCI HAR Dataset/test/y_test.txt")
Ymerge <- rbind(Ytrain, Ytest)

subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
subject_merge <- rbind(subject_train, subject_test)


## 2. Extracts only the measurements on the mean and standard deviation for each measurement.

features <- read.table("./UCI HAR Dataset/features.txt")
measurements <- grep("mean\\(\\)|std\\(\\)", features$V2) ## Getting the variables indexes
mean_sd <- Xmerge[, measurements] #Extracting from the Xmerge dataset (means and sd variables)

## 3. Uses descriptive activity names to name the activities in the data set

activities <- read.table("./UCI HAR Dataset/activity_labels.txt")
Ymerge[,1] <- activities[Ymerge[, 1], 2]
names(Ymerge) <- "activity"

## 4. Appropriately labels the data set with descriptive variable names.

names(mean_sd) <- features[measurements, 2]
names(subject_merge) <- "subject_id"
dataset <- cbind(subject_merge, Ymerge, mean_sd)

## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

TidyDataset <- dataset %>% 
    group_by(subject_id, activity) %>% 
    summarise_all(funs(mean))

write.table(TidyDataset, "TidyDataset.txt", row.names = FALSE)
