

##Get Data, Dowload URL

setwd("D:/Coursera Esp/Getting and Cleaning Data/")


library(plyr)
library(data.table)
fileurldata <-  'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
if (!file.exists('./UCI HAR Dataset.zip')){
  download.file(fileurldata,'./UCI HAR Dataset.zip', mode = 'wb')
  unzip("UCI HAR Dataset.zip", exdir = getwd())
}

##Read & Merge data (Merges the training and the test sets to create one data set)

setwd("D:/Coursera Esp/Getting and Cleaning Data/UCI HAR Dataset/")

subTraining <- read.table('./train/subject_train.txt',header=FALSE)
xTraining <- read.table('./train/x_train.txt',header=FALSE)
yTraining <- read.table('./train/y_train.txt',header=FALSE)

subTest <- read.table('./test/subject_test.txt',header=FALSE)
data.test.y <- read.table('./test/y_test.txt', header = FALSE)
data.test.x <- read.table('./test/X_test.txt', header = FALSE)

xData <- rbind(xTraining, data.test.x)
yData <- rbind(yTraining, data.test.y)
subjectData <- rbind(subTraining, subTest)

## Data dimension
dim(xData)
dim(yData)
dim(subjectData)

##Extracts only the measurements on the mean and standard deviation for each measurement



xData_mean <- xData [, grep("-(mean|std)\\(\\)", read.table("features.txt")[, 2])]
names(xData_mean) <- read.table("features.txt")[grep("-(mean|std)\\(\\)", read.table("features.txt")[, 2]), 2]


##Uses descriptive activity names to name the activities in the data set

yData[, 1] <- read.table("activity_labels.txt")[yData[, 1], 2]

names(yData) <- "Activity"
names(subjectData) <- "Subject"

compdata <- cbind(xData_mean,yData,subjectData)


##Appropriately labels the data set with descriptive variable names.

names(compdata) <- make.names(names(compdata))
names(compdata) <- gsub("GyroJerk","AngularAcceleration",names(compdata))
names(compdata) <- gsub("^t", "TimeDomain", names(compdata))
names(compdata) <- gsub("^f", "FrequencyDomain", names(compdata))
names(compdata) <- gsub("Acc", "Accelerometer", names(compdata))
names(compdata) <- gsub("Gyro", "Gyroscope", names(compdata))
names(compdata) <- gsub("Mag", "Magnitude", names(compdata))
names(compdata) <- gsub("-mean-", "Mean", names(compdata))
names(compdata) <- gsub("-std-", "StandardDeviation", names(compdata))

##From the data set in step 4, creates a second, 
##independent tidy data set with the average of each variable for each activity and each subject.

Finaldata<-aggregate(. ~Subject + Activity, compdata, mean)
Finaldata<-Finaldata[order(Finaldata$Subject,Finaldata$Activity),]
write.table(Finaldata, file = "Final_tidydata.txt",row.name=FALSE)
