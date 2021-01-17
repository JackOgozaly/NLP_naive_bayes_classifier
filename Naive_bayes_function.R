#This project creates a function naive_bayes which when given a text column and 
#a label column creates a model, tests the model, and outputs the model and the
#results of the model

library(matlab)
library(tm)
library(readr)
library(SnowballC)
library(stringr)
library(caTools)
library(e1071)
library(caret)
library(tidyverse) 
library(ggplot2)
library(gmodels) 

#Built on 
#R version 4.0.3 (2020-10-10)
#Platform: x86_64-w64-mingw32/x64 (64-bit)
#Running under: Windows 10 x64 (build 18363)
#forcats_0.5.0   dplyr_1.0.2     purrr_0.3.4     tidyr_1.1.2    
#tibble_3.0.4    tidyverse_1.3.0 caret_6.0-86    ggplot2_3.3.3  
#lattice_0.20-41 gmodels_2.18.1  e1071_1.7-4     caTools_1.18.1 
#stringr_1.4.0   SnowballC_0.7.0 readr_1.4.0     tm_0.7-8       
#NLP_0.2-1       matlab_1.0.2  

naive_bayes <- function(x, # should be a columm from a dataframe
                        y, #should be a column of labels you want to predict
                        train_percent = .75, #by default 75% of the data is used to train the model
                        plot = TRUE, #Prints a confusion matrix by default
                        print_classifier = TRUE)#Choose whether or not you want the classifier to print
{    
  function_corpus <- VCorpus(VectorSource(x))
  inspect(function_corpus[1:2])
  as.character(function_corpus[[1]])
  function_corpus_clean <- tm_map(function_corpus,content_transformer(tolower)) #converting to lower case letters
  function_corpus_clean <- tm_map(function_corpus_clean,removeNumbers) #removing numbers
  function_corpus_clean <- tm_map(function_corpus_clean,removeWords,stopwords()) #removing stop words
  function_corpus_clean <- tm_map(function_corpus_clean,removePunctuation) #removing punctuation
  function_corpus_clean <- tm_map(function_corpus_clean,stemDocument)#Stem words
  function_corpus_clean <- tm_map(function_corpus_clean,stripWhitespace)#Remove excess whitespace
  function_dtm <- DocumentTermMatrix(function_corpus_clean, 
                                     control = list(tolower = TRUE,removeNumbers = TRUE,
                                                    stopwords = TRUE,
                                                    removePunctuatio = TRUE,
                                                    stemming = TRUE))
  x_dataframe <- as.data.frame(x)#Converts column to df
  y <- as.factor(y) #Converts labels to a factor so that classification can happen
  y_dataframe <- as.data.frame(y) #Converts column of labels to df
  #Find the number of observations and divided the dataset up based on the train_percent specified 
  observations <- as.numeric(nrow(x_dataframe))
  train_upper_limit <- train_percent*observations
  function_dtm_train <- function_dtm[1:train_upper_limit,]
  function_dtm_test <- function_dtm[train_upper_limit:observations,]
  function_train_labels <- y_dataframe[1:train_upper_limit,]
  function_test_labels <- y_dataframe[train_upper_limit:observations,]
  #Counting freq of words and training the naive bayes model
  function_freq_words <- findFreqTerms(function_dtm_train,5)
  function_dtm_freq_train <- function_dtm_train[,function_freq_words]
  function_dtm_freq_test <- function_dtm_test[,function_freq_words]
  convert_counts <- function(x){
    x <- ifelse(x>0,"Yes","No") 
  }
  function_train <- apply(function_dtm_freq_train,MARGIN = 2,convert_counts)
  function_test <- apply(function_dtm_freq_test,MARGIN = 2,convert_counts)
  function_classifier <- naiveBayes(function_train, function_train_labels)
  #Testing the classifier on the test data
  function_test_pred <- predict(function_classifier, newdata=function_test)
  #if the user wants a plot this code runs
  if(plot == TRUE){
    #Plots Predicted vs Actual labels from our test data 
    confusion_matrix <- as.data.frame(table(function_test_pred, function_test_labels))
    ggplot(data = confusion_matrix,
           mapping = aes(x = function_test_pred,
                         y = function_test_labels)) +
      geom_tile(aes(fill = Freq)) +
      geom_text(aes(label = sprintf("%1.0f", Freq)), vjust = 1) +
      scale_fill_gradient(low = "blue",
                          high = "red",
                          trans = "log") +ylab("Actual Labels\n") + xlab("\nPredicted Labels")
  }else{ 
    return(CrossTable(function_test_pred, function_test_labels, prop.chisq = FALSE, prop.t = FALSE, dnn = c('predicted', 'actual'))
)
  }
  if(print_classifier == TRUE){
    #Creates a global object which is the naive bayes classifier made on the training data
    assign("naive_bayes_classifier", function_classifier, envir=globalenv())
  }else{
    return(print("Classifier not exported."))
  }
}


#Example 
#For this exmaple I am using a collection of tweets with labels of positive or negative 
#This dataset can be found at
#https://www.kaggle.com/crowdflower/twitter-airline-sentiment
library(readr)
Airlines_Tweet_Dataset <- read.csv("Tweets.csv")
naive_bayes(Airlines_Tweet_Dataset$text, Airlines_Tweet_Dataset$airline_sentiment)

