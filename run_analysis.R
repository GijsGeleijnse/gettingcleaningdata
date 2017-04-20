#The submitted data set is tidy.
#The Github repo contains the required scripts.
#GitHub contains a code book that modifies and updates the available codebooks with the data to indicate all the variables and summaries calculated, along with units, and any other relevant information.
#The README that explains the analysis files is clear and understandable.
#The work submitted for this project is the work of the student who submitted it.

run_libs <- function(){ 
  library(lubridate)
  library(stringr)
  
  
}
 
 

### main function to createTidy Data set
### we assume the zip file is downloaded and extracted into the /UCI HAR Dataset
### directory
### we use maxLines to limit the number of lines downloaded (for testing purposes)
### maxlines can be left blank to download everything

createTidyData <- function(){
  # loading the four data files
  trainFile <- paste0(getwd(),"/UCI HAR Dataset/train/X_train.txt")
  testFile <-  paste0(getwd(),"/UCI HAR Dataset/test/X_test.txt")
  trainActFile <- paste0(getwd(),"/UCI HAR Dataset/train/Y_train.txt")
  testActFile  <- paste0(getwd(),"/UCI HAR Dataset/test/Y_test.txt")
  trainSubjectFile <- paste0(getwd(),"/UCI HAR Dataset/train/subject_train.txt")
  testSubjectFile <- paste0(getwd(),"/UCI HAR Dataset/test/subject_test.txt")
  
  # loading the data files 
  #train <- get_data_frame_from_file(trainFile,maxlines)
  #test <- get_data_frame_from_file(testFile,maxlines)
  train <- read.table(trainFile)
  test <- read.table(testFile)
  
  
  ### get the activity data
  trainAct <- read.table(trainActFile) #get_data_frame_from_file(trainActFile,maxlines)
  testAct<-   read.table(testActFile) # get_data_frame_from_file(testActFile,maxlines)
  
  ### fetching names of columns
  filen <- paste0(getwd(),"/UCI HAR Dataset/features.txt")
  names <- get_names(filen)
  
  ## fROM ASSIGNMENT 4. apropriately labels the data set with descriptive variable names.
  names <- clean_names(names)
  
  colnames(train) <- names[,1]
  colnames(test) <- names[,1]
  
  
  
  
  ###### removing uninteresting columns (remaining mean and std)
  ### msd will be the column names with mean and std (in which we are interested)
  ### FROM ASSIGNMENT: 2. Extracts only the measurements on the mean and standard deviation for each measurement.
  msd <- get_mean_sd(names)
  d_train <- train[,msd] # d_train
  d_test <-  test[,msd] ## select(test,msd) # test[,msd]
  train <- NULL
  test <- NULL
  
  
  
  ### fetching the activity names
  filea <- paste0(getwd(),"/UCI HAR Dataset/activity_labels.txt")
  act_names <-get_names(filea)
  act_names[[1]] <- sapply(act_names[[1]],tolower)
  
  ### tidying activities...
  ## FROM ASSIGNMENT 3. Uses descriptive activity names to name the activities in the data set
  m_train_act <- tidy_activity(trainAct,act_names)
  m_test_act <- tidy_activity(testAct,act_names)
  colnames(m_train_act) <- "activity"
  colnames(m_test_act) <- "activity"
  
  
  ## creating the subject data frame  
  m_train_subject <- read.table(trainSubjectFile)
  colnames(m_train_subject) <- "subject"
  m_test_subject <- read.table(testSubjectFile)
  colnames(m_test_subject) <- "subject"
  
  
  ##  adding the user ids and the activity to the data frames
  
  d_train <- cbind(m_train_act,d_train)
  d_train <- cbind(m_train_subject, d_train) #ids train
  
  d_test <- cbind(m_test_act,d_test)
  d_test <- cbind(m_test_subject,d_test)# ids test
  
  ## and finally combining the data frames (test and train) into one
  ### FROM ASSIGNMENT: 1. Merges the training and the test sets to create one data set.
  d <- rbind(d_train,d_test)
  
  
  
  ## FROM ASSIGNMENT: 5. From the data set in step 4, creates a second, independent tidy data set 
  ###with the average of each variable for each activity and each subject.

 d <- aggregate(d[,3:ncol(d)],by=list(d$subject,d$activity),FUN=mean)
  colnames(d)<- c("subject","activity", colnames(d[,3:ncol(d)]))
 d <- arrange(d,subject)
 write.table(d, file = "my_tidy_summary_table.txt",row.names=FALSE, na="",col.names=TRUE, sep=",")
 View(d)
}






###
### reads activity name and list of activities
### produces a list with the activity names
tidy_activity <- function(act,names)
{
  
  for(j in 1: nrow(act))
  {
    val <- act[j,1] 
    
    val <- as.numeric(as.character(val))
    
    val <- names[[1]][val]
    val <- as.character(val)
    act[j,1]<-val 
  }
  
  act
  
}




### read the names of the variables from the file "features.txt"
### 
get_names <- function(filen){
  
  con <- file(filen,open="r")
  lines <- readLines(con)
  close(con)
  dd<- vector()
  
  for(j in 1:length(lines)){
    r<- gsub("  "," ",lines[j])
    if(nchar(r)>=1 && substr(r,1,1)==" "){r<- substr(r,2,nchar(r))}
    d <- strsplit(r," ")
    #print(class(d))
    dd <- c(dd,d)
  }
  
  dd<- unlist(dd)
  ddd <- vector()
  for(k in 1 : length(dd)){
    if(k %% 2 == 0) {
      name <- dd[k]
      ##name <- paste((k/2),name)
      ddd <-c(ddd,name)
    }
    
  }
  ddd<- data.frame(ddd)
  ddd
  
}


### clean the names of the features
### t = time and f = frequency
clean_names <- function(names)
{
  names[,1] <- gsub("[-_(),]","",names[,1])
  names[,1] <- gsub("^t","time",names[,1])
  names[,1] <- gsub("^f","frequency",names[,1])
  names
  
}


## get the numbers of the colums we are interested in
get_mean_sd <- function(d)
{
  l <- grep("mean|std",d[,1])
  
  l
}


