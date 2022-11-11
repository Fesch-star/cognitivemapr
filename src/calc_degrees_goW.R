# //////////////////////////////////////////////////////////////////////////////
#
#   
#   The calc_degrees-gow function is used to analyse cognitive map (CM) data.
#   It calculates various standard CM measures and draws a first CM graph.
#   You need to run this function first before you can run the more 
#   complicated functions in this project: (calc_dims, draw_final_map, evaluation_step).
#   For more information about this type of analysis, see the reference publication
#   for this github repository (Van Esch & Snellens, fortcoming)
#
#   For each concept (node) in a map, the function calculates:
#       -degree (also called centrality): the number of unique relations/edges
#         by which the concept/node is connected to others (unweighted)
#       -indegree: the number of relations/edges feeding into a concept/node
#       -outdegree: the number of relations/edges feeding out of a concept/node
#       -the goal-orientation (go): (indegree-outdegree)/degree
#   their weighted equivalents 
#       -weighted degree, also called saliency: the number of relations/edges
#         by which the concept/node is connected to others taking into account 
#         the weight of the relations. This is calculated as the sum of the weights
#         of all relations by which the concept is connnected
#       -indegree: the number of relations/edges feeding into a concept/node taking
#         into account their weight (sum of weights of all ingoing relations)
#       -outdegree: the number of relations/edges feeding out of a concept/node
#         taking into account their weight(sum of weights of all outgoing relations)
#       -the weighted goal-orientation (gow): (W indegree - W outdegree)/W degree
#       
#       
#   The function takes an edgelist including all relations in a CM and a 
#   nodelist including all nodes/concepts in the CM (both df). The data needs to 
#   have the following column structure (the column order is also important). The 
#   columns with an * include the meta-data and are optional. For other research-
#   projects, other types of meta-data may be important. 

#   nodelist: 
#       -id: unique id (number) for the node/concept
#       -node_name: node name/concept in words
#       
#   edgelist: 
#       -from: the 'cause'-node/concept id (corresponding to the id in the nodeslist)
#       -to: the 'effect'-node/concept id (corresponding to the id in the nodeslist)
#       -weight: the weight of the edge/relation (the number of times the relation
#         is mentioned in the raw data (speech/text/survey))
#       -map_id: a unique id for the source (speech/text/respondent) the CM 
#         is derived from
#       -map_date: the date of the source (speech/text/survey)the CM is derived 
#         from
#       
#
#   The function transforms the data into a map (graph) to do the calculations.

#   The function returns a df entitled "node_calc" with all calculated values as
#   well as the original data.

#   For the function to return and store the following output a df with the values, 
#   you need to insert the following codes below the function in your script: 
#       - node_calc_name_period <- calc_degrees_goW(edgelist, nodelist)
#
#///////////////////////////////////////////////////////////////////////////////


calc_degrees_goW <- function(edgelist, nodelist) {

#transform edge & nodelist into a map
  map <- graph_from_data_frame(d = edgelist, vertices = nodelist, directed = TRUE)

#calculate for each node
  deg <- degree(map, mode = "all") #degrees (centrality in CM speech)
  indeg <- degree(map, mode = "in") #indegrees
  outdeg <- degree(map, mode = "out") #outdegrees
  w_indeg <- strength(map, mode = "in") #weighted indegrees 
  w_outdeg <- strength(map, mode = "out") #weighted outdegrees
  w_deg <- strength(map, mode = "all") #weighted degrees (saliency in CM speech)
  
#make new df to store the calculated values
  node_calc <- nodelist
  
#link vectors with all the (weighted) degrees values to 
#the new node_calc df as columns  
  node_calc$indegree <- indeg
  node_calc$outdegree <- outdeg
  node_calc$degree <- deg
  node_calc$w_indegree <- w_indeg
  node_calc$w_outdegree <- w_outdeg
  node_calc$w_degree <- w_deg
  
#calculates go & goW and link it to the df node_calc as columns
  node_calc <- mutate(node_calc, 
                      go = (node_calc$indegree - node_calc$outdegree) / node_calc$degree,
                      gow = (node_calc$w_indegree - node_calc$w_outdegree) / node_calc$w_degree)
  
  return(node_calc) #returns the df node_calc with all calculated values
}
