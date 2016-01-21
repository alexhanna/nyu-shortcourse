setwd("~/git/data-science-workshop/sna")
#install.packages("devtools")
#devtools::install_github("pablobarbera/twitter_ideology/pkg/tweetscores")
library(tweetscores)

# download congress data
congress <- scrapeCongressData()

# keeping only those with a twitter account
congress <- congress[!is.na(congress$twitter),]

# downloading users data from Twitter and merging with Congress data
users <- getUsersBatch(screen_names=congress$twitter, 
	oauth_folder="~/Dropbox/credentials/twitter")
users$merge <- tolower(users$screen_name)
congress$merge <- tolower(congress$twitter)
congress <- merge(congress, users[,c("merge", "id_str", "followers_count")])

# download friends lists
friends.list <- list()

for (i in 1:nrow(congress)){
	message(i, '/', nrow(congress))
	friends.list[[i]] <- getFriends(screen_name=congress$twitter[i], 
		oauth_folder='~/Dropbox/credentials/twitter', verbose=FALSE)
}

# preparing edge list
user.ids <- congress$id_str
mat <- matrix(NA, nrow=length(user.ids), ncol=length(user.ids))
for (i in 1:length(user.ids)){
    mat[i,] <- user.ids %in% friends.list[[i]]
    message(i, '/', length(user.ids))
}
dimnames(mat) <- list(user.ids, user.ids)
save(mat, file="congress-adjacency-matrix-2016.rdata")

# exporting to gephi
library(igraph)
g <- graph.adjacency(mat, mode="directed") ## igraph object

edgelist <- get.edgelist(g) ## edgelist
df <- data.frame(edgelist, stringsAsFactors=F)
names(df) <- c("source", "target")

write.csv(df, file="congress-twitter-network-edges.csv", row.names=F)

nodes <- congress[,c("id_str", "twitter", "bioid", "name", "gender", "type", "party", "followers_count")]
names(nodes)[6] <- "chamber"

write.csv(nodes, file="congress-twitter-network-nodes.csv", row.names=FALSE)





