# function to establish the maximum number of runs through a map
# to establish the evaluation of the nodes and edges by taking into account all 
# consequent paths in a CM. 
# The diameter of the CM is taken as the maximum number of runs
# takes an edgelist and nodelist as its input
# returns a vector with the maximum number of runs

set_max_runs <- function (edgelist, nodelist){

#first draw map to be able to calculate diameter
map <- graph_from_data_frame(d=edgelist, vertices=nodelist, directed = T)

#determine diameter = the length of the longest geodesic
diameter <- diameter(map, directed = TRUE, unconnected = TRUE) 

#return a vector with max number of runs.
max_runs <- 1:diameter

return(max_runs)

}
