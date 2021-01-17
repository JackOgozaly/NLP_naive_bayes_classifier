# NLP_naive_bayes_classifier
This project creates a naive_bayes function that only needs a column of unprocessed text and labels to create a model and test it. 

The advantage of this function is that it cleans text, divides the data into training and testing sets, creates a model, tests it, and prints the results in the form of a confusion matrix or crosstable. Other functions require the user to do this in multiple lines of seperate code. 

Function: 
naive_bayes(x, y, train_percent=.75, plot= TRUE, print_classifier= TRUE) 

Arguments: 

x: Character string or column of text. This should be the independent variable in your naive bayes model. 

y: Character/factor string or column of text. This should be the dependent variable in your naive bayes model. If inputed as a character it will be converted to a factor. 

train_percent: What percent of the data will be used to train the model. Test_percent is just 1-train_percent. Default is .75

plot: True or False. If true displays a confusion matrix, if false displays a crosstable. Default is TRUE. 

print_classifier: True or False. If true it exports the naive_bayes_classifier to your global environment. If false does nothing. Default is TRUE. 

Built on 
#R version 4.0.3 (2020-10-10)
#Platform: x86_64-w64-mingw32/x64 (64-bit)
#Running under: Windows 10 x64 (build 18363)
#forcats_0.5.0   dplyr_1.0.2     purrr_0.3.4     tidyr_1.1.2    
#tibble_3.0.4    tidyverse_1.3.0 caret_6.0-86    ggplot2_3.3.3  
#lattice_0.20-41 gmodels_2.18.1  e1071_1.7-4     caTools_1.18.1 
#stringr_1.4.0   SnowballC_0.7.0 readr_1.4.0     tm_0.7-8       
#NLP_0.2-1       matlab_1.0.2 
