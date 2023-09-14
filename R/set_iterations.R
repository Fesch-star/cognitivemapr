#' Set the maximum number of iterations
#' 
#' This function is used to set the maximum number of iterations for the
#' evaluation of the nodes and edges in a CM. The maximum number of iterations
#' is equal to the diameter of the CM.
#' @param edgelist an edgelist
#' @param nodelist a nodelist
#' @return Returns a vector with the maximum number of iterations
#' @examples
#' set_iterations(rutte_p2_edgelist, rutte_p2_nodelist)
#' @export
#' @import igraph
#' @importFrom igraph diameter
#' @importFrom igraph graph_from_data_frame

set_iterations <- function (edgelist, nodelist){

#first draw map to be able to calculate diameter
map <- igraph::graph_from_data_frame(d=edgelist, vertices=nodelist, directed = T)

#determine diameter = the length of the longest geodesic
diameter <- igraph::diameter(map, directed = TRUE, unconnected = TRUE)

#return a vector with max number of runs.
max_runs <- 1:diameter

return(max_runs)

}
