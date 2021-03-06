#create dataframes
features <- read.table("UCI HAR Dataset/features.txt",
                       col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt",
                         col.names = c("code","activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt",
                           col.names = "subject")
X_test <- read.table("UCI HAR Dataset/test/X_test.txt",
                     col.names = features$functions)
Y_test <- read.table("UCI HAR Dataset/test/y_test.txt",
                     col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt",
                        col.names = "subject")
X_train <- read.table("UCI HAR Dataset/train/X_train.txt",
                      col.names = features$functions)
Y_train <- read.table("UCI HAR Dataset/train/y_train.txt",
                      col.names = "code")

#merge different dataframes
X <- rbind(X_train,X_test)
Y <- rbind(Y_train,Y_test)
subject <- rbind(subject_train,subject_test)
whole <- cbind(subject,Y,X)

#extract mean and standard deviation
library(dplyr)
msd <- select(whole,subject,code,
              contains("mean")|contains("std"))

#Uses descriptive activity names to name the activities in the data set
msd$code <- activities[msd$code,2] 

#Appropriately labels the data set with descriptive variable names. 
nm <- names(msd)
nm[2] <- "activity"
nm <- gsub("^t","Time",nm)
nm <- gsub("^f","Frequency",nm)
nm <- gsub("angle.t","AngleFrequency",nm)
nm <- gsub("Acc","Accelerometer",nm)
nm <- gsub("Gyro","Gyroscope",nm)
nm <- gsub("Mag","Magnitude",nm)
names(msd) <- nm

#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(tidyr)
newmsd <- group_by(msd,activity,subject) %>%
    summarize_all(mean)
write.table(newmsd,file = "tidydata",row.names = FALSE)
