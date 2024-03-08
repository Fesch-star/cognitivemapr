#' Calculates various standard CM measures (types of degrees)
#'
#' The calculate_degrees function is used to analyse cognitive map (CM) data.
#' It calculates various standard CM measures.
#' You need to run this function first before you can run the more
#' complicated functions in this package: (instrument_support, paradigm_support
#' evaluate_concepts).
#'
#' For each concept (node) in a map, the function calculates:
#'
#'     * degree (also called centrality): the number of unique relations/edges
#'       by which the concept/node is connected to others (unweighted)
#'
#'     * indegree: the number of relations/edges feeding into a concept/node
#'
#'     * outdegree: the number of relations/edges feeding out of a concept/node
#'
#'     * the goal-orientation (go): (indegree-outdegree)/degree
#'
#'   Their weighted equivalents
#'
#'     * weighted degree (also called saliency): the number of relations/edges
#'         by which the concept/node is connected to others taking into account
#'         the weight of the relations.
#'
#'     * indegree: the number of relations/edges feeding into a concept/node taking
#'         into account their weight (sum of weights of all ingoing relations)
#'
#'     * outdegree: the number of relations/edges feeding out of a concept/node
#'         taking into account their weight(sum of weights of all outgoing relations)
#'
#'     * the weighted goal-orientation (gow): (W indegree - W outdegree)/W degree
#'
#'
#' @param edgelist
#' The function takes an edgelist (dataframe) including all relations in a CM.
#' The data needs to following column structure. The last two columns include
#' the meta-data and are optional. For other research projects, other types of
#' meta-data may be important.
#'
#'      * from: the 'cause'-node/concept id (corresponding to the id in the nodelist)
#'
#'      * to: the 'effect'-node/concept id (corresponding to the id in the nodelist)
#'
#'      * weight: the weight of the edge/relation (the number of times the relation
#'         is mentioned in the raw data (speech/text/survey))
#'
#'      * map_id: a unique id for the source (speech/text/respondent) the CM
#'         is derived from
#'
#'      * map_date: the date of the source (speech/text/survey)the CM is derived
#'         from
#'
#' @param nodelist
#' The function takes a nodelist (dataframe) including all unique nodes/concepts
#' in the CM. The data needs to follow the column structure listed below.
#' Other columns may be included containing categorization of the concepts in
#' terms of - for instance - the paradigm they align with or the type of policy
#' instrument the concept refers to. For different research projects, different
#' types of categorizations may be relevant. In addition, researchers may want
#' to add meta-data to the nodes. The required column structure:
#'
#'      * id: unique id (number) for the node/concept
#'
#'      * node_name: node name/concept in words
#'
#'      * paradigms: a set of rivaling paradigms concepts may align with
#'
#'      * instruments: the type of policy instrument the concept refers to
#'
#' @return The function returns a dataframe entitled "node_measures" with all
#' calculated values as well as the original data.
#' For the function to return and store the following output a dataframe with the
#' values, you need to insert the following code below the function in your script:
#'
#'       * node_measures_name_period <- calculate_degrees(edgelist, nodelist)
#'
#'
#' @export
#'
calculate_degrees <- function(edgelist, nodelist) {

#transform edge & nodelist into a map
  map <- igraph::graph_from_data_frame(d = edgelist, vertices = nodelist, directed = TRUE)

#calculate for each node
  deg <- igraph::degree(map, mode = "all") #degrees (centrality in CM speech)
  indeg <- igraph::degree(map, mode = "in") #indegrees
  outdeg <- igraph::degree(map, mode = "out") #outdegrees
  w_indeg <- igraph::strength(map, mode = "in") #weighted indegrees
  w_outdeg <- igraph::strength(map, mode = "out") #weighted outdegrees
  w_deg <- igraph::strength(map, mode = "all") #weighted degrees (saliency in CM speech)

#make new df to store the calculated values
  node_measures <- nodelist

#link vectors with all the (weighted) degrees values to
#the new node_calc df as columns
  node_measures$indegree <- indeg
  node_measures$outdegree <- outdeg
  node_measures$degree <- deg
  node_measures$w_indegree <- w_indeg
  node_measures$w_outdegree <- w_outdeg
  node_measures$w_degree <- w_deg

#calculates go & goW and link it to the df node_measures as columns
  node_measures <- dplyr::mutate(node_measures,
          go = (node_measures$indegree - node_measures$outdegree) / node_measures$degree,
          gow = (node_measures$w_indegree - node_measures$w_outdegree) / node_measures$w_degree)
  return(node_measures) #returns the df node_measures with all calculated values
}
