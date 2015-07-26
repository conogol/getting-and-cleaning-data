# Course Project

This file describes how the code for the Course Project works for the Getting 
and Cleaning Data course from Coursera


The code for this project can be found in `run_analysis.R`. The script does the following:


1. Checks to see if the folder with the data files needed exists. If it doesn't, it checks for the zipped dataset locally (downloading it if needed), and unzips it.
2. It loads the activity and measures information 
3. For the training and test datasets, it loads the columns with the mean and standard deviation
4. It proceeds to load the activity and subject data
5. Merges the two datasets, adding the labels
6. Creates factors for the activity and subject columns, using melt() to obtain unique combinations
7. It writes the merged data to a tidy dataset named `tidy.txt`

