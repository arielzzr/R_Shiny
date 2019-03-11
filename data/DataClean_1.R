# load files
# goal: create all_coutry file. Create data format publish/trend date, integer publish time, diff_time
# goal: drop unused columns: 'video_id', 'channel_title','channel_title', 'thumbnail_link', 'video_error_or_removed'
# next step: may drop ‘comment_disabled' and ‘ratings_disabled’ columns 
# next step: further reduce dataset depend on graphs
library(lubridate)
library(dplyr)
us0 = read.csv('US0.csv', stringsAsFactors = FALSE)
gb0 = read.csv('GB0.csv', stringsAsFactors = FALSE)
ca0 = read.csv('CA0.csv', stringsAsFactors = FALSE)
de0 = read.csv('DE0.csv', stringsAsFactors = FALSE)
fr0 = read.csv('FR0.csv', stringsAsFactors = FALSE)


us0$trending_date = ydm(us0$trending_date)
us0$publish_date = ymd(substr(us0$publish_time, start = 1, stop = 10))
us0$publish_time = hour(strptime(substr(us0$publish_time, start = 12, stop = 13), '%H'))
us0$dif_days = us0$trending_date - us0$publish_date

gb0$trending_date = ydm(gb0$trending_date)
gb0$publish_date = ymd(substr(gb0$publish_time, start = 1, stop = 10))
gb0$publish_time = hour(strptime(substr(gb0$publish_time, start = 12, stop = 13), '%H'))
gb0$dif_days = gb0$trending_date - gb0$publish_date

ca0$trending_date = ydm(ca0$trending_date)
ca0$publish_date = ymd(substr(ca0$publish_time, start = 1, stop = 10))
ca0$publish_time = hour(strptime(substr(ca0$publish_time, start = 12, stop = 13), '%H'))
ca0$dif_days = ca0$trending_date - ca0$publish_date

de0$trending_date = ydm(de0$trending_date)
de0$publish_date = ymd(substr(de0$publish_time, start = 1, stop = 10))
de0$publish_time = hour(strptime(substr(de0$publish_time, start = 12, stop = 13), '%H'))
de0$dif_days = de0$trending_date - de0$publish_date

fr0$trending_date = ydm(fr0$trending_date)
fr0$publish_date = ymd(substr(fr0$publish_time, start = 1, stop = 10))
fr0$publish_time = hour(strptime(substr(fr0$publish_time, start = 12, stop = 13), '%H'))
fr0$dif_days = fr0$trending_date - fr0$publish_date

remove = c('video_id', 'channel_title','channel_title', 'thumbnail_link', 'video_error_or_removed')
us0 <- us0[, !colnames(us0) %in% remove]
gb0 <- gb0[, !colnames(gb0) %in% remove]
ca0 <- ca0[, !colnames(ca0) %in% remove]
de0 <- de0[, !colnames(de0) %in% remove]
fr0 <- fr0[, !colnames(fr0) %in% remove]


#remove NAs
us0 <- us0[complete.cases(us0),] #retur rows with no missing values
gb0 <- gb0[complete.cases(gb0),]
de0 <- de0[complete.cases(de0),]
ca0 <- ca0[complete.cases(ca0),]
fr0 <- fr0[complete.cases(fr0),]
head(us0)

us_loc <- mutate(us0, location = 'USA')
gb_loc <- mutate(gb0, location = 'UK')
ca_loc <- mutate(ca0, location = 'Canada')
de_loc <- mutate(de0, location = 'Germany')
fr_loc <- mutate(fr0, location = 'France')

all_country <- rbind(us_loc, gb_loc, ca_loc, de_loc, fr_loc)
dim(all_country)

write.csv(all_country, file = 'All_country.csv', row.names = FALSE)
write.csv(us0, file = 'US1.csv', row.names = FALSE)
write.csv(gb0, file = 'GB1.csv', row.names = FALSE)
write.csv(ca0, file = 'CA1.csv', row.names = FALSE)
write.csv(de0, file = 'DE1.csv', row.names = FALSE)
write.csv(fr0, file = 'FR1.csv', row.names = FALSE)

