library(dplyr)
all_corr = read.csv('All_corr.csv', stringsAsFactors = FALSE)
all_wc = all_corr %>% 
  select(., c('location','Category.Title', 'title', 'tags'))

# word cloud for each country's videos
# Here's an example for Germany
category_germany = c("Film & Animation", "Music", "Pets & Animals","Sports","Travel & Events","Autos & Vehicles","Gaming",
                     "People & Blogs","Comedy","Entertainment","News & Politics","Howto & Style","Education","Science & Technology",  
                     "Movies","Shows","Trailers")  

Gr_data = all_wc %>% 
  filter(., location == 'Germany') %>% select(., Category.Title, title, tags)

final = data.frame()
i = 1
for (i in 1:16){
  start_title = Gr_data %>% 
    filter(., Category.Title == category_germany[i]) %>%
    select(., title)
  
  start_tag = Gr_data %>% 
    filter(., Category.Title == category_germany[i]) %>%
    select(., tags)
  
  # corpus title
  text_title = list(start_title$title)
  Corpus_title = Corpus(VectorSource(text_title))
  Corpus_title = tm_map(Corpus_title, content_transformer(tolower))
  Corpus_title = tm_map(Corpus_title, removePunctuation)
  Corpus_title = tm_map(Corpus_title, removeNumbers)
  Corpus_title = tm_map(Corpus_title, removeWords,
                        c(stopwords("SMART"), "thy", "thou", "thee", "the", "and", "but"))
  
  DTM_title = TermDocumentMatrix(Corpus_title,
                                 control = list(minWordLength = 1))
  m_title = as.matrix(DTM_title)
  v_title = sort(rowSums(m_title), decreasing = TRUE)
  
  # corpus tags
  text_tag = list(start_tag$tags)
  Corpus_tag = Corpus(VectorSource(text_tag))
  Corpus_tag = tm_map(Corpus_tag, content_transformer(tolower))
  Corpus_tag = tm_map(Corpus_tag, removePunctuation)
  Corpus_tag = tm_map(Corpus_tag, removeNumbers)
  Corpus_tag = tm_map(Corpus_tag, removeWords,
                      c(stopwords("SMART"), "thy", "thou", "thee", "the", "and", "but"))
  
  DTM_tag = TermDocumentMatrix(Corpus_tag,
                               control = list(minWordLength = 1))
  m_tag = as.matrix(DTM_tag)
  v_tag = sort(rowSums(m_tag), decreasing = TRUE)
  
  # build data frame
  title.word = names(v_title[1:300])
  title.frequency = v_title[1:300]
  tag.word = names(v_tag[1:300])
  tag.frequency = v_tag[1:300]
  category = rep(category_germany[i], 300)
  country = rep('Germany', 300)
  temp = data.frame(country, category, title.word, title.frequency,tag.word,tag.frequency)
  final = rbind(final, temp)
  i = i+1
}
final = final[complete.cases(final),]
write.csv(final, file = "Germany_wc.csv", row.names = FALSE)


# after repeating previous steps for all countries, combine all files
getwd()
setwd("/Users/mimi/Desktop/")
us = read.csv("USA_wc.csv", stringsAsFactors = FALSE)
ca = read.csv("Canada_wc.csv", stringsAsFactors = FALSE)
gr = read.csv("Germany_wc.csv", stringsAsFactors = FALSE)
fr = read.csv("France_wc.csv", stringsAsFactors = FALSE)
uk = read.csv("UK_wc.csv", stringsAsFactors = FALSE)
all_wc = rbind(us, ca, gr, fr, uk)
write.csv(all_wc, file = "All_wc.csv", row.names = FALSE)
