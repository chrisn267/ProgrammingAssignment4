##################################################################################################################
##  run_analysis.R                                                                                              ##
##                                                                                                              ##
##  This script performs the following steps to the UCI HAR Dataset:                                            ##
##  Step 0 - Read data into r structures (so that we can look at it and decide how it fits together).           ##
##  Step 1 - Merge the training and the test sets to create one data set.                                       ##
##  Step 2 - Extract only the measurements on the mean and standard deviation for each measurement.             ##
##  Step 3 - Use descriptive activity names to name the activities in the data set.                             ##
##  Step 4 - Appropriately label the data set with descriptive variable names.                                  ##
##  Step 5 - From the data set in step 4, create a second, independent tidy data set with                       ##
##           the average of each variable for each activity and each subject.                                   ##
##  Step 6 - Push the two created datasets to csv files, and optionally tidy up intermediate data structures.   ##
##                                                                                                              ##
##  - This script assumes that a folder called "UCI HAR Dataset" containing the raw data                        ##
##    sits within the same folder as the R scripts and that the structure of the raw dataset is untouched.      ##
##  - This script creates an "output_csv" folder and places two output .csv files in that folder.               ##
##  - The scipt allows the user to select which r data structures are maintained after it is run,               ##
##    currently intermediate structures are not maintained.                                                     ##
##  - Currently all steps must be run in sequence to ensure correct execution of the script.                    ##
##                                                                                                              ##
##  See README.md for further details.                                                                          ##
##                                                                                                              ##    
##################################################################################################################

# Step 0 - Read data into r structures (so that we can look at it and decide how it fits together).

    # use tidyverse package for stringr and readr functionality
    packages <- c("tidyverse")
    install.packages(setdiff(packages, rownames(installed.packages())))
    lapply(packages, library, character.only = TRUE)

    # get the names of the train and text files to read in
    train.txt <- list.files(path="UCI HAR Dataset/train", recursive=T, pattern ="\\.txt$", full.names=T)
    test.txt <- list.files(path="UCI HAR Dataset/test", recursive=T, pattern ="\\.txt$", full.names=T)
    
    # read in all available data files using read_table (exclude README.txt and features_info.txt)
    train.raw <- sapply(train.txt, read_table, col_names = FALSE)
    test.raw <- sapply(test.txt, read_table, col_names = FALSE)
    feature.raw <- read_table("UCI HAR Dataset/features.txt", col_names = FALSE)
    activity.raw <- read_table("UCI HAR Dataset/activity_labels.txt", col_names = FALSE)
    
    # store the raw data in a list as follows
    #   train    - 12 files of training data
    #   test     - 12 files of test data
    #   metadata - a list of feature labels and a list of activities
    rawdata = list(train = train.raw, 
                   test = test.raw, 
                   metadata = list(features = feature.raw[,2], activities = activity.raw[,2]))

    # name the data tibbles in 'train' and 'test' with their original file names for clarity    
    names(rawdata$train) <- basename(train.txt)
    names(rawdata$test) <- basename(test.txt)
    
    # create vectors of features and activities for later use
    feature.names <- pull(rawdata$metadata$features)
    activity.names <- pull(rawdata$metadata$activities)

# Step 1 - Merge the training and the test sets to create one data set.

# As per README2 we assume we are only interested in the 'X', 'y', and 'subject'
# datasets and not the base data in the 'Inertial Signals' folder

    # Bring together the X, y and subject data horizontally using cbind to create a test.data and train.data dataset
    test.data <- cbind(rawdata$test$subject, rawdata$test$y, rawdata$test$X)
    train.data <- cbind(rawdata$train$subject, rawdata$train$y, rawdata$train$X)
    
    # Add an additional column to keep track of whether the data was originally test or train data
    test.data <- cbind(col1 = rep("test", times = nrow(test.data)), test.data)
    train.data <- cbind(col1 = rep("train", times = nrow(train.data)), train.data)
    
    # Bring together the test and train dataset vertically using rbind
    full.data <- rbind(test.data, train.data)
    
    # Name the columns of the full dataset using the features.txt names
    names(full.data)[1] <- "test_or_train"
    names(full.data)[2] <- "subject_id"
    names(full.data)[3] <- "activity_label"
    names(full.data)[4:564] <- feature.names
    
