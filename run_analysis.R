# Purpose:
#
# 1. Merges the training and the test sets to create one data set
# 2. Extracts only the measurements on the mean and standard deviation for each measurement
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
#

##################################################

library(data.table)
library(plyr)
library(dplyr)

##################################################
# Download and unzip file for processing
rootdir = "./UCI\ HAR\ Dataset"
filetype1 = "train"
filetype2 = "test"

if (!file.exists(rootdir)) {
    localzip = "UCI_HAR_Dataset.zip"
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", localzip, method = "curl")
    unzip(localzip)
    unlink(localzip) # remove the uneeded big zip file
}

##################################################
# Assume d1 and d2 contain exact number of files
tidyUpData <- function(rootdir, filetype1, filetype2) {
    d1 = paste0(rootdir, "/", filetype1)   # "./UCI HAR Dataset/train"
    d2 = paste0(rootdir, "/", filetype2)   # "./UCI HAR Dataset/test"
    # Get only subjectid, labels, and dataset
    # Ignore the Inertial Signals data since they are not needed
    files = list.files(d1, pattern="*\\.txt", recursive=F, all.files=T, no..=T, include.dirs=F)  # list of filesnames with path
    #[1] "subject_train.txt" -- 1 column of subject id
    #[2] "X_train.txt" -- 561 columns
    #[3] "y_train.txt" -- 1 column of labels or names

    # STEP 1
    # 1. Merges the training and the test sets to create one data set
    # Read the 3 "train" files into one data list
    # Do the same for "test" data, then merge the 2 sets into a single data list
    dl1 = lapply(files, function(file) { fread(paste0(d1, "/", file))})
    # Do the same for the 3 "test" files
    files = unlist(lapply(files, function(file) {gsub("train.txt", "test.txt", file)} ))
    dl2 = lapply(files, function(file) { fread(paste0(d2, "/", file))})
    # Merge rows of the 2 data lists
    dtms = rbindlist(list(unlist(dl1, recursive=F), unlist(dl2, recursive=F)))
    # "select" has a problem with three columns in dtm named "V1".
    # make.names creates "V1", "V1.1", and "V1.2"
    valid_column_names = make.names(names=names(dtms), unique=TRUE, allow_ = TRUE)
    names(dtms) = valid_column_names
    print("==========Step 1 - dim(merged data from train and test datasets):==========")
    print(dim(dtms))
    
    # STEP 2
    # 2. Extracts only the measurements on the mean and standard deviation for each measurement
    # These are columns with data generated from mean() and std() functions
    # as specified in file feature.txt
    featureList = fread(paste0(rootdir, "/", "features.txt"))  # featureList will be used in step 4 too
    meanStdVars = filter(featureList, grepl("mean\\(\\)", V2) | grepl("std\\(\\)", V2))
    meanStdVars = meanStdVars[][[1]]  # just get the list of column numbers and ignore the list of feature names
    # NOTE: the following grep("X_") returns 2 which depends on the order of the filenames in the "files" list
    meanStdVars = meanStdVars + grep("X_", files)  # offset to correct column number in the merged df
    # dtm structure:
    #   col 1 or "V1"     - subject id
    #   col 563 or "V1.2" - labels
    # Select all columns with values generated with "mean()" and "std()"--note the parenthesis
    # Please note that variable names with just the word "mean" and "std" are not selected
    dtms = select(dtms, 1, 563, meanStdVars)
    print("==========Step 2 - dim(datasets of mean() and std() variables):==========")
    print(dim(dtms))
    
    # STEP 3
    # 3. Uses descriptive activity names to name the activities in the data set
    dtms = rename(dtms, "SubjectID"=V1, "Activity"=V1.2)
    activities = c("Walking", "WalkingUpstairs", "WalkingDownstairs", "Sitting", "Standing", "Laying")
    dtms$Activity = sapply(dtms$Activity, function(n) { activities[n] })
    print("==========Step 3 - descriptive unique(dtms$Activity):==========")
    print(unique(dtms$Activity))
    
    # STEP 4
    # 4. Appropriately labels the data set with descriptive variable names
    featurenames = sapply(featureList, function(featureName) {
        # NOTE: this list of string substitutes can be externalized in a config file
        ss = list(c(",","\\."), c("\\)",""), c("\\(", "\\."), c("\\(\\)", ""),
                  c("-", "\\."), c("tB","timeB"), c("tG","timeG"), c("fB","freqB"))
        strMod <- function(vs, str) { 
            if (length(vs) > 1)
                gsub(vs[1][[1]][1], vs[1][[1]][2], strMod(vs[-1], str)) # str is modified during recursive unwinding
            else str
        }
        strMod(ss, featureName)
    })
    # assign variable names to columns
    names(dtms) = sapply(names(dtms), function(varname) {
        num = as.integer(gsub('.*V([0-9]+)','\\1', varname))
        # NOTE: the -1 offset depends on the dtms = select statement earlier in the file
        featurenames[,2][num-1]  # adjust column number for SubjectID and Activity
    })
    print("==========Step 4 - descriptive variable names):==========")
    print(names(dtms))
    
    # STEP 5
    # 5. From the data set in step 4, creates a second, independent tidy data set 
    #    with the average of each variable for each activity and each subject
    dtidy = dtms %>% group_by(SubjectID, Activity) %>% 
                     summarize_each(funs(mean)) %>% arrange(SubjectID, Activity)
    print("==========Step 5 - dim(tidied dataset with variable means):==========")
    print(dim(dtidy))
    
    dtidy # return the new data table
} # end of tidyUpData

##################################################

run_analysis <- function() {
    tidyUpData(rootdir, filetype1, filetype2)
}

# run at app start time
dr = run_analysis()
# write the tidy data table to file
write.csv(dr, "tidyData.csv")
# write variables names to a file for documentation
write.table(names(dr), "tidyData-features.txt", quote=F, sep=" ", col.names=F)
