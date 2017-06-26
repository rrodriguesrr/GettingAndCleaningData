# Getting and Cleaning Data - Program Assignment

## Code Book

This code book summarizes intends to indicate all the variables and summaries calculated, along with units, and any other relevant information

## Source

Jorge L. Reyes-Ortiz(1,2), Davide Anguita(1), Alessandro Ghio(1), Luca Oneto(1) and Xavier Parra(2)
1 - Smartlab - Non-Linear Complex Systems Laboratory
DITEN - Università degli Studi di Genova, Genoa (I-16145), Italy. 
2 - CETpD - Technical Research Centre for Dependency Care and Autonomous Living
Universitat Politècnica de Catalunya (BarcelonaTech). Vilanova i la Geltrú (08800), Spain
activityrecognition '@' smartlab.ws

## Dataset Information

* File name: TidyDataset.txt
* 180 observations;
* 68 variables;

## Variables

### Categorical

* subject_id: An identifier of the subject who carried out the experiment;
* activity: Activity name.

### Numeric

* tBodyAcc-mean()-X
* tBodyAcc-mean()-Y
* tBodyAcc-mean()-Z
* tBodyAcc-std()-X
* tBodyAcc-std()-Y
* tBodyAcc-std()-Z
* tGravityAcc-mean()-X
* tGravityAcc-mean()-Y
* tGravityAcc-mean()-Z
* tGravityAcc-std()-X
* tGravityAcc-std()-Y
* tGravityAcc-std()-Z
* tBodyAccJerk-mean()-X
* tBodyAccJerk-mean()-Y
* tBodyAccJerk-mean()-Z
* tBodyAccJerk-std()-X
* tBodyAccJerk-std()-Y
* tBodyAccJerk-std()-Z
* tBodyGyro-mean()-X
* tBodyGyro-mean()-Y
* tBodyGyro-mean()-Z
* tBodyGyro-std()-X
* tBodyGyro-std()-Y
* tBodyGyro-std()-Z
* tBodyGyroJerk-mean()-X
* tBodyGyroJerk-mean()-Y
* tBodyGyroJerk-mean()-Z
* tBodyGyroJerk-std()-X
* tBodyGyroJerk-std()-Y
* tBodyGyroJerk-std()-Z
* tBodyAccMag-mean()
* tBodyAccMag-std()
* tGravityAccMag-mean()
* tGravityAccMag-std()
* tBodyAccJerkMag-mean()
* tBodyAccJerkMag-std()
* tBodyGyroMag-mean()
* tBodyGyroMag-std()
* tBodyGyroJerkMag-mean()
* tBodyGyroJerkMag-std()
* fBodyAcc-mean()-X
* fBodyAcc-mean()-Y
* fBodyAcc-mean()-Z
* fBodyAcc-std()-X
* fBodyAcc-std()-Y
* fBodyAcc-std()-Z
* fBodyAccJerk-mean()-X
* fBodyAccJerk-mean()-Y
* fBodyAccJerk-mean()-Z
* fBodyAccJerk-std()-X
* fBodyAccJerk-std()-Y
* fBodyAccJerk-std()-Z
* fBodyGyro-mean()-X
* fBodyGyro-mean()-Y
* fBodyGyro-mean()-Z
* fBodyGyro-std()-X
* fBodyGyro-std()-Y
* fBodyGyro-std()-Z
* fBodyAccMag-mean()
* fBodyAccMag-std()
* fBodyBodyAccJerkMag-mean()
* fBodyBodyAccJerkMag-std()
* fBodyBodyGyroMag-mean()
* fBodyBodyGyroMag-std()
* fBodyBodyGyroJerkMag-mean()
* fBodyBodyGyroJerkMag-std()

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

##Author

Rubens Rodrigues
Linkedin: https://www.linkedin.com/in/rrodriguesrr/
