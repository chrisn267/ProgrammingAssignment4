======================================================================

# Codebook for subset_data.csv and subset_summary.csv

This codebook accompanies the tidy datasets subset_data.csv and subset_summary.csv.
These datasets are produced using the script run_analysis.R from the raw dataset
UCI HAR Dataset.  Further information on the raw data, the script, and the tidy data
can be found in the accompanying README.md which should be read alongside this codebook.

The data included in the two datasets is based upon raw data obtained from analysis
of smartphone data from 30 subjects performing six different activities in an experimental
setting.  Raw data were captured from the phone's accelerometer and gyroscope.
For further information on the original experiments see README.md.

======================================================================

## subset_data.csv
The variables included in this dataset are selected outputs from the smartphone produced
during the experiments. The variables remian the same as per the orginal dataset 'X'
but only a subset are captured wheter the measurements are either mean or standard
deviation (std). Further information on the original data can be found alongside
the raw data ('UCI HAR Dataset') in the 'features_info.txt' file.

The dataset contains the following variables as individual columns (column numbers
shown in brackets) [and values shown in square brakets]:


#### test_or_train (1) 
Whether the observation was randomly selected as test or train data in the raw
data set.  *[test or train]*

  
#### subject_id (2)
The id given to the subject. *[1 to 30]*

  
#### activity_label (3)  
One of six activities undertaken by the subject. 
*[walking, upstairs (walking), downstairs (walking), sitting, standing, laying]*


### output features (4-69)
The following output features are captured as variables using both the mean (_mean)
and the standard deviation (_std).  Where 3-axial signals are captured these are 
summarised below as XYZ, but captured separately as three variables in the data. 

These variable names have been altered slightly from the original dataset to 
make them more legible as follows:
- prefix 't' and 'f' for time and frequency have been changed to 'time' and 'freq'
- postfix '-mean()-X' has been changed to 'X_mean' for all X|Y|Z and mean|std combinations.
*[all normalised between -1 and 1]*  


#### timeBodyAccXYZ (4-9)
#### timeGravityAccXYZ (10-15)
#### timeBodyGyroXYZ (22-27)
The features selected come from the accelerometer and gyroscope 3-axial raw signals 
timeAcc-XYZ and timeGyro-XYZ. These time domain signals were captured at a constant 
rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass 
Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the 
acceleration signal was then separated into body and gravity acceleration signals 
(timeBodyAcc-XYZ and timeGravityAcc-XYZ) using another low pass Butterworth filter 
with a corner frequency of 0.3 Hz. 


#### timeBodyAccJerkXYZ (16-21)
#### timeBodyGyroJerkXYZ (28-33)
Subsequently, the body linear acceleration and angular velocity were derived in time 
to obtain Jerk signals (timeBodyAccJerk-XYZ and timeBodyGyroJerk-XYZ). 


#### timeBodyAccMag (34-35)
#### timeGravityAccMag (36-37)
#### timeBodyAccJerkMag (38-39)
#### timeBodyGyroMag (40-41)
#### timeBodyGyroJerkMag (42-43)
The magnitude of these three-dimensional signals were calculated using the Euclidean 
norm (timeBodyAccMag, timeGravityAccMag, timeBodyAccJerkMag, timeBodyGyroMag, 
tBodyGyroJerkMag). 


#### freqBodyAccXYZ (44-49)
#### freqBodyAccJerkXYZ (50-55)
#### freqBodyGyroXYZ (56-61)
#### freqBodyAccMag (62-63)
#### freqBodyAccJerkMag (64-65)
#### freqBodyGyroMag (66-67)
#### freqBodyGyroJerkMag (68-69)
Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing 
freqBodyAcc-XYZ, freqBodyAccJerk-XYZ, freqBodyGyro-XYZ, freqBodyAccJerkMag, freqBodyGyroMag, 
freqBodyGyroJerkMag. 


## subset_summary.csv
This file contains a summary of the data provided in subset_data.csv.  The data is 
summarised by providing the average (mean) for each grouping of subject_id and activity_label.
This provides 180 (6 x 30) rows of summarised data.  The data is summarised for 
the same variables as the subset_data (see details provided above).





