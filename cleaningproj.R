library(plyr)
library(data.table)

# loading all raw datasets
subjectTrain <- read.table("./train/subject_train.txt", header=FALSE)
xTrain <- read.table("./train/x_train.txt", header=FALSE)
yTrain <- read.table("./train/y_train.txt", header=FALSE)
subjectTest <- read.table('./test/subject_test.txt',header=FALSE)
xTest <- read.table('./test/x_test.txt',header=FALSE)
yTest <- read.table('./test/y_test.txt',header=FALSE)

# combining raw datasets
xDataset <- rbind(xTrain, xTest)
yDataset <- rbind(yTrain, yTest)
subjectDataset <- rbind(subjectTrain, subjectTest)
names(subjectDataset)

# extract only the "mean" and "std" variables according to features.txt
xDataset_mean_std <- xDataset[, grep("-(mean|std)\\(\\)", read.table("features.txt")[, 2])]
# assign names to the variables according to features.txt
names(xDataset_mean_std) <- read.table("features.txt")[grep("-(mean|std)\\(\\)", read.table("features.txt")[, 2]), 2] 
View(xDataset_mean_std)

# Use descriptive activity names to name the activities in the data set
yDataset[, 1] <- read.table("activity_labels.txt")[yDataSet[, 1], 2]
names(yDataset) <- "Activity"
View(yDataset)

# label dataset with descriptive activity names
names(subjectDataSet) <- "Subject"



