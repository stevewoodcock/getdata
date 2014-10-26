library(reshape2)

MergedTrainingAndTestSets <- function() {
  # Merges the training and test data
  #
  # Returns:
  #   Data frame containing the merged data
  #     561 features, labelled per features.txt
  #     subject
  #     y
  DataframeForGroup <- function(group) {
    DatasetFilename <- function(kind) {
      paste("UCI HAR Dataset/",
            group, "/",
            kind, "_",
            group, ".txt",
            sep="")
    }
    df <- scan(DatasetFilename('X'), quiet=T) %>%
      matrix(ncol=561, byrow=TRUE) %>%
      data.frame()
    df$subject  <- scan(DatasetFilename('subject'), quiet=T)
    df$activity <- scan(DatasetFilename('y'), quiet=T)
    df
  }
  WithFeatureNames <- function(df) {
    features <- read.table("UCI HAR Dataset/features.txt", as.is=T)
    names(df)[1:561] <- features$V2
    df
  }
  rbind(DataframeForGroup('test'),
        DataframeForGroup('train')) %>%
    WithFeatureNames()
}

ExtractMeanAndStdColumns <- function(df) {
  # Extract just the mean and standard deviation columns
  # but keeping $subject and $activity
  cols <- grep("^([tf].*(mean|std))|^activity|^subject",
               names(df),
               ignore.case=T)
  df[,cols]
}

WithActivityAsFactor <- function(df) {
  # Convert activity numeric into factor per activity_labels.txt
  a <- read.table("UCI HAR Dataset/activity_labels.txt")
  df$activity <- factor(df$activity, levels=a$V1, labels=a$V2)
  df
}

ExpandFeatureNames <- function(names) {
  # Make feature names "easier" to read
  names <- sub('BodyBody', 'Body', names)
  names <- sub('^t', 'time', names)  
  names <- sub('^f', 'frequency', names)  
  names <- sub('Body', '.body', names)  
  names <- sub('Gravity', '.gravity', names)  
  names <- sub('Jerk', '.jerk', names)  
  names <- sub('Gyro', '.gyro', names)  
  names <- sub('Mag', '.magnitude', names)    
  names <- sub('Acc', '.acceleration', names)  
  names <- gsub('-', '', names)  
  names <- gsub('(mean|meanFreq|std|eq)\\(\\)', '.\\1', names)
  names <- sub('([XYZ])$', '.\\1', names)
  names
}

WithExpandedFeatureNames <- function(df) {
  names(df) <- ExpandFeatureNames(names(df))
  df
}

data <- MergedTrainingAndTestSets() %>%
  ExtractMeanAndStdColumns() %>%
  WithActivityAsFactor() %>%
  WithExpandedFeatureNames()

tidy <- melt(data,
             id=c("subject", "activity"),
             measure.vars = grep('mean|std', names(data))) %>%
  dcast(subject+activity~variable, mean)
