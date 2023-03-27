#function to run through a map to establish the true value of the nodes and edges by taking into account all relations
#takes an edgelist and nodelist as its input
#to save the changes in edgelist and nodeslist under a relevant name, use the following code when running this function
# name_period_edgelist <- evaluation_loop(edgelist, nodelist) [[1]] 
# name_period_edge_calc <- evaluation_loop(edgelist, nodelist) [[2]]
# name_period_nodecalc <- evaluation_loop(edgelist, nodelist)) [[3]] 

#determine diameter of map to determine number of runs needed
map <- graph_from_data_frame(d=edgelist, vertices=nodelist, directed = T) #first draw map to be able to calculate diameter

diameter <- diameter(map, directed = TRUE, unconnected = TRUE) #determine diameter = the length of the longest geodesic

runs <- 1:diameter



while (index < diameter){
  evaluation (edgelist, nodelist)
}


#
evaluation_loop <- function(edgelist, nodelist){
  #set index = 1
  index <- 1 
  
  edge_calc <- edgelist %>% 
      mutate(value.x = (value.y*edge_value)) %>%  #xt1 berekenen en  #kan ik val_xt1 vervangen door ( <-  paste ('val_xt', index, sep = "")? doet dit het?
      mutate (value.x = value.x <- value.x/sqrt (value.x ^2)) %>%  #xt1 unweighted maken mutate
      replace (is.na(.), 0) #hij doet het MAAR HIJ VERVANGT NU ALLE NA IN DE HELE DF -MOET EIGENLIJK ALLEEN COL VALue,x ZIJN
    
    # put new x.values with edge_id in a new df to paste it to a new edge_list to keep track of values per loop, but not to calculate the next loop with
    xt_to_edgelist <- edge_calc [,c("edge_id","value.x")] #make new df 
    
    colnames(xt_to_edgelist)[2] <- paste(colnames(xt_to_edgelist)[2],index, sep = "")#change name of value.x by pasting on the index, so it reflects the number of loops
    
    edgelist_check <- edgelist %>% 
      left_join(xt_to_edgelist, by = c("edge_id" = "edge_id")) #join df with new x.value to existing edgelist matching up by edge_id
    
    
    #process the new value.x scores to make changes to the same concepts that also feature as a effect-concept
    xt <- edge_calc [,c("from", "value.x")] #store values and its id (from is the id of the cause-concept in the edge) in new df
    
    xt <- xt %>%
      group_by(from) %>%
      summarise (value.x_sum = sum(value.x)) #sum the values of the same concepts - this may result in values>1
    
    #change it back to the corresponding unweighted value (-1, 0, 1)
    xt$value.x_sum <- xt$value.x_sum/sqrt(xt$value.x_sum ^2)
    
    # replace nan (non-valid values that may derive from a possible 0/0 calculation above) to 0
    xt$value.x_sum[is.na(xt$value.x_sum)] <- 0
    
    #replace old value.y with the new value for those effect-concepts that are also cause-concepts: rename from=to en x=y
    xt_to_yt <-
      rename(xt, to = from)
    
    #join xt_to_yt to edge_calc
    edge_calc <- edge_calc %>% 
      left_join(xt_to_yt, by = c("to" = "to"))
    
    #replace the values of effect-concepts that are not also cause-concepts with the original value.y
    edge_calc$value.x_sum[is.na(edge_calc$value.x_sum)] <- edge_calc$value.y[is.na(edge_calc$value.x_sum)]
    
    #replace value.y with new values from value.x_sum, so the next loop will take the new values for the calculations
    #first drop the original value.y column
    edge_calc <- within(edge_calc, rm(value.y)) 
    
    edge_calc <-   
      rename(edge_calc, value.y = value.x_sum) #assign the original name to the new y values in edge_calc, so it take the right ones in the next loop
    
    #put new y.values with edge_id in a new df to paste it to the edgelist_check to keep track of values per loop
    yt_to_edgelist <- edge_calc [,c("edge_id","value.y")] #make new df 
    
    colnames(yt_to_edgelist)[2] <- paste(colnames(yt_to_edgelist)[2],index, sep = "")#change name of value.x by pasting on the index, so it reflects the number of loops
    
    edgelist_check <- edgelist_check %>% 
      left_join(yt_to_edgelist, by = c("edge_id" = "edge_id")) #join df with new x.value to edgelist_check matching up by edge_id
    
    return (edgelist_check) #return so it continues to store the new values of x and y per loop for transparancy.
    
    #transfer the values of the concepts to the nodelist to store and review if values are consistent across the from/to column. 
    #for x the values are stored in xt
    
    xt <- rename (xt, val_loop = value.x_sum) #change name into val_loop
    
    xt <- rename (xt,id = from) #make cause node-id (to) as id
    
    yt <- unique(edge_calc[, c("to", "value.y")]) %>% #take only the unique y from the table with effect node-id (to) as ids
      rename (val_loop = value.y) %>% 
      rename (id=to)
    
    node_val_loop <- merge(xt, yt, all=TRUE) #merge xt and yt dfs, keep all rows but merge overlap put in new df
    
    colnames(node_val_loop)[2] <- paste(colnames(node_val_loop)[2],index, sep = "")#change name of node_val_loop by pasting on the index, so it reflects the number of loops
    
    nodelist <- nodelist %>% 
      left_join(node_val_loop, by = c("id" = "id")) #join node_val_run to the nodelist (= node_calc)
    
    return (nodelist)
   
    index <- index + 1 #adapts index to start the next evaluation run
    
  }