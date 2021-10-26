##################################
### Code Completion Assignment ###
##################################

# Your goal is to complete the following skeleton code so that the script can be executed
# the three *** indicate where you need to to insert the correct code 

# stringr & regular expressions -------------------------------------------

addresses <-c("221B Baker St., London", "1600 Pennsylvania Avenue, Washington D.C.", 
              "742 Evergreen Terrace, Springfield")

sentences <- stringr::sentences[1:20]

field_names <- c("order_number", "order_date", "customer_email", "product_title", "amount")

email <- c("tom@hogwarts.com",
           "tom.riddle@hogwarts.com",
           "tom@hogwarts.eu.com",
           "potter@hogwarts.com",
           "harry@hogwarts.com",
           "hermione+witch@hogwarts.com")

files <- c(".bash_profile",
           "workspace.doc",
           "img0912.jpg",
           "updated_img0912.png",
           "documentation.html",
           "favicon.gif",
           "img0912.jpg.tmp",
           "access.lock")

#convert addresses to lower-case.

library(***)
str_***(string = addresses)

#extract digits from addresses

str_***(string = addresses, pattern = "***")

#split addresses into two parts: street & city

str_***(string = addresses, pattern = "***", simplify = T)

#split addresses into three parts: house number, street & city

str_split(string = addresses, pattern = "***", simplify = T)

#For sentences that end with the letter “t” extract the last word

str_***(string = sentences, pattern = "***")

#Extract the first 30 characters from each sentence

str_***(string = sentences, ***, ellipsis = "...")

#replace all underscores in field_names with spaces and capitalize the first letter of each word

str_replace_all(***) %>% 
  str_***

#extract names appearing before @ from email 
  
str_extract(email, "***")

#extract the three images (.jpg, .png, .gif) from files

str_extract(files, "***")


# web scraping & tidytext -------------------------------------------------

library(***)
library(tidytext)

#extract the text of J.K. Rowling's commencement speech at Harvard University

url <- "https://news.harvard.edu/gazette/story/2008/06/text-of-j-k-rowling-speech/"
speech <- ***

#convert the text to a tibble, remove the first line ("Text as Delivered") 
# and the 15th line ("Sign up for daily emails to get the latest Harvard news.")
# and add a column with a number for each paragraph
  
speech_df <- tibble(text = speech) %>% 
 slice(***) %>% 
  ***

#tokenize the text into words and remove stop words

speech_df <- speech_df %>% 
  *** %>% 
  ***(stop_words)

#list the 5 most frequent words

speech_df %>% 
  ***

# Reading in text ---------------------------------------------------------
library(readtext)
library(quanteda)

#read in the UK manifestos from the course's data folder, 
#create document names for party and year from file names
manifestos <- readtext("data/UK_manifestos/*.txt", 
                       docvarsfrom= ***,
                       docvarnames = ***)

# create a corpus out of the documents
manifesto_corpus <- ***(manifestos)
summary(manifesto_corpus)

# overwrite the party column with these new labels: Conservatives, Labour, LibDems
party <- c(***)
***   <- party
summary(manifesto_corpus)

#tokenize the text into words, remove numbers and punctuations, and convert it to lower case
#and find out in which context the parties mention words containing europe
manifesto_tokens <- ***
  
kwic(manifesto_tokens, "***")

#now remove stop words from the text using the smart source 
#and tokenize the manifestos into bigrams 
manifesto_bigrams<- manifesto_tokens %>% 
  tokens_***(***) %>% 
  tokens_***(n=2)

#create a document feature matrix from the manifesto bigrams 
#and keep only the party manifestos from the Liberal Democrats
manifesto_dfm <- ***(manifesto_bigrams) %>% 
  ***(***)

#find out how many bigrams appear only once

