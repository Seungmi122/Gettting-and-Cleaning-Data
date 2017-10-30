url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
f <- file.path(getwd(),'UCI HAR Dataset.zip')
download.file(url, f)
unzip('UCI HAR Dataset.zip')
## creat 'test' data 
subject_test <- read.table('UCI HAR Dataset/test/subject_test.txt')
X_test <- read.table('UCI HAR Dataset/test/X_test.txt')
y_test <- read.table('UCI HAR Dataset/test/y_test.txt')
test <- cbind(subject_test, X_test, y_test)
## create 'train' data
subject_train <- read.table('UCI HAR Dataset/train/subject_train.txt')
X_train <- read.table('UCI HAR Dataset/train/X_train.txt')
y_train <- read.table('UCI HAR Dataset/train/y_train.txt')
train <- cbind(subject_train, X_train, y_train)

##Merges the training and the test sets to create one data set.
data <- rbind(test, train)

##Extracts only the measurements on the mean and standard deviation for each measurement.
features <- read.table('UCI HAR Dataset/features.txt')
activitylabels <- read.table('UCI HAR Dataset/activity_labels.txt')
colnames(data) <- c('subject',as.character(features),'activity')
meanstd <- grep("mean|std",colnames(data))
extracted_data <- data[,c(1,meanstd,563)]

##Uses descriptive activity names to name the activities in the data set
extracted_data$activity <- factor(extracted_data$activity,labels = activitylabels)

##Appropriately labels the data set with descriptive variable names.
newcol <- colnames(extracted_data)
newcol <- gsub('[()-]','',newcol)
newcol <- gsub('^f','frequency',newcol)
newcol <- gsub('^t','time',newcol)
newcol <- gsub('Acc','Accelerometer',newcol)
newcol <- gsub('Gyro','gyroscope',newcol)
newcol <- gsub('BodyBody','Body',newcol)
colnames(extracted_data) <- newcol

##From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


library(reshape2)
dataMelt <- melt(extracted_data, id = c("subject", "activity"))
tidyData <- dcast(dataMelt, subject + activity ~ variable, mean)
write.table(tidyData, "tidy.txt",  row.names = FALSE, 
            quote = FALSE)















						