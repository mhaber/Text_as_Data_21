##################################
### Code Completion Assignment ###
##################################

# Your goal is to complete the following skeleton code so that the script can be executed

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
library(stringr)
str_to_lower(string = addresses)

#extract digits from addresses
str_extract(string = addresses, pattern = "[:digit:]+")

#split addresses into two parts: street & city
str_split(string = addresses, pattern = ", ", simplify = T)

#split addresses into three parts: house number, street & city
str_split(string = addresses, pattern = "(?<=[:digit:].) |, ", simplify = T)

#For sentences that end with the letter “t” extract the last word
str_extract_all(string = sentences, pattern = "[A-z]+t\\.$")

#Extract the first 30 characters from each sentence
str_trunc(string = sentences, width = 30, ellipsis = "...")

#replace all underscores in field_names with spaces and capitalize the first letter of each word
str_replace_all(string = field_names, pattern = "_", replacement = " ") %>% 
  str_to_title()

#extract names appearing before @ from email 
str_extract(email, "^[\\w\\.\\+]*")

#extract the three images (.jpg, .png, .gif) from files
str_extract(files, ".*\\.(jpg|png|gif)$")


# web scraping & tidytext -------------------------------------------------
library(rvest)
library(tidytext)

#extract the text of J.K. Rowling's commencement speech at Harvard University

url <- "https://news.harvard.edu/gazette/story/2008/06/text-of-j-k-rowling-speech/"
speech <- read_html(url) %>% 
  html_nodes(".article-body p") %>% 
  html_text()

#convert the text to a tibble, remove the first line ("Text as Delivered") 
# and the 15th line ("Sign up for daily emails to get the latest Harvard news.")
# and add a column with a number for each paragraph

speech_df <- tibble(text = speech) %>% 
 slice(c(2:14,16:n())) %>% 
  mutate(paragraphs = row_number())

#tokenize the text into words and remove stop words

speech_df <- speech_df %>% 
  unnest_tokens(word, text) %>% 
  anti_join(stop_words)

#list the 5 most frequent words

speech_df %>% 
  count(word, sort = TRUE) %>% 
  top_n(5)

# Reading in text ---------------------------------------------------------
library(readtext)
library(quanteda)

#read in the UK manifestos from the course's data folder, 
#create document names for party and year from file names
manifestos <- readtext("data/UK_manifestos/*.txt", 
                       docvarsfrom= "filenames", dvsep = "-",
                       docvarnames = c("party", "year"))

# create a corpus out of the documents
manifesto_corpus <- corpus(manifestos)
summary(manifesto_corpus)

# overwrite the party column with these new labels: Conservatives, Labour, LibDems
party <- c(rep("Conservatives", 6), rep("Labour", 6), rep("LibDems", 6))
manifesto_corpus$party <- party
summary(manifesto_corpus)

#tokenize the text into words, remove numbers and punctuations, and convert it to lower case
#and find out in which context the parties mention words containing europe
manifesto_tokens <- tokens(manifesto_corpus, what = "word", 
                           remove_numbers = TRUE,
                           remove_punct = TRUE) %>% 
  tokens_tolower()
kwic(manifesto_tokens, "europe*")

#now remove stop words from the text using the smart source 
#and tokenize the manifestos into bigrams 
manifesto_bigrams<- manifesto_tokens %>% 
  tokens_remove(stopwords("en", source = "smart")) %>% 
  tokens_ngrams(n=2)

#create a document feature matrix from the manifesto bigrams 
#and keep only the party manifestos from the Liberal Democrats
manifesto_dfm <- dfm(manifesto_bigrams) %>% 
  dfm_subset(., party == "LibDems")

#find out how many bigrams appear only once
manifesto_dfm %>% 
  dfm_trim(min_termfreq = 1, max_termfreq = 1) %>% 
  nfeat()
