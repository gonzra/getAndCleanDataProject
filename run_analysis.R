
library(dplyr)
library(plyr)

downloadData <- function()
{
  
}


combineTestAndTrainData <- function(baseDir, testDataFilename, trainDataFilename)
{
  testData <- read.table(paste(c(".",baseDir,"test",testDataFilename), collapse="\\"))  
  trainData <- read.table(paste(c(".",baseDir,"train",trainDataFilename), collapse="\\"))  
  return(rbind(testData,trainData))
}

getDescriptiveColumnNames <- function(baseDir, featuresFileName)
{
  features <- read.table(paste(c(".",baseDir,featuresFileName), collapse="\\"), colClasses=c("numeric","character"))[,2]
  
  meanMeasurementIndices <- grep("-mean()", features, fixed=TRUE)
  stdMeasurementIndices <- grep("-std()", features,  fixed=TRUE)
  filteredColumns <- sort(c(meanMeasurementIndices,stdMeasurementIndices))
  
  descriptiveColumnNames <- sapply(features[filteredColumns],transformVariableName)
  return(data.frame(columnIds = filteredColumns, columnNames = descriptiveColumnNames, stringsAsFactors=FALSE))
  
}

getDescriptiveActivityNames <- function(baseDir, testActivityCodesFile, trainActivityCodesFile)
{
  ##activityCodes <- c(as.vector(read.table(paste(c(".",baseDir,"test","y_test.txt"), collapse="\\")))[,"V1"],as.vector(read.table(paste(c(".",baseDir,"train","y_train.txt"), collapse="\\")))[,"V1"])                                                                                                                      
  activityCodes <- combineTestAndTrainData(baseDir, testActivityCodesFile, trainActivityCodesFile)
  activityLabels <- read.table(paste(c(".",baseDir,"activity_labels.txt"), collapse="\\"), colClasses=c("numeric","character"))
  
  fun <- function(x) activityLabels[x,2]
  activityNamesVector <- sapply(activityCodes,fun)
  #names(activityNamesVector) <- "ActivityName"
  return(activityNamesVector)
}


transformVariableName <- function(rawVariableName)
{  
  transformedVariable <- rawVariableName
  transformedVariable <- gsub("fBodyBody", "fBody",transformedVariable, fixed = TRUE)
  transformedVariable <- gsub("tGravityAccMag", "GravityAccelerationTimeMagnitude",transformedVariable, fixed = TRUE)
  transformedVariable <- gsub("tBodyAccJerkMag", "BodyJerkAccelerationTimeMagnitude",transformedVariable, fixed = TRUE)
  transformedVariable <- gsub("tBodyGyroMag", "BodyAngularVelocityTimeMagnitude",transformedVariable, fixed = TRUE)
  transformedVariable <- gsub("tBodyGyroJerkMag", "BodyJerkAngularVelocityTimeMagnitude",transformedVariable, fixed = TRUE)
  transformedVariable <- gsub("fBodyAccMag", "BodyAccelerationFrequencyMagnitude",transformedVariable, fixed = TRUE)
  transformedVariable <- gsub("fBodyAccJerkMag", "BodyJerkAngularVelocityFrequencyMagnitude",transformedVariable, fixed = TRUE)
  transformedVariable <- gsub("fBodyGyroMag", "BodyAngularVelocityFreqencyMagnitude",transformedVariable, fixed = TRUE)
  transformedVariable <- gsub("fBodyGyroJerkMag", "BodyJerkAngularVelocityFrequency",transformedVariable, fixed = TRUE)
  
  transformedVariable <- gsub("tBodyAcc", "BodyAccelerationTime",transformedVariable, fixed = TRUE)
  transformedVariable <- gsub("tGravityAcc", "GravityAccelerationTime",transformedVariable, fixed = TRUE)
  transformedVariable <- gsub("tBodyAccJerk", "BodyJerkAccelerationTime",transformedVariable, fixed = TRUE)
  transformedVariable <- gsub("tBodyGyro", "BodyAngularVelocityTime",transformedVariable, fixed = TRUE)
  transformedVariable <- gsub("tBodyGyroJerk", "BodyJerkAngularVelocityTime",transformedVariable, fixed = TRUE)
  transformedVariable <- gsub("tBodyAccMag", "BodyAccelerationTimeMagnitude",transformedVariable, fixed = TRUE)
  
  transformedVariable <- gsub("fBodyAcc", "BodyJerkAccelerationFrequency",transformedVariable, fixed = TRUE)
  transformedVariable <- gsub("fBodyAccJerk", "BodyJerkAccelerationFrequency",transformedVariable, fixed = TRUE)
  transformedVariable <- gsub("fBodyGyro", "BodyAngularVelocityFrequency",transformedVariable, fixed = TRUE)
  return (transformedVariable)
}

run_analysis <- function()
{
  #Merge Train and Test Data sets
  baseDir <- "data"
  testDataFilename <- "X_Test.txt"
  trainDataFilename <- "X_Train.txt"  
  testActivityCodeFilename <- "y_test.txt"
  trainActivityCodeFilename <- "y_train.txt"  
  featuresFileName <- "features.txt"
  
  print("Loading data sets ....")
  projectDataSet <- combineTestAndTrainData(baseDir, testDataFilename, trainDataFilename)
  
  print("Cleaning up data set, making it tidy....")
  #get column names representing mean() and std() measurements
  columnIdsAndNames <- getDescriptiveColumnNames(baseDir,featuresFileName)
  
  #Extract interested features
  tidyProjectDataSet1 <- projectDataSet[,columnIdsAndNames$columnIds]
  
  #Name activities in the datas set descriptively
  activityNamesVector <-getDescriptiveActivityNames(baseDir,testActivityCodeFilename,trainActivityCodeFilename )

  #Label data set with descriptive variable names
  names(tidyProjectDataSet1) <- columnIdsAndNames$columnNames  
  tidyProjectDataSet1<- cbind(activityNamesVector,tidyProjectDataSet1)
  colnames(tidyProjectDataSet1)[1] <- "ActivityName"
  
  print("Writing tidy data set output file....")
  #Write the tidy data set to a file, This is not required for the project but it is good to have it for analysis
  write.table(tidyProjectDataSet1, file = ".\\output\\tidyDataSet1.txt",row.names=FALSE)
  
  print("Performing analysis on tidy data set")
  #load subject data for test and train data sets
  subjectDataVector <- combineTestAndTrainData(baseDir, "subject_test.txt", "subject_train.txt")
  tidyProjectDataSet1 <- cbind(subjectDataVector,tidyProjectDataSet1)
  colnames(tidyProjectDataSet1)[1] <- "Subject"
  
  #calculate mean for each feature grouped by Activity and Subject
  ##final <- aggregate(tidyProjectDataSet1, by=list(ActivityName = tidyProjectDataSet1$ActivityName, Subject = tidyProjectDataSet1$Subject), mean, na.rm=TRUE)
  final <- ddply(tidyProjectDataSet1, .(ActivityName, Subject), colwise(mean))
  
  #write Output
  print("Writing final output file....")
  write.table(final, file = ".\\output\\finalOutput.txt",row.names=FALSE)
  
}
