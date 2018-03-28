#### The R script, _run_analysis.R_, does the following:
1. Downloads the zip file if it does not already exist in the working directory.
2. Unzips the zip file.
3. Reads training, testing, activity_labels and features file and updates the column names.
4. Merges training and testing files into a single file.
5. Extracts mean and standard deviation variables for each measurement.
6. Left joins with activity_labels file to get descriptive activity names.
7. Creates a tidy data set with the average of each variable grouped by activity and subject.
8. Writes the tidy data set to tidy_data.txt file in the working directory.
