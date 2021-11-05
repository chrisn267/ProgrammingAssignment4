======================================================================

# README
## Further tidying of Human Activity Recognition Using Smartphones Dataset

======================================================================

This project takes a dataset produced from experiments using smartphone sensor
signals, and further prepares that data by cleaning, subsetting and summarising
to produce two tidy datasets.

Full details of the original experiment can be found in the README.txt file in the 
'UCI HAR Dataset' folder also in this repo or at the link here: 
[information](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

The UCI HAR Dataset is included in this repo as a folder in its original form or 
can be downloaded here:
[UCI HAR Dataset](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

This repo contains the following files/folders:


### README.md
This document which describes the different elements of the data analysis and how
they fit together.


### UCI HAR Dataset (folder)
A folder containing the raw data which this work is based upon.  The folder also
contains a README.txt with details of the original experiment and a features_info.txt
which is the codebook for the original dataset. This folder and its subfolders have
not been altered since download and should be left with the same names and structure 
in order for run_analysis.R to execute correctly.  


### run_analysis.R
An R script which can be run in its entirety to create the two output txt files
from the raw input data.  This script also creates the same data as tibbles in R
which can then be worked from.  The script contains detailed comments to allow the
user to step through and understand how the tidying has been produced.  The script 
should be run from the same location as the raw data folder and the output files will 
in turn be generated in the same location.


### subset_data.txt
The output file containing the mean and standard deviation variables from the original
raw data.  (further details provided in codebook.md).


### subset_summary.txt
The output file containing summarised data across the different subjects and activities
for each variable.  The data is summarised by taking the mean.  (further details 
provided in codebook.md).


### codebook.md
A document which describes the variables included in the output files and how they
were produced
