install.packages("xlsx")

library(twitteR)
library(plyr)
library(maps)
library(streamR)
library(xlsx)

setwd ("C:/Users/Tim/Documents/NRE639")

# to load saved twitter authorization
# set up following the process at this page
# https://sites.google.com/site/dataminingatuoc/home/data-from-twitter/r-oauth-for-twitter

Set constant requestURL
#
requestURL = "https://api.twitter.com/oauth/request_token"
#
# Set constant accessURL
#
accessURL = "https://api.twitter.com/oauth/access_token"
#
# Set constant authURL
#
authURL = "https://api.twitter.com/oauth/authorize"

consumerKey = "AJNMXdEsy0mA7l6vWxkQ"
consumerSecret = "aB3GXuEobR8PS7obTrG8eN7m3tkqhOUTexUpNmhG0"

twitCred = OAuthFactory$new(consumerKey=consumerKey,
                             consumerSecret=consumerSecret,
                             requestURL=requestURL,
                             accessURL=accessURL,
                             authURL=authURL)
twitCred$handshake(cainfo="cacert.pem")
registerTwitterOAuth(twitCred)

save(list="twitCred", file="twitteR_credentials")

load("twitteR_creds")
registerTwitterOAuth(twitCred)

tweets <- filterStream(file.name="",track="", timeout=90, oauth=twitCred)
#,locations=c(-126,24,-65,49)

# To convert list to dataframe from filterStream
tweets.tmp <- parseTweets(tweets)

#select tweets with geocodes (use "lat" for stream "latitude" for search)
lltweets.tmp <- subset(tweets.tmp, lat!="NA")

map('world')
points(lltweets.tmp$lon, lltweets.tmp$lat)

write.xlsx(tweets.tmp, "snow.xlsx")
