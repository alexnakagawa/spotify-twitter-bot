library(twitteR)
library(ROAuth)
library(dplyr)
library(rvest)
library(magrittr)

# Read and scrape Spotify Top Songs from spotifycharts.com
spotify_top_songs <- read_html("https://spotifycharts.com/regional/global/daily/latest") %>%
  html_node("#content > div > div > div > span > table") %>% html_table(trim = TRUE)

# Add Column Names to the spotify_top_songs    
colnames(spotify_top_songs) = c("NA1","Rank","NA2","Track","Streams")

# Remove empty columns
spotify_top_songs$NA1 = NULL
spotify_top_songs$NA2 = NULL

# Remove "\n" frome every Track
spotify_top_songs = lapply(spotify_top_songs, function(x){ gsub("\n ", "", x)})

# Get rid of whitespace in "Trackname"
spotify_top_songs = lapply(spotify_top_songs, function(x){ gsub("\\s+", " ", x)})

# Add links to table
 
spotify_link = read_html("https://spotifycharts.com/regional/global/daily/latest") %>%
  html_nodes(xpath = '//*[@id="content"]/div/div/div/span/table/tbody/tr/td[1]/a')
 
links <- data.frame(url = html_attr(spotify_link, name = "href"))
spotify_top_songs = cbind(spotify_top_songs, links)
spotify_top_songs %>% mutate_if(is.factor, as.character) -> spotify_top_songs
View(spotify_top_songs)
spotify_top_songs

# Twitter Format: Top 3 streamed songs of the day??
library(stringr)
spotify_post_1<- str_c(sprintf("The 3rd most streamed song of the day is: %s with %s streams! URL: %s", spotify_top_songs$Track[3], spotify_top_songs$Streams[3], spotify_top_songs$url[3]))
spotify_post_2<- str_c(sprintf("The 2nd most streamed song of the day is: %s with %s streams! URL: %s", spotify_top_songs$Track[2], spotify_top_songs$Streams[2], spotify_top_songs$url[2]))
spotify_post_3 <- str_c(sprintf("The Top Song of the day is: %s with %s streams. URL: %s", spotify_top_songs$Track[1], spotify_top_songs$Streams[1], spotify_top_songs$url[1]))
spotify_post_4 <- str_c(sprintf("Your Spotify Daily Top Streamed Songs for %s", as.character(Sys.Date())), ":")

tweet(spotify_post_1)
tweet(spotify_post_2)
tweet(spotify_post_3)
tweet(spotify_post_4)
