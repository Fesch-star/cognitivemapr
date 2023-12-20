#' Sets the number of iterations for the evaluate concepts function
#'
#' Helper function. Calculates the number of iterations that the
#' evaluate_concepts function needs to run in the for-loop to determine the
#' (normative) value of the concepts.
#' The number of iterations is set to the diameter of the CM.
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

#determine diameter = the length of the longest geodesic, this equal the maximum
#number of iterations that the evaluate_concepts functions need to run through the
#for-loop
max_runs <- igraph::diameter(map, directed = TRUE, unconnected = TRUE)

return(max_runs)

}
