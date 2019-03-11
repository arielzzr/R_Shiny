#load files
all = read.csv('/Users/mimi/Desktop/youtube-all/All_country.csv', stringsAsFactors = FALSE)
all_no_spread = all %>% group_by(category_title, location) %>% 
  summarise(.,  count = n())
all_spread = spread(all_no_spread, location, count)
all_spread[is.na(all_spread)] <- 0
all_spread = as.data.frame(all_spread)

write.csv(all_spread, 'All_spread.csv', row.names = FALSE)
write.csv(all_no_spread, 'All_no_spread.csv', row.names = FALSE)

# add title, tags for wc 
# therefore change previous all_corr_data
all_corr = all %>% 
  select(c('Video Category' = "category_id", 'Views' = "views", 'Likes' ="likes", 
           'Dislikes' = "dislikes", 'Comments' = "comment_count", 'location', 
           'Category Title' = 'category_title', 'title', 'tags'))

write.csv(all_corr, "All_corr.csv", row.names = FALSE)
