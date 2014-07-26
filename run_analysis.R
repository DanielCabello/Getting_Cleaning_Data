##  GETTING AND CLEANING DATA COURSE PROJECT: SCRIPT

###
# This code produces three tidy database from the raw data located in the link:
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
#   
#   1. HumanActivity  (steps 1, 3 and 4)
#   2. HUmanActivity_mean-std  (step 2)
#   3. HumanActivity_mean  (step 5)
#
# The code assumes that the folder containing the raw data from the project (UCI HAR Dataset) 
# is located in the working directory in R, without changing the original file structure.
###



# STEPS

# 1. Merges the training and the test sets to create one data set.

    # 1.1 Reading and Merging Training Datasets

        # reading Subjects
        x_1 <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = "subjects")
            
            # a column is added to indicate that these individuals belong to the training
            x_1 <- cbind(x_1, "train-test" = as.character(rep("train", nrow(x_1))))  
        
        # reading Activities
        x_2 <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names = "activities")
        
        # reading Calculated variables from raw data
        x_3 <- read.table("./UCI HAR Dataset/train/x_train.txt",colClasses = "numeric")
    
        # merging training datasets
        train <- cbind(x_1, x_2, x_3)
        rm(x_1,x_2,x_3)
    
  
    # 1.2 Reading and Merging Test Datasets

        # reading Subjects
        xt_1 <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = "subjects")
            
            # a column is added to indicate that these individuals belong to the training    
            xt_1 <- cbind(xt_1, "train-test" = as.character(rep("test", nrow(xt_1))))
        
        # reading Activities
        xt_2 <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names = "activities")
        
        # reading Calculated variables from raw data
        xt_3 <- read.table("./UCI HAR Dataset/test/x_test.txt",colClasses = "numeric")
        
        # merging training datasets
        test <- cbind(xt_1, xt_2, xt_3)
        rm(xt_1,xt_2,xt_3)
    
 
    # 1.3 Merging training and test datasets
    HumanActivity <- rbind(train, test)
    

    # 1.4 deleting variables created in step 1, except the database obtained 'HumanActivity'
    rm(train, test)


 
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.

    # 2.1 reading file 'features.txt' (measurements names)    
    features <- read.table("./UCI HAR Dataset/features.txt", colClasses= c("numeric","character"),
                           col.names = c("id", "measurement"))
        
    # 2.2 extraction of the measurements names related to averages and standard deviation 
    mean_std <- subset(features, grepl("mean()", measurement) | grepl("std()", measurement),
                select = c(measurement))
    mean_std <- mean_std[,1]
    
    # 2.3 labeling fields names of database
    vLabels <- c("Subjects", "Subjects_Group", "Activity", features[,2])
    colnames(HumanActivity) <- vLabels
    
    # 2.4 Extracting of means and standard deviations from the database
    HumanActivity_mean_std <- HumanActivity[, c("Subjects", "Subjects_Group", "Activity", mean_std)]
   
    # 2.5 creation of a txt file for the database "HumanActivity_mean_std"
    write.table(HumanActivity_mean_std, file = "HumanActivity_mean_std.txt")
    
    # 2.6 deleting variables created in step 2, except the database obtained 'HumanActivity_mean_std'
    rm (mean_std, vLabels, features)


# 3. Uses descriptive activity names to name the activities in the data set

    # 3.1 reading file 'activity_labels.txt' (activities names)
    Activity_names <- read.table("./UCI HAR Dataset/activity_labels.txt",stringsAsFactors = FALSE) 
    
    # 3.2 assignment of descriptive names to the activity codes
    for (i in 1:6) {
        text <- Activity_names[i,2]
        HumanActivity$Activity <- replace(HumanActivity$Activity, HumanActivity$Activity== i, text )
    }

    # 3.3 deleting variables created in step 3
    rm(Activity_names, text)

    

# 4. Appropriately labels the data set with descriptive variable names.
#    
#    Labeling variables is already did in step 2.3, but is repeated again to 
#    avoid misunderstandings

    # 4.1 reading file 'features.txt' (measurements names)    
    features <- read.table("./UCI HAR Dataset/features.txt", colClasses= c("numeric","character"),
                 col.names = c("id", "measurement"))

    # 4.2 labeling of the fields of database
    vLabels <- c("Subjects", "Subjects_Group", "Activity", features[,2])
    colnames(HumanActivity) <- vLabels    
    
    # 4.3 creation of a txt file for database "HumanActivity"
    write.table(HumanActivity, file = "HumanActivity.txt")
    
    # 4.4 deleting variables created in step 4
    rm(features, vLabels)


# 5. Creates a second, independent tidy data set with the average of each variable 
#    for each activity and each subject. 

    # 5.1 Checking missing values
    sum(is.na(HumanActivity)) # Result [1] 0, There are no missing values
    
    # 5.2 calculating the average of the variables grouped by subject and activity
    HA_mean <- NULL
    for (i in 4:564) { 
        t <- tapply(HumanActivity[,i],paste(HumanActivity$Activity,HumanActivity$Subjects, sep=","),mean)
        HA_mean <- cbind(HA_mean,t)
    }
    HA_mean <- as.data.frame(HA_mean)
    
    # 5.2 Splitting activities and subjects in two variables (columns)
    groups <- as.character(row.names(HA_mean)) 
    groups <- strsplit(groups, split = ",") 
    groups <- t(as.data.frame(groups)) 
    
    # 5.3 joining of Activities and Subjects to the calculated variables
    HumanActivity_mean <- data.frame(groups, HA_mean, stringsAsFactors = FALSE) 
    HumanActivity_mean$X2 <- as.numeric(HumanActivity_mean$X2)
        
    # 5.4 assigning the labels to the dataset 'HumanActivity_mean'
    
        # reading the variables labels from file "features.txt"
        features1 <- read.table("./UCI HAR Dataset/features.txt",stringsAsFactors = FALSE)     
        
        # Columns labeled
        vLabels1 <- c("Activity", "Subjects", as.character(features1[,2]))
        colnames(HumanActivity_mean) <- vLabels1
    
    # 5.5 creation of a txt file for the database "HumanActivity_mean"
    write.table(HumanActivity_mean, file = "HumanActivity_mean.txt")
   
    # 5.6 deleting variables created in step 5, except the database obtained 'HumanActivity_mean'
    rm(HA_mean,t, groups, features1, vLabels1, i)
