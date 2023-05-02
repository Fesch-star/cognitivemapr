# Function to select a particular set of edges & nodes from a bigger edgelist [sumvalue_weighted_edges_leaders] and nodelist [nodes_leaders_idecointval]
  # by (speaker)name and date & return the accompanying edgelist and nodelist
# Enter variables between " ", "eind" refers to the end date.
# In using this function, you can name and store the created node and edgelist reflecting its content by using the codes:
  # name_period_nodelist <- select_maps_make_lists ("name", "start", "eind")[[1]]  Saving nodelist
  # name_period_edgelist <- select_maps_make_lists ("name", "start", "eind")[[2]]  Saving edgelist



select_speaker_period_make_lists <- function(name, start, eind){
  edgelist <- select(filter(sumvalue_weighted_edges_leaders, speaker == name &  
                           map_date > start & map_date <= eind),
                  c(source, target, weight, edge_value, map_id, map_date, speaker)) %>% #select right speeches for map, with only the relevant columns
    left_join(nodes_leaders_idecointvalinstr, by = c("source" = "node_name")) %>% #connect node characteristics to edgelist, by source
    rename(from = id) %>% 
    left_join(nodes_leaders_idecointvalinstr, by = c("target" = "node_name")) %>% #connect node characteristics to edgelist, by target
    rename(to = id)
  
   #Make the accompanying nodelist by limiting total nodelist to only the nodes that are feature in the edges selected above 
   nodes <- sort (unique (c(unique(edgelist$from), unique(edgelist$to)))) #derive from & to nodes from edgelist
      
   nodelist <- nodes_leaders_idecointvalinstr [c(nodes),] # limit total nodelist [nodes_leaders_idecointval] to nodes from this map  
   
   #add an id to the edges in the edgelist - so each edge become unique
   edge_id <- rownames(edgelist)
   edgelist <- cbind(edge_id=edge_id, edgelist)
   
    #Clean edgelist (delete names & dimensions) & put in right order 
   # you cannot put the edge_id be the first column because transitioning the data into a map/graph requires from/to/weight to appear first in the df
   edgelist <- select(edgelist, from, to, weight, edge_value, edge_id, map_id, map_date, speaker, value.x, value.y)
   
    return (list(nodelist, edgelist))
  }

