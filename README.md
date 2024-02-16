# Sentiment-Analysis-Mini-Project
## Background
Customer reviews are particularly important for product-based companies. Ratings and reviews create a great avenue for these businesses to get current content on their site and bring attention to their product. Also, Analysing the sentiment of these reviews, they can work and improve upon their future products for better customer satisfaction.
In this mini project, Amazon data has been collected which includes the reviews from customers on a hair styling product called dyson supersonic hair dryer. Using the data collected, Sentiment analysis has been performed to analyse the sentiment of each customer review and analyze key words used in the reviews.

## Objectives
The objectives of this sentiment analysis are to:
- Identifying and obtaining the sentiment of each review.
- Getting the most positive impact words and negative words.
- Identifying and getting various emotions that were displayed in the reviews.
- Analysing the sentiment distribution across the reviews

## Methodology
In this project, The Amazon Data collected is in the text format, and the corpus that has been built contains 40 text files. The Text files include the customer reviews collected from a product on amazon called the Dyson supersonic dryer and performed Sentiment Analysis.

## Data Cleaning Procedure
-	There were emoticons in the reviews collected, these were replaced by their meanings. Some of the emoticons present in the dataset were not available in the emoticon package so, these meanings have been appended.
-	Since the data has reviews which were multi lined, line breaks have been removed.
- The data has been converted to lowercase because it helps to maintain the consistency flow during sentiment analysis.
- After carefully analysing the words in the corpus, there were some unique and irregular words which had to be replaced for e.g., “110v” was replaced with “110 volts” 
- The punctuations have been removed as they are not informative and they just add up noise that makes the corpus complicated to analyze and by removing them, we can analyze the data efficiently.
- While dealing with any English sentences there are many words that do not bring any new information and they just create redundancy which just makes everything complicated so, The stop words have been removed, removing these words will help clean the data and we can focus on important words which carry information about the sentiment.
- Removed all the Whitespaces, all the extra whitespaces between two words will be stripped off making the data easy to work with.
- Stemming has been performed to break the words into their root forms. 

## Data Analysis
Sentiment analysis was employed in this project since it has various business benefits and is an efficient and reliable tool for assessing any product’s performance and we can identify the brand experience insights and also the customer reviews and improve the customer service accordingly. It also helps manage company’s brand reputation by enabling them to make timely decisions on how to respond to negative brand mentions and thus avert risks.

Three methods were employed for sentiment analysis in the project:
- Method 1: sentiments were analysed using “qdab” library. By using this library, the polarities of each of the pre-processed reviews were calculated. Document term matrix was created using tf-idf algorithm for both positive and negative reviews. Using this Document term matrix Word clouds were plotted to show the most impactful positive and negative words in the reviews.
- Method 2: Sentiments were analysed using “Bing” lexicon analysis method.before applying this method, The document term matrix was created using the pre-processed corpus. The document term matrix was converted into dataframe using “Tidy” library.and this dataframe is joined with”Bing” library to get the sentiment of their respective words.The total number of positive words and negative words have been identified for each review. And the polarity was calculated by getting the difference between the positive and negitive words. After that, the distribution of polarities across the reviews been plotted, The overall sentiments of the customer reviews have been identified.
- Method 3: Sentiments were analysed using “NRC” lexicon method, this method outputs the number of words describing various emotions like “anger”, “anticipation”, “disgust”, “fear”, “joy”, “surprise”, “sadness”, and “trust”, along with the positive and negative counts for each review in the corpus. The count for each emotion is aggregated across the corpus to plot the distribution of emotions across the reviews.
  
## Limitations
1.	Here the project focusses only on reviews in English but amazon has a large amount of international audience. This approach should be extended to classify sentiment with a language specific positive/negative keyword list in other languages as well.
2.	The data collected is handpicked for this project, It does not represent the whole population sentiment who purchased this product. To address this a more holistic sample has to be analysed.
3.	The sentiments derived from the lexicon approach is not robust to slang terms and technical terms that were used in the reviews. This can be addressed by using state of art machine learning language models.
 
## Recommendations
Based on the results from the sentiment analysis the following recommendations are made:
- Dyson should work on removing counterfeits which was a major concern of the customers writing negative reviews.
- Dyson should work on improving longevity of the products because the second most impactful negative word is “Repair”. They also should work on better customer service for their damaged products.
- The third most impactful negative word is “die” which might be caused due to the batteries and power issues. Dyson should make their products compatible across various voltage ranges. 




