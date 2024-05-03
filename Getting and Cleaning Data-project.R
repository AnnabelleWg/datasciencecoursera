# Getting and Cleaning Data Course Project 

# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Load Packages and get the Data
packages <- c("data.table", "reshape2")
sapply(packages, require, character.only=TRUE, quietly=TRUE)
path <- paste(getwd(),"data", sep="/")
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, file.path(path, "getdata_project_Dataset.zip"))
unzip(zipfile = "./data/getdata_project_Dataset.zip",exdir=path)


# Load activity labels + features
    # fread() is similar to read.table() but faster and more convenient.
library(data.table)
activityLabels <- fread(file.path(path, "UCI HAR Dataset/activity_labels.txt")
                        , col.names = c("classLb", "activityName"))
features <- fread(file.path(path, "UCI HAR Dataset/features.txt")
                  , col.names = c("index", "featureName"))
    # Extract only mean and standard deviation for each measure
featuresWanted <- grep("(mean|std)\\(\\)", features$featureName) # \\ means escaping
measurements <- features[featuresWanted, featureName]
    # to remove "()" from the strings.
measurements <- gsub('[()]', '', measurements)

# Load train datasets
train <- fread(file.path(path, "UCI HAR Dataset/train/X_train.txt"))[, featuresWanted, with = FALSE]
data.table::setnames(train, colnames(train), measurements)
trainActivities <- fread(file.path(path, "UCI HAR Dataset/train/Y_train.txt")
                         , col.names = c("Activity"))
trainSubjects <- fread(file.path(path, "UCI HAR Dataset/train/subject_train.txt")
                       , col.names = c("SubjectNum"))
train <- cbind(trainSubjects, trainActivities, train)

# Load test datasets
test <- fread(file.path(path, "UCI HAR Dataset/test/X_test.txt"))[, featuresWanted, with = FALSE]
data.table::setnames(test, colnames(test), measurements)
testActivities<-fread(file.path(path,"UCI HAR Dataset/test/Y_test.txt"),col.names = "Activity")
testSubjects<-fread(file.path(path, "UCI HAR Dataset/test/subject_test.txt"),col.names = "SubjectNum")
test <- cbind(testSubjects, testActivities, test)

# merge datasets
combined <- rbind(train, test)

# Convert indices labels for the activity column in the combined data set more explicitly using the classLb to activityName in the activityLabels data set.
combined[["Activity"]] <- factor(combined[, Activity]
                                 , levels = activityLabels[["classLb"]]
                                 , labels = activityLabels[["activityName"]])
# factor SubjectNum
combined[["SubjectNum"]] <- as.factor(combined[, SubjectNum])

# To create another data set with the average of each variable for each activity and each subject.
    # transform to long format
combinedNew<-reshape2::melt(combined, id.vars = c("SubjectNum","Activity"),
                            variable.name = "Activity_measure",
                            value.name = "Measurement_value")
    # transform to wide format; cast into a different wide data format
combinedNewW<-reshape2::dcast(combinedNew, SubjectNum+Activity~ Activity_measure,# the arg. on the left refer to the ID variable
                                                                                # the arg. on the right refer to the measured variables.
                              vaule.var="Measurement_value",
                              fun.aggregate=mean)
  
    # fwrite: fast csv writer. As write.csv but much faster
data.table::fwrite(x = combinedNewW, file = "./Data/UCI HAR Dataset/tidyData.txt", quote = FALSE)
