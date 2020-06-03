library(plyr)
library(data.table)
file.choose()
getwd()
# loading all raw datasets
subjectTrain <- read.table("/Users/connect/Documents/GitHub/cleaningdata/UCI HAR Dataset/train/subject_train.txt", header=FALSE)
xTrain <- read.table("/Users/connect/Documents/GitHub/cleaningdata/UCI HAR Dataset/train/x_train.txt", header=FALSE)
yTrain <- read.table("/Users/connect/Documents/GitHub/cleaningdata/UCI HAR Dataset/train/y_train.txt", header=FALSE)
subjectTest <- read.table('/Users/connect/Documents/GitHub/cleaningdata/UCI HAR Dataset/test/subject_test.txt',header=FALSE)
xTest <- read.table('/Users/connect/Documents/GitHub/cleaningdata/UCI HAR Dataset/test/x_test.txt',header=FALSE)
yTest <- read.table('/Users/connect/Documents/GitHub/cleaningdata/UCI HAR Dataset/test/y_test.txt',header=FALSE)

# combining raw datasets
xData <- rbind(xTrain, xTest)
yData <- rbind(yTrain, yTest)
subjectData <- rbind(subjectTrain, subjectTest)
names(subjectData)

# extract only the "mean" and "std" variables according to features.txt
xData_mean_std <- xData[, grep("-(mean|std)\\(\\)", read.table("/Users/connect/Documents/GitHub/cleaningdata/UCI HAR Dataset/features.txt")[, 2])]
# assign names to the variables according to features.txt
names(xData_mean_std) <- read.table("/Users/connect/Documents/GitHub/cleaningdata/UCI HAR Dataset/features.txt")[grep("-(mean|std)\\(\\)", read.table("/Users/connect/Documents/GitHub/cleaningdata/UCI HAR Dataset/features.txt")[, 2]), 2] 

# Use descriptive activity names to name the activities in the data set
yData[, 1] <- read.table("/Users/connect/Documents/GitHub/cleaningdata/UCI HAR Dataset/activity_labels.txt")[yData[, 1], 2]
names(yData) <- "Activity"

# label dataset with descriptive activity names
names(subjectData) <- "Subject"

# combine all datasets into a single dataset
singleData <- cbind(xData_mean_std, yData, subjectData)
names(singleData) <- make.names(names(singleData))
names(singleData) <- gsub('^f',"FrequencyDomain.",names(singleData))
names(singleData) <- gsub('\\.mean',".Mean",names(singleData))
names(singleData) <- gsub('\\.std',".StandardDeviation",names(singleData))
names(singleData) <- gsub('Acc',"Acceleration",names(singleData))
names(singleData) <- gsub('GyroJerk',"AngularAcceleration",names(singleData))
names(singleData) <- gsub('^t',"TimeDomain.",names(singleData))
names(singleData) <- gsub('Freq\\.',"Frequency.",names(singleData))
names(singleData) <- gsub('Gyro',"AngularSpeed",names(singleData))
names(singleData) <- gsub('Mag',"Magnitude",names(singleData))
names(singleData) <- gsub('Freq$',"Frequency",names(singleData))

newdata <-aggregate(. ~Subject + Activity, singleData, mean)
newdata <-newdata[order(newdata$Subject, newdata$Activity),]
write.table(newdata, file = "tidydata.txt",row.name=FALSE)
