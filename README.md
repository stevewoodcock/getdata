# Getting and Cleaning Data Course Project

## Prerequisites

Clone this repo, get the source data from
[here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip),
and unzip it.

## Run the analysis

Run script ```run_analysis.R```

## Notes on the analysis

The first part of the script:

* Merges the test and training data sets into a single data frame,
* Removes feature columns except for those measuring mean or standard
  deviation. Note only time and frequency domain features are
  retained.
* Converts activity into a factor (see codebook for values),
* Expands feature names to make them more readable

This gives a data frame called ```data```.

The second part of the script summarises the data by subject and
activity by calculating the mean for each variable. The summary data
is exported to a file called ```tidy.txt```.