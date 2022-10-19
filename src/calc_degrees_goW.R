# calc_degrees-gow calculates the 
  #degree, indegree, outdegree 
  #their weighted equivalents 
  #the go and gow value 
# for each node in the cognitive map
# It takes an edgelist and nodelist (both df) which are transformed into a map to do the calculations
# It returns a list of list entitled "node_calc" with all values
# Insert the following codes below the function: 
    # name_period_map <- calc_degrees_goW(edgelist, nodelist)[[1]]
    # name_period_node_calc <- calc_degrees_goW(edgelist, nodelist)[[2]]
# for it to return and store 
  # a df with the values [1]
  # the map associated with the edgelist and nodelist

####Functie werkt niet - geeft een list terug!!


calc_degrees_goW <- function(edgelist, nodelist){

  map <- graph_from_data_frame(d=edgelist, vertices=nodelist, directed = T) #transform edge & nodelist into a map
  
  return(map)
  
  deg <- degree(map, mode="all") #calculates degrees for each node
  indeg <- degree(map, mode="in") #calculates indegrees for each node
  outdeg <- degree(map, mode="out") #calculates outdegrees for each node
  w_indeg <- strength(map, mode="in") #calculates Weighted degrees for each node
  w_outdeg <- strength(map, mode="out") #calculates Weighted indegrees for each node
  w_deg <- strength(map, mode="all") #calculates Weighted indegrees for each node
  
  node_calc <- nodelist #makes new df to store the calculated values
  
  node_calc$indegree <- indeg #links vectors with all the (weighted) degrees values to the new node_calc df as columns
  node_calc$outdegree <- outdeg
  node_calc$degree <- deg
  node_calc$w_indegree <- w_indeg 
  node_calc$w_outdegree <- w_outdeg 
  node_calc$w_degree <- w_deg 
  
  #Calculates Go & GOW and links it to the df node_calc as columns
  node_calc <- mutate (node_calc, go = (node_calc$indegree - node_calc$outdegree)/node_calc$degree, 
                       gow = (node_calc$w_indegree - node_calc$w_outdegree)/node_calc$w_degree)
  
  return (node_calc) #returns the df node_calc with all calculated values
}

