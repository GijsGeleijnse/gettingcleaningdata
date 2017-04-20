## README for Assignment_cleaningData

This repository contains the following files

* this README.md file
* my_tidy_summary_table.txt, containing the table as generated through steps 1 - 5 in the assignment
* CodeBook.md the codebook for the data file
* run_analysis.R - the R scripts to process the downloaded datafiles


Details of the assignment can be found on https://www.coursera.org/learn/data-cleaning/peer/FIZtT/getting-and-cleaning-data-course-project


We assume the Samsung measurement dataset downloaded and extracted in the default directory. The scripts in run_analysis.R load the requirement tables, create one tidy table and subsequently create the summary table as described in our assignment.

* run_libs() loads the required libraries for this script. We assume that the packages have been installed

* createTidyData() is the main function, which loads the required files from the "/UCI HAR Dataset" directory. Steps 1 - 5 are all performed and the result is output to a file called my_tidy_summary_table.txt. We display the table using the View() function.

* tidy_activity() call the activities data fame and the names list, and assigns the actual names to the numbered activities.

* get_names() reads the names of the activities from the file

* clean_names() cleans the names of the features/columns to adhere to the tidy data criteria

* get_mean_sd() is a short function that greps the numbers of the columns out of our data frame that describe means and standard deviations