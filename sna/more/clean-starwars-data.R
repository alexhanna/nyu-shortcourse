setwd("~/git/data-science-workshop/sna")
library(jsonlite)
options(stringsAsFactors=F)
# source: https://github.com/evelinag/StarWars-social-network

# getting data from GitHub
txt <- readLines(paste0("https://raw.githubusercontent.com/evelinag/",
	"StarWars-social-network/master/networks/",
	"starwars-episode-4-interactions-allCharacters.json"))
json <- fromJSON(txt)

# cleaning nodes data
nodes <- data.frame(
	name = json$nodes$name,
	id = 0:(nrow(json$nodes)-1))

# cleaning edges
edges <- apply(json$links, 1, function(x)
	data.frame(source = rep(nodes$name[nodes$id==x[1]], x[3]),
		target = rep(nodes$name[nodes$id==x[2]], x[3])))
edges <- do.call(rbind, edges)

edges <- json$links
for (i in 1:nrow(edges)){
	edges$source[i] <- nodes$name[nodes$id==edges$source[i]]
	edges$target[i] <- nodes$name[nodes$id==edges$target[i]]
}
names(edges)[3] <- "weight"

# creating igraph for sanity check
library(igraph)
g <- graph_from_data_frame(d=edges, vertices=nodes, directed=FALSE)

sort(degree(g))
sort(graph.strength(g))
plot(g)

# remove duplicates
edges <- edges[-12,]

# exporting
write.csv(nodes, file="data/star-wars-network-nodes.csv", row.names=FALSE)
write.csv(edges, file="data/star-wars-network-edges.csv", row.names=FALSE)





