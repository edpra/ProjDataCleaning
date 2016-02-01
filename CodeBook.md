The tidy dataset in this project is based on the UCI HAR dataset from the following URL:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The original code book, identified in the feature_info.txt, explains the data features or variables of the dataset.  All variables are listed in the feature.txt file. The original data set contains sensor signals (accelerometer and gyroscope) collected from smartphones carried by a group of 30 volunteers as they perform different activites.  Please refer to the original documents for more details.

This dataset is a result of obtaining the original dataset, tidying up that dataset, and generating a new dataset that is summarized to contain mean values for each variable as grouped by subject id and activity.

The tidy dataset is generate by the run_analysis.R script.  This script generates the dataset and saves to tidyData.csv file.  There are 68 variables and 180 observations in this dataset.  The variables names are listed in tidyData-feature.txt file.  There are two main variables, SubjectID and Activity.  All other variables are mean values for each variable grouped by SubjectID and Activity.  The observations are sorted by SubjectId and Activity.

