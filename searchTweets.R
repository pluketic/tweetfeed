library(twitteR)
library(plyr)
library(maps)

# to load saved twitter authorization
# set up following the process at this page
# https://sites.google.com/site/dataminingatuoc/home/data-from-twitter/r-oauth-for-twitter

load("twitteR_creds")
registerTwitterOAuth(twitCred)

tweets <- searchTwitter("#snow",n=500, cainfo="cacert.pem", geocode='39,-98,2500km')


# To view the list 
# gb.tweets

# To view the sixth item in the list 
#  str(gb.tweets[[6]])

# To convert list to dataframe from searchTwitter
tweets.tmp = ldply(tweets, function(t) t$toDataFrame() )

#select tweets with geocodes 
lltweets.tmp <- subset(tweets.tmp, latitude!="NA")

#append tweets to existing file
#tweets.df <- rbind.fill(tweets.df, lltweets.tmp)
tweets.df <- lltweets.tmp

#or this
#lltweets.df <- tweets.df[which(tweets.df$latitude!="NA"),]



#list latitude and longitude of the sixth item in dataframe
#tweets[[6]]$latitude
#tweets[[6]]$longitude

#list only longitude values
#tweets$longitude

map('usa')
points(tweets.df$longitude, tweets.df$latitude)
