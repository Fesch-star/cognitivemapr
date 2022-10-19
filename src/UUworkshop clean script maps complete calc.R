# exploring data
library(tidyverse) #zit ggplot2, dplyr, tidyr, readr, purr, tibble al in
library(igraph) #analysing graphs
library(tidygraph) #werken met graphs in df modus met node en edgelists
library(ggraph) #gplot2 is poor fit for graph and network visualizations due to its reliance on tabular data input. ggraph is an extension of the ggplot2 API tailored to graph visualizations.

#df uploaden: nodelist_merkel_p2 (nodelist of example data)
#df uploaden: edgelist_merkel_p2 (edgelist of example data)
merkel_p2_nodes  <- read.csv ("CM_analysis/data/raw/nodelist_merkel_p2.csv")
merkel_p2_edges <- read.csv("CM_analysis/data/raw/edgelist_merkel_p2.csv")


#Calling my new function to calc node degrees and rename the node_calc df it returns
#TO DO does not work as supposed to
Merkel_p2_nodecalc <- calc_degrees_goW(merkel_p2_edges, merkel_p2_nodes) # takes edgelist, nodeslist

#TO DO: does not work as supposed to
merkel_p2_map <- calc_degrees_goW(merkel_p2_edges, merkel_p2_nodes)[[1]]
merkel_p2_node_calc <- calc_degrees_goW(merkel_p2_edges, merkel_p2_nodes)[[2]]

# creating a map/graph
merkel_p2_map <- graph_from_data_frame(d=merkel_p2_edges, vertices=merkel_p2_nodes, directed = T)

farthest_vertices(merkel_p2_map, directed = TRUE, unconnected = TRUE)# #determine longest path to set the number of loops below 
get_diameter (merkel_p2_map, directed = TRUE, unconnected = TRUE)# (superfluous step at this time -Bij Merkel2 is langste pad 6 en na 5 runs balans


#nieuwe evaluation_step functie proberen
edges_new <- Evaluation_step(merkel_p2_edges, merkel_p2_nodes)[[1]]
nodes_new <- Evaluation_step(merkel_p2_edges, merkel_p2_nodes)[[2]]

edges_2 <- Evaluation_step(edges_new, nodes_new)[[1]]
nodes_2 <- Evaluation_step(edges_new, nodes_new)[[2]]

edges_result <- edges
nodes_result <- nodes

#Looping the evaluation step function (i in 1:farthest_vertices)- TO Do: make this automatic
for (i in 1:5) {
  edges_result <- Evaluation_step(edges_result, nodes_result)[[1]] #ik denk dat dit fout is, moet edgelist, nodelist nemen
  nodes_result <- Evaluation_step(edges_result, nodes_result)[[2]] # idem
  print(i)
  print(sum(edges_result$value.x))
}

#volgende stappen aanpassen want val_run bestaat niet meer in de nieuwe evaluation function.

calc_dims(node_calc$val_run5, name = "Merkel", period = "p2")# takes nodecalc_valrun_nr, name, period


draw_final_map(node_calc$val_run5) ##draw graph - takes node_calc$val_runx (x nr of last run)
#do not forget to store graph under name_period


#Save edge & node calc lists under NAME_PERIOD
write.csv(node_calc, "data\\node_calc_NAME_PERIOD.csv", row.names = FALSE)
write.csv(edge_calc, "data\\edge_calc_NAME_PERIOD.csv", row.names = FALSE)


#JEROEN MAPS TEKENEN MET GOW SPACING
#Use node name as label for nodes in network
node_calc <- node_calc %>% 
  rename(label = node_name)

#Use GOW to determine location of the node
#In case of usage of GO, use "rename(level = go)"
node_calc <- node_calc %>% 
  rename(level = gow)

#Generate map
install.packages("visNetwork")

library(visNetwork)

visNetwork(node_calc, edges) %>% 
  visEdges(arrows = "to") %>% 
  visOptions(highlightNearest = TRUE, nodesIdSelection = TRUE) %>%
  visHierarchicalLayout(direction = "LR", levelSeparation = 400)




