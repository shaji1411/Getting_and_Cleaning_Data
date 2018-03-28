# Load libraries
library(dplyr)
library(stringr)

# a. Check if directory existis and download the file
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

# b. Unzip data
unzip(zipfile="./data/Dataset.zip",exdir="./data")

# c. Read files & and add Column Names
# features file:
features <- read.table('./data/UCI HAR Dataset/features.txt', col.names = c("id", "column_names"))

features$column_names %>%
  str_replace_all("-", "_") %>%
  str_replace_all(",", "_") %>%
  str_replace_all("\\(\\)", "") -> column_names

# train files:
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

names(x_train) <- column_names
names(y_train) <-"activity_id"
names(subject_train) <- "subject_id"

# test files:
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

names(x_test) <- column_names 
names(y_test) <-"activity_id"
names(subject_test) <- "subject_id"

# activity file:
activity_labels = read.table('./data/UCI HAR Dataset/activity_labels.txt')

names(activity_labels) <- c('activity_id','activity_type')

# 1. Merge the training and the test sets to create one data set.
train_data <- bind_cols(subject_train, y_train, x_train)
test_data <- bind_cols(subject_test, y_test, x_test)
full_data <- bind_rows(train_data, test_data)

# 2. Extract only the measurements on the mean and standard deviation for each measurement
full_data_mean_std <- select(full_data, subject_id, activity_id, matches("mean|std", ignore.case = FALSE))

# 3. Use descriptive activity names to name the activities in the data set 
full_data_mean_std %>%
  left_join(activity_labels, by = "activity_id") %>% 
  select(c(1, 82, 3:81)) -> full_data_activity

# 4. Appropriately labels the data set with descriptive variable names.
# Already done while reading files

# 5. Create a second, independent tidy data set with the average of each variable for each activity and each subject
full_data_activity %>%
  group_by(activity_type, subject_id) %>%
  summarise_all(mean) -> tidy_data

# write the output to .txt file
write.table(tidy_data, "tidy_data.txt", row.names = FALSE)