# Step 2 - Extract only the measurements on the mean and standard deviation for each measurement. 
    
    # get the feature names containing 'mean()' or 'std()' 
    feature.subset <- feature.names[str_detect(feature.names, "mean\\(\\)|std\\(\\)")]
    
    # use these names to subset the full data set by those columns - also keep the first three columns
    subset.data <- select(full.data, test_or_train, subject_id, activity_label, all_of(feature.subset))
    
# Step 3 - Use descriptive activity names to name the activities in the data set.
    
    # use the activity labels provided (converted to lower case) to replace index values 
    subset.data$activity_label <- tolower(activity.names[subset.data$activity_label])
    
    # remove 'walking_' from walking_downstairs and walking_upstairs
    subset.data$activity_label <- str_replace(subset.data$activity_label, "walking_", "")

# Step 4 - Appropriately label the data set with descriptive variable names. 
    
    # create clean set of names
    feature.subset.clean <- feature.subset %>%
    
        # remove brackets
        str_remove("\\(\\)") %>%
    
        # replace t with time and f with freq
        str_replace("^[t]","time") %>%
        str_replace("^[f]","freq") %>%
        
        # replace BodyBody with Body
        str_replace("BodyBody", "Body")  %>%
    
        # replace -mean|std-X|Y|Z with X|Y|Z_mean|std
        str_replace("-(mean|std)-*([XYZ]*)", "\\2_\\1")

    # use these cleaned up names to label the subset data (mean and std only)
    names(subset.data)[4:69] <- feature.subset.clean
    
    # arrange column names alphabetically (except for first 3 columns)
    # colsort <- sort(colnames((subset.data)[4:69]))
    # subset.data <- select(subset.data, test_or_train, subject_id, activity_label, all_of(colsort))
    # feature.subset.clean <- sort(feature.subset.clean)

# Step 5 - From the data set in step 4, create a second, independent tidy data set with 
         # the average of each variable for each activity and each subject.
    
    # group data by activity and subject_id and show the mean for all numeric variables
    subset.summary <- subset.data %>%
        group_by(subject_id, activity_label) %>%
        summarise_if(is.numeric, mean)
    
# Step 6 - Push the two created datasets to csv files, and tidy up intermediate data structures.
    
    # write to csv files in current folder
    write_csv(subset.data, "subset_data.csv")
    write_csv(subset.summary, "subset_summary.csv")
    
    # tidy up data structures to determine which are maintained in R when the script is run
    # this list below can be commented / uncommented (## /  ) to remove / keep data structures 
    keeplist <- c(## "activity.raw",        # a tibble holding list of activities from activity_list.txt 
                  ## "feature.raw",         # a tibble holding list of feature names from features.txt
                  ## "test.raw",            # a list of tibbles holding test datasets from *_test.txt
                  ## "train.raw",           # a list of tibbles holding training datasets from *_train.txt
                     "rawdata",             # a list of the four .raw objects above - with activity and features held in a metadata list
                  ## "test.data",           # a tibble holding the 'X', 'y', and 'structure' testing datasets
                  ## "train.data",          # a tibble holding the 'X', 'y', and 'structure' training datasets
                     "full.data",           # a tibble combining test.data and train.data with test/train introduced as a variable
                     "subset.data",         # a tibble containing the subset of full.data containing just mean and std variables 
                     "subset.summary",      # a tibble containing a summary of subset.data with mean for each activity/subject combination
                     "test.txt",            # a vector of pathnames of the test .txt files
                     "train.txt",           # a vector of pathnames of the training .txt files
                  ## "activity.names",      # a vector of the provided activity names from activity_list.txt
                  ## "feature.names",       # a vector of the provided feature names from features.txt
                  ## "feature.subset",      # a vector of the subset of feature names for just mean() and std()
                     "feature.subset.clean" # a vector of cleaned subset feature names
                  )
    
    # remove unwanted data structures
    rm(list = setdiff(ls(), c(keeplist, "keeplist")))
    
## run_analysis.R - SCRIPT END #########################################################################             
    
    
    