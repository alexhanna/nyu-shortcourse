setwd("~/git/data-science-workshop/sna")
options(stringsAsFactors=F)

nodes <- read.csv("star-wars-network-nodes.csv")
edges <- read.csv("star-wars-network-edges.csv")

library(igraph)
g <- graph_from_data_frame(d=edges, vertices=nodes, directed=FALSE)
plot(g, vertex.label.cex=0.7)