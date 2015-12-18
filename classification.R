## FILE: Classifying 20 Newsgroups Dataset. 
## For presentation with Computational Sociology source at Duke.
## AUTHOR: Alex Hanna (ahanna@ssc.wisc.edu)
## DATE: October 14, 2015

## load the RTextTools package
## Documentation of this package is available at 
## https://cran.r-project.org/web/packages/RTextTools/RTextTools.pdf
library(RTextTools)

## load the text mining (tm) package
library(tm)

## load dplyr and tidyr for data munging
library(dplyr)
library(tidyr)

## ggplot2 for visualization
library(ggplot2)

## load data
data <- read.csv("http://ssc.wisc.edu/~ahanna/20_newsgroups.csv", stringsAsFactors = FALSE)
data <- data[-1]

## make tbl_df for nicer behavior on output
data <- tbl_df(data)

## peak at the data
names(data)
head(data$text, 2)
nrow(data)

## sample 20% of the data
data <- sample_frac(data, size = 0.1)

## create a Document-Term Matrix and apply a number of preprocessing transformations
## many preprocessing transformations take place by default: 
## removing punctuation, lower casing, stripping whitespace
dtm <- create_matrix(data, language="english")

## look at the DTM
dtm

## get a sense of what this matrix looks like
## the first argument is the range of documents you want to look at
## the second is the range of terms you want to look at
inspect(dtm[1:10, 1:5])

## create a break between the training and test samples
training_break <- as.integer(0.9*nrow(data))

## create a container which can be used with RTextTools models
container <- create_container(dtm,t(data$target),trainSize=1:training_break, testSize=training_break:nrow(data),virgin=FALSE)

## now we're going to cross-validate our ML models. 
## we can see which ones are available with print_algorithms()
print_algorithms()

## we're going to choose one for time's sake
## Support Vector Machine, which has been very popular lately.
## but we can also use random forests, which Chris has talked about

## we're going to choose 3 folds for this 
## ideally, we would play around with multiple classifiers and find the one
## which worked the best
cv.svm <- cross_validate(containers, 3, algorithm = 'SVM', kernel = 'linear')

## this is the mean accuracy score
cv.svm$meanAccuracy

## now we can train the model 
models <- train_model(containers, algorithms = c("SVM"))

## and apply the trained model to our test set
results <- classify_model(container, models)

## and create analytics
analytics <- create_analytics(container, results)

## we can see the precision, recall, and F1-score of the classifier
analytics@algorithm_summary

## and summarize them with summary()
summary(analytics@algorithm_summary)

## we can also see the SVM label, the correct label, 
## and the SVM probability which was assigned to it
head(analytics@document_summary[1:3])

## as a last analytic, we can plot the distribution of SVM probabilities against
## if they were correct versus whether they were incorrect

## this does it all together
p <- ggplot(analytics@document_summary, aes(SVM_PROB, fill = factor(CONSENSUS_INCORRECT)))
p <- p + geom_histogram()
p <- p + scale_fill_manual(values = c("grey", "red"), labels = c("Correct", "Incorrect"))
p <- p + theme_bw() + theme(legend.title = element_blank())

## and this divides it up by class
p <- p + facet_wrap(~ MANUAL_CODE)
