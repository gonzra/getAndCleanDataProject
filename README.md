---
title: "ReadMe"
author: "Rafael E. Gonzalez"
date: "Sunday, May 24, 2015"
output: html_document
---

#Getting And Cleaning Data Course Project


##Project Description

This repo contains the final project for the Getting And Cleaning Data Coursera course. This course is part of the Data Science specialization track.

This project required us to use existing raw data set (data collected from accelerometers from the Samsung Galaxy S smartphone ) and create a tidy data set that we will the use to perform analysis and write the results.


##Project Structure

```
/getAndCleanDataProject-
                      |
                      |- /doc
                      |
                      |- /data
                      |
                      |- /output
                      |
                      |- run_analysis.R 
                      |
                      |- ReadMe.Rmd 
```

- **/doc** : The doc directory contains the code book and other documentation
- **/data** : The data directory contains the original data sets downloaded from the source
- **/output** : The output directory contains two data products: The first tidy data set and a second tidy data set
- **run_analysis.R** : Main script which performs data loading, cleaning, formatting, data analysis and output
- **Readme.Rmd** : this document

##Inputs

The data used for this project was downloaded from :

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

This data represents data collected from accelerometers from the Samsung Galaxy S smartphone.

A full description of the data can be obtained here:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Under the main project directory, there is a **data** directory which contains the orginal unzipped data from the data source mentioned above. The script **run_analysis.R** assumes that the *test* and *train* data exists under the **data** directory.

##Process

The run_analysis script does the following:

* Loads and merges the test and train data set
* Clean up original data set by:
    + extracting only the columns of interest (mean and standard deviation measurements)
    + label each observation with descriptive activity names
    + label each feature with descritptive variable names
* Performs analysis of the tidy data set:
    + Calculates the mean of each variable grouped by activity and subject
* The script also write the ouput of the first tidy data set and final analysis results to the output directory

##Outputs


The script run_analysis.R generates a tidy data text file that follows the following principles( as explained in Hadley Wickhams's paper: Tidy Data)

1. Each variable forms a column.
2. Each observation forms a row.
3. Each type of observational unit forms a table.

The script writes the final analysis results to a file (**finalOutput.txt**) under the **output** directory.
this file can read into R with 
```
   read.table("http://github.com/gonzra/getAndCleanDataProject/blob/master/output/finalOutput.txt", header=TRUE)
```
In addition, the first tidy data set which was used to perform the analysis is also saved into a file for convenience. 