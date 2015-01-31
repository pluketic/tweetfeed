library(twitteR)
library(plyr)
library(maps)
library(streamR)

# to load saved twitter authorization
# set up following the process at this page
# https://sites.google.com/site/dataminingatuoc/home/data-from-twitter/r-oauth-for-twitter

load("twitteR_creds")
registerTwitterOAuth(twitCred)

tweets <- filterStream(file.name="",track="snow", timeout=180, oauth=twitCred)
#,locations=c(-126,24,-65,49)

# To convert list to dataframe from filterStream
tweets.tmp <- parseTweets(tweets)

#select tweets with geocodes (use "lat" for stream "latitude" for search)
lltweets.tmp <- subset(tweets.tmp, lat!="NA")

#append tweets to existing file
tweets.df <- rbind.fill(tweets.df, lltweets.tmp)
#tweets.df <- lltweets.tmp


#list only longitude values
#tweets$longitude

map('usa')
points(tweets.df$lon, tweets.df$lat)


download.file(url="http://curl.haxx.se/ca/cacert.pem",
destfile="cacert.pem")

requestURL <- "https://api.twitter.com/oauth/request_token"

accessURL <- "https://api.twitter.com/oauth/access_token"

authURL <- "https://api.twitter.com/oauth/authorize"

consumerKey <- "AJNMXdEsy0mA7l6vWxkQ"
consumerSecret <- "aB3GXuEobR8PS7obTrG8eN7m3tkqhOUTexUpNmhG0"

twitCred <- OAuthFactory$new(consumerKey=consumerKey,
                             consumerSecret=consumerSecret,
                             requestURL=requestURL,
                             accessURL=accessURL,
                             authURL=authURL)

twitCred$handshake(cainfo="cacert.pem")