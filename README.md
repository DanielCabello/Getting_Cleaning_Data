GETTING AND CLEANING DATA COURSE PROJECT: SCRIPT
=====================

# Description of the script: run_analysis.R

This script produces three tidy datasets from the raw data of the project "Human Activity Recognition Using Smartphones Dataset".  The datasets are saved as txt files.

1. HumanActivity - The main dataset, it was constructed from the raw data of the project (steps 1, 3 and 4).
2. HumanActivity_mean-std- tidy dataset with the variables containing means and standard deviations extracted from 'HumanActivity" (step 2)
3. HumanActivity_mean - Tidy dataset with the average of each variable for each activity and each subject, calculated from dataset 'HumanActivity" (step 5)

 The code assumes that the folder containing the raw data from the project (UCI HAR Dataset) is located in the working directory in R, without changing the original file structure. The raw data files can be downloaded in the link:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

The structure of the script follow the steps to carry out according to the requirements of the course project:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 


The script 'run_analysis.R' contains detailed explanations of each step taken in the elaboration of the tidy datasets.


# Description of the research project

A detailed description of the research project and the variables analyzed in the study can be found in the file 'README.txt" located in the folder 'UCI HAR Dataset'. You can also see a description in the file 'CodeBook.md' located in the repository: https://github.com/DanielCabello/Getting_Cleaning_Data.

 
