library(twitteR)
library(ROAuth)

library(rvest)

spotify_top_songs <- read_html("https://spotifycharts.com/regional") %>% html_nodes("#content > div > div > div > span > table")%>% html_table(trim = TRUE)
 spotify_top_songs
View(spotify_top_songs)

#
 
 current_post <- str_c(sprintf("Spotify's Global Picks of the Day- %d : %s , %d : %s, %d : %s ", Rank1, Track1, Rank2, Track2, Rank3, Track3))
 
 tweet(current_post)