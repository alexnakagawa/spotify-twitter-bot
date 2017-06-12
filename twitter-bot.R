library(twitteR)
library(ROAuth)
library(dplyr)
library(rvest)

#WebScrappe Spotify Top Songs from Sotifycharts.com
spotify_top_songs <- read_html("https://spotifycharts.com/regional/global/daily/latest") %>%
  html_node("#content > div > div > div > span > table") %>% html_table(trim = TRUE)


#Add Column Names to the spotify_top_songs    
colnames(spotify_top_songs) = c("NA1","Rank","NA2","Track","Streams")

#Remove Empty Columns
spotify_top_songs$NA1 = NULL
spotify_top_songs$NA2 = NULL

#Remove "\n" frome every Track
spotify_top_songs = lapply(spotify_top_songs, function(x){ gsub("\n ", "", x)})

#Failed Attempts to Remove WhiteSpaces
#spotify_top_songs$Track = lapply(spotify_top_songs$Track, function(x){ gsub("                                       ", "", x)})

 #get rid of whitespace in "Trackname"

 #add links to table
 
 spotify = read_html("https://spotifycharts.com/regional/global/daily/latest")

 
 spotify_link <- html_nodes(spotify, xpath = '//*[@id="content"]/div/div/div/span/table/tbody/tr/td[1]/a')
 
 links<- data.frame(url = html_attr(spotify_link, name = "href"))
 
 spotify_songs = cbind(spotify_top_songs, links)
 
#Twitter \stuff
 
  current_post <- str_c(sprintf("Spotify's Global Picks of the Day- %d : %s , %d : %s, %d : %s ", Rank1, Track1, Rank2, Track2, Rank3, Track3))
 
 tweet(current_post)
 
 #-----------------