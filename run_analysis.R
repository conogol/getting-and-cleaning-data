# start with a clean slate
rm(list=ls())


# load the needed libraries
library(reshape2)




# if the foldeer exists, the file has already been unzipped so we won't bother unzipping again
if (!file.exists("UCI HAR Dataset")) { 
	
	
	# local filename
	filename <- "proj_dataset.zip"
	
	# if the file doesn't exist locally, we download it
	if (!file.exists(filename)){
		fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
		download.file(fileURL, filename, method="curl")
	}  
	
	unzip(filename) 
}


# We load activity labels 
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
activity_labels[,2] <- as.character(activity_labels[,2])

# extract the measures we want
measures <- read.table("UCI HAR Dataset/features.txt")
measures[,2] <- as.character(measures[,2])

# Get only data for Mean and Std.Dev.

# For this we get the var name and then we add our own suffixes
wanted_measures <- grep(".*mean.*|.*std.*", measures[,2])
wanted_measures.names <- measures[wanted_measures,2]

# We add our suffixes using a simple replacement
wanted_measures.names = gsub('-mean', 'Mean', wanted_measures.names)
wanted_measures.names = gsub('-std', 'StdDev', wanted_measures.names)
wanted_measures.names <- gsub('[-()]', '', wanted_measures.names)


# Okay, now we proceed to load the datasets:

# We load the train data
train <- read.table("UCI HAR Dataset/train/X_train.txt")[wanted_measures]
train_activities <- read.table("UCI HAR Dataset/train/Y_train.txt")
train_subjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(train_subjects, train_activities, train)

# Now we load the test data
test <- read.table("UCI HAR Dataset/test/X_test.txt")[wanted_measures]
test_activities <- read.table("UCI HAR Dataset/test/Y_test.txt")
test_subjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(test_subjects, test_activities, test)



# We merge both datasets 
merged_data <- rbind(train, test)

# Let's add labels
colnames(merged_data) <- c("subject", "activity", wanted_measures.names)


# now we create factors for each column
merged_data$activity <- factor(merged_data$activity, levels = activity_labels[,1], labels = activity_labels[,2])
merged_data$subject <- as.factor(merged_data$subject)

# we melt() to get unique combinations
merged_data.melted <- melt(merged_data, id = c("subject", "activity"))
merged_data.mean <- dcast(merged_data.melted, subject + activity ~ variable, mean)

write.table(merged_data.mean, "tidy.txt", row.names = FALSE, quote = FALSE)




