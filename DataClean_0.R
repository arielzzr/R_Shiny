# load files
# goal: merge csv and json file; remove videos that have error and removed
us = read.csv('USvideos.csv', stringsAsFactors = FALSE)
gb = read.csv('GBvideos.csv', stringsAsFactors = FALSE)
ca = read.csv('CAvideos.csv', stringsAsFactors = FALSE)
de = read.csv('DEvideos.csv', stringsAsFactors = FALSE)
fr = read.csv('FRvideos.csv', stringsAsFactors = FALSE)

us_cat_json <- fromJSON(file = "US_category_id.json")
gb_cat_json <- fromJSON(file = "GB_category_id.json")
ca_cat_json <- fromJSON(file = "CA_category_id.json")
de_cat_json <- fromJSON(file = "DE_category_id.json")
fr_cat_json <- fromJSON(file = "FR_category_id.json")
us_category = data.frame()
gb_category = data.frame()
ca_category = data.frame()
de_category = data.frame()
fr_category = data.frame()

# combine json and csv
i = 1
while(i<=32){
  row = cbind(us_cat_json[["items"]][[i]][["id"]], 
              us_cat_json[["items"]][[i]][["snippet"]][["title"]])
  us_category = rbind(us_category, row)
  i = i+1
}
us_category = as.data.frame(us_category)
names(us_category) = c('category_id', 'category_title')
#us_category

i = 1
while(i<=31){
  row = cbind(gb_cat_json[["items"]][[i]][["id"]], 
              gb_cat_json[["items"]][[i]][["snippet"]][["title"]])
  gb_category = rbind(gb_category, row)
  i = i+1
}
gb_category = as.data.frame(gb_category)
names(gb_category) = c('category_id', 'category_title')
#gb_category

i = 1
while(i<=31){
  row = cbind(ca_cat_json[["items"]][[i]][["id"]], 
              ca_cat_json[["items"]][[i]][["snippet"]][["title"]])
  ca_category = rbind(ca_category, row)
  i = i+1
}
ca_category = as.data.frame(ca_category)
names(ca_category) = c('category_id', 'category_title')
#ca_category

i = 1
while(i<=31){
  row = cbind(de_cat_json[["items"]][[i]][["id"]], 
              de_cat_json[["items"]][[i]][["snippet"]][["title"]])
  de_category = rbind(de_category, row)
  i = i+1
}
de_category = as.data.frame(de_category)
names(de_category) = c('category_id', 'category_title')
#de_category

i = 1
while(i<=31){
  row = cbind(fr_cat_json[["items"]][[i]][["id"]], 
              fr_cat_json[["items"]][[i]][["snippet"]][["title"]])
  fr_category = rbind(fr_category, row)
  i = i+1
}
fr_category = as.data.frame(fr_category)
names(fr_category) = c('category_id', 'category_title')
#fr_category

us <- merge(x = us, y = us_category, by = "category_id", all = "TRUE")
gb <- merge(x = gb, y = gb_category, by = "category_id", all = "TRUE")
ca <- merge(x = ca, y = ca_category, by = "category_id", all = "TRUE")
de <- merge(x = de, y = de_category, by = "category_id", all = "TRUE")
fr <- merge(x = fr, y = fr_category, by = "category_id", all = "TRUE")

library(dplyr)
us <- filter(us, video_error_or_removed == 'False')
gb <- filter(gb, video_error_or_removed == 'False')
de <- filter(de, video_error_or_removed == 'False')
ca <- filter(ca, video_error_or_removed == 'False')
fr <- filter(fr, video_error_or_removed == 'False')

write.csv(us, file = 'US0.csv', row.names = FALSE)
write.csv(gb, file = 'GB0.csv', row.names = FALSE)
write.csv(de, file = 'DE0.csv', row.names = FALSE)
write.csv(ca, file = 'CA0.csv', row.names = FALSE)
write.csv(fr, file = 'FR0.csv', row.names = FALSE)

