# Student Name: Lakshmi Brahmani Suravajjala
# Student ID: 110377044
# Submission Date: 12/16/2022

# removing all the variable and cleaning the environment
rm(list=ls())

# Importing necessary libraries
library("cowplot")
library("qdap")
library("wordcloud")
library("stringr")
library("stringi")
library("syuzhet")
library("gridExtra")
library("tidytext")
library("dplyr")
library("tm")
library("tidyr") 
library("ggthemes")
library("ggplot2")

# ---------------Section 1 Pre-processing------------------------------------

# text file directory
folder <- "C:/Users/brahm/Downloads/corpus"

# Building corpus from directory
corpus <- VCorpus(DirSource(directory = folder, pattern = "*.txt"))
corpus

# Tidying the corpus
tidy_corpus <- tidy(corpus)

# Cleaning the corpus dataframe
tidy_corpus <- tidy_corpus[c("id", "text")]


# Analyzing the tidy corpus
tdm = as.matrix(DocumentTermMatrix(corpus))
unique_term_count <- dim(tdm)[2]
unique_term_count

# Extracting reviews from corpus
reviews <- as.vector(tidy_corpus$text)
reviews

#  -----------------------Preprocessing----------------------------------

# '^_^', '¯\\_(ツ)_/¯' these are new emoticon are found in the reviews
# Appending new emotions to emiticon

my.meaning <- c('Happy Face', 'Disappointment')
my.emoticon <- c('^_^', '¯\\_(ツ)_/¯')
new.emotes <- data.frame(my.meaning, my.emoticon)

# give the same column names to those of 'emoticon' dictionary so that they can be merged.
colnames(new.emotes) <- c('meaning', 'emoticon') 
new.emotes

# append 'new.emotes' to the 'emoticon' dictionary.
emoticon <- rbind(emoticon, new.emotes)
tidy_corpus$text <- mgsub(emoticon[,2], emoticon[,1], tidy_corpus$text)


# Since many reviews consists multiple lines so removing new line character
# removing new lines \n from text
tidy_corpus$text <- str_replace_all(tidy_corpus$text, "[\r\n]" , " ")
tidy_corpus$text

# converting to corpus to apply tm_map
review_corpus <- Corpus(VectorSource(tidy_corpus$text))

review_corpus <- tm_map(review_corpus, content_transformer(tolower))


# replacing isolated and irregular words
word <- c("don’t", "i’ve", "i’m", "ain’t", "doesn’t", "wouldn’t", "they’re", 
          "kinks/twists", "it’s", "you’re", "Dyson’s", "friend’s", "you’d", 
          "i’ll", "can’t", "won’t", "didn’t", "con:", "wasn’t", "couldn’t", 
          "shampooed/conditioned", "y’all", "that’s", "mother’s", "ido", 
          "nothave", "110v", "240v", "i’m", "i’ve")
tran <- c('do not', 'i have', 'i am', 'not', "does not", "would not", 
          "they are", "kinks twists", "it", "you are", "dyson", "friends", 
          "you would", "i will", "can not", "will not", "did not", "", 
          "was not", "could not", "shampooed conditioned", "you all", "that", 
          "mother", "i do", "not have", "110 volts", "240 volts", "i am", "i have")

review_corpus <- tm_map(review_corpus, function(x) stri_replace_all_fixed(x, word, tran, vectorize_all = FALSE))

# removing stop word
review_corpus <- tm_map(review_corpus, removeWords, stopwords("en"))

# removing punctuations
review_corpus <- tm_map(review_corpus, removePunctuation)

# stripping whitespaces
review_corpus <- tm_map(review_corpus, stripWhitespace)

# removing numbers
review_corpus <- tm_map(review_corpus, removeNumbers)

# Text stemming - which reduces words to their root form
review_corpus <- tm_map(review_corpus, stemDocument)

# Analyzing after preprocessing
tdm_post = as.matrix(TermDocumentMatrix(review_corpus))
# Counting unique term in corpus after preprocessing
unique_term_count_post <- dim(tdm_post)[1]
unique_term_count_post

# Sort by descearing value of frequency
tdm_v <- sort(rowSums(tdm_post),decreasing=TRUE)

# Getting word and its frequency into dataframe to plot word cloud
tdm_d <- data.frame(word = names(tdm_v),freq=tdm_v)


#generate word cloud post pre processing
set.seed(1234)
wordcloud(words = tdm_d$word, freq = tdm_d$freq, min.freq = 10,
          max.words=100, random.order=FALSE, rot.per=0.40,
          colors=brewer.pal(8, "Dark2"))

#-------------Section 2 Sentimental Analysis-----------------------------

# ---------Sentiment Model 1--------------------------------------------

