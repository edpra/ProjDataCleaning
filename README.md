# ProjDataCleaning
Getting and Cleaning Data Course Project

<<<<<<< HEAD
This project downloads UCI HAR data and tidy up the original data.  The UCI HAR is obtained from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip.
Please refer to the code book for more details the original and the generated tidy datasets.

Script run_analysis.R performs the following algorithm to transform and generate tidy data.

1. Merges the training and the test sets to create one data set
2. Extracts only the measurements on the mean and standard deviation for each measurement
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

Please refer to run_analysis.R comments for more details.

The script downloads original dataset if not downloaded yet.  It then performs the above steps to process the downloaded data, specifically the two sets of three files: subject_{train|test}.txt, X_{train|test}.txt, and y_{train|test}.txt.

You can experiment with this script by uncommenting the print lines to see a message validating each step above.  To change variables to be selected for a different dataset from the original one you can modify the strings in the filter of step 2.  To change tidy variable names you can modify feature name list in step4.  One suggestion is to externalize these string parameters to a configuration file.  Changing selected variables and their tidy names would be easier without touching the script.

=======
This repo contains R scripts to clean sourced data.
>>>>>>> 71a135d09ef3cae80b61455773b121bc5dff5c99