# Calculating sentiment using qdap library for each sentence
polarity <- qdap::polarity(review_corpus$content)
polarity
# plot with raw polarity value
raw_polarity_plot <- ggplot(polarity$all, aes(x=polarity, y=..density..)) + 
  theme_gdocs() + geom_histogram(binwidth=.11, fill='darkred', colour='gray60', size=.3) + 
  geom_density(size=.65)

# plot with scaled polarity value
scaled_polarity_plot <- ggplot(polarity$all, aes(x=scale(polarity), y=..density..)) + 
  theme_gdocs() + geom_histogram(binwidth=.25, fill='darkred', colour='gray60', size=.3) + 
  geom_density(size=.65)

# plotting the both plots in the same window
cowplot::plot_grid(raw_polarity_plot, scaled_polarity_plot, labels = "AUTO") # Display the plot side by side

#Assigning the sentiment to respective reviews
review_corpus$polarity <- polarity$all$polarity

# Plotting positive and negative word clouds

# extracting positive  and negative reviews
pos.reviews <- subset(review_corpus$content, review_corpus$polarity > 0) # subset positive score comments
neg.reviews <- subset(review_corpus$content, review_corpus$polarity <= 0) # subset negative score comments

# Prepping reviews for word cloud
pos.reviews <- as.vector(pos.reviews) # convert to character data from factor
neg.reviews <- as.vector(neg.reviews) # convert to character data from factor
pos.reviews <- paste(pos.reviews, collapse=" ")
neg.reviews <- paste(neg.reviews, collapse=" ")

# combining positive and negative reviews for DTM
all.reviews <- c(pos.reviews, neg.reviews)

# build a corpus that contains two docs: (1) positive terms, and (2) negative terms 
all.reviews <- VCorpus(VectorSource(all.reviews))

# build a term-doc-matrix using tfidf weighting algorithm
all.tdm <- TermDocumentMatrix(all.reviews, control=list(weighting=weightTfIdf, 
                                                       removePunctuation=TRUE, 
                                                       stopwords(kind='en')))
# formatting dtm matrx
all.tdm.m <- as.matrix(all.tdm)
colnames(all.tdm.m) <- c('positive', 'negative')

# plotting word cloud with positive and negative terms
wordcloud::comparison.cloud(all.tdm.m, max.words=100, 
                            colors=c('darkgreen', 'darkred'))

# ------------------sentiment model 2-----------------------------------

# Calculating sentiment using Bing lexicon approach
bing <- data.frame(get_sentiments("bing"))
review.dtm <- DocumentTermMatrix(review_corpus) # tf algorithm used

#tidying the dtm
review.tidy <- tidy(review.dtm)

#Assigining column names
colnames(review.tidy) <- c('line_number', 'word', 'count')

# joining review dtm with bing dataframe to calculate the sentiment
review.sentiment <- inner_join(review.tidy, bing)
review.sentiment
# Counting the negative and positive words per review
review.sentiment2 <- count(review.sentiment, sentiment, index=line_number) 
review.sentiment2

# Filling missing value with zeros
review.sentiment2 <- spread(review.sentiment2, sentiment, n, fill=0)

# Calculating the polarity
review.sentiment2$polarity <- review.sentiment2$positive - review.sentiment2$negative
review.sentiment2
# Building sentiment column
review.sentiment2$pos <- ifelse(review.sentiment2$polarity > 0, "pos", "neg")

# draw a bar plot using ggplot() to show polarity of each review
review.barchart <- ggplot(review.sentiment2, aes(x=index, y=polarity, fill=pos)) + 
  geom_bar(stat="identity", position = "identity", width=5) + 
  theme_gdocs()

review.sentiment2$index <- as.numeric(review.sentiment2$index)
# add smooth lines to improve visuals with a generalized additive model(GAM)
# GAM fits a linear model to polarity values
review.smoothgraph <- ggplot(review.sentiment2, aes(index, polarity)) + 
  stat_smooth() + theme_gdocs()

library(gridExtra)
grid.arrange(review.barchart, review.smoothgraph, ncol=2)

# -----------------------------------Emotion Classificaiton----------------

# nrc sentiment analysis to return data frame with each row classified as 
# emotions, rather than a score: 

emotions<-get_nrc_sentiment(review_corpus$content)

#transposing for plotting the emotions
emotions_df<-data.frame(t(emotions))

#The function rowSums computes column sums across rows for each level of a grouping variable.
emotions_df_new <- data.frame(rowSums(emotions_df[1:40]))

#Transformation and cleaning
names(emotions_df_new)[1] <- "count"
emotions_df_new <- cbind("emotions" = rownames(emotions_df_new), emotions_df_new)
rownames(emotions_df_new) <- NULL

# Plotting all emotions except positive and negative sentiment
emotions_new<-emotions_df_new[1:8,]

#Plot One - count of words associated with each sentiment
quickplot(emotions, data=emotions_new, weight=count, geom="bar", fill=emotions, ylab="count")+ggtitle("Survey emotions")
