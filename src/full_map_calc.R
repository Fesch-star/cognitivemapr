full_map_calc <- function(name, start, eind) {
  
   #ff shotcut want die value waarden moet anders in maps - SKINNY VRAGEN
  nodes_leaders_idecointval$value <- case_when (nodes_leaders_idecointval$value == "ambiguous" ~ 0, # $value ambi/neg vervangen door nummers
                                                nodes_leaders_idecointval$value == "negative" ~ -1) 
  
  nodes_leaders_idecointval$value [is.na(nodes_leaders_idecointval$value)] <- 1 #nan omzetten in 1
  
  
  edgelist <- select(filter(sumvalue_weighted_edges_leaders, speaker == name &  
                              map_date > start & map_date <= eind),
                     c(source, target, weight, edge_value, map_id, map_date)) %>% #select right speeches for map
    left_join(nodes_leaders_idecointval, by = c("source" = "node_name")) %>% #connect node characteristics to edgelist, source
    rename(from = id) %>% 
    left_join(nodes_leaders_idecointval, by = c("target" = "node_name")) %>% #connect node characteristics to edgelist, target
    rename(to = id)
  
  #Make nodeslist by limiting total list to only the nodes in this map/edgelist 
  nodes <- sort (unique (c(unique(edgelist$from), unique(edgelist$to)))) #derive from & to nodes from edgelist
  
  nodelist <- nodes_leaders_idecointval [c(nodes),] # limit total nodeslist (nodes_leaders_idecointval) to nodes from this map  
  
  #clean edgelist (delete names & dimensions) & put in right order
  edgelist <- select(edgelist, from, to, weight, edge_value, map_id, map_date, value.x, value.y)
  
  mp <- graph_from_data_frame(d=edgelist, vertices=nodelist, directed = T)
  return <- mp
  mp <<- mp #return and store map
  
  deg <- degree(mp, mode="all") #degrees calculeren
  indeg <- degree(mp, mode="in")
  outdeg <- degree(mp, mode="out")
  #weighted degrees calculeren
  w_indeg <- strength(mp, mode="in")
  w_outdeg <- strength(mp, mode="out")
  w_deg <- strength(mp, mode="all")
  
  node_calc <- nodelist #nieuwe df maken voor calc
  
  node_calc$indegree <- indeg #vectors met degrees aan calc df koppelen
  node_calc$outdegree <- outdeg
  node_calc$degree <- deg
  #vectors met degrees aan calc df koppelen
  node_calc$w_indegree <- w_indeg 
  node_calc$w_outdegree <- w_outdeg 
  node_calc$w_degree <- w_deg 
  
  #Go & GOW calculeren & aan df node_calc binden
  node_calc <- mutate (node_calc, go = (node_calc$indegree - node_calc$outdegree)/node_calc$degree, 
                       gow = (node_calc$w_indegree - node_calc$w_outdegree)/node_calc$w_degree)
  
  edge_calc <- edgelist
  
  edge_calc <- edge_calc %>% 
    mutate(val_xt1 = (value.y*edge_value)) %>%  #xt1 berekeken
    mutate (val_xt1 = val_xt1 <- val_xt1/sqrt(val_xt1 ^2)) %>%  #xt1 unweighted maken
    replace (is.na(.), 0) #hij doet het MAAR HIJ VERVANGT NU ALLE NA IN DE HELE DF? 
  #GAAT GOED MAAR MOET EIGENLIJK ALLEEN COL VAL_XT1 ZIJN
  
  # xt1 values met ID in een df zetten
  xt1 <- edge_calc[,c("from", "val_xt1")]
  
  #nu moeten de xt1 scores per ID worden opgeteld - opgeslagen in xt1
  xt1 <- xt1 %>%
    group_by(from) %>%
    summarise (val_xt1_sum = sum(val_xt1))
  
  #moeten nog unweighted gemaakt worden
  xt1$val_xt1_sum <- xt1$val_xt1_sum/sqrt(xt1$val_xt1_sum ^2)
  
  # en nan vervangen door 0
  xt1$val_xt1_sum[is.na(xt1$val_xt1_sum)] <- 0
  
  
  #HIER GA JE VALUE Y AANPASSEN: rename from=to en x=y
  xt1_to_yt1 <-
    rename(xt1, to = from)
  
  xt1_to_yt1 <-   
    rename(xt1_to_yt1, val_yt1 = val_xt1_sum)
  
  #dan moet dit gejoined worden met edge_calc
  edge_calc <- edge_calc %>% 
    left_join(xt1_to_yt1, by = c("to" = "to"))
  
  #na vervangen door value.y (DUS WAAR Y ALLEEN TO IS EN NIET TOT DE LIJST FROM BEHOORT)
  edge_calc$val_yt1[is.na(edge_calc$val_yt1)] <- edge_calc$value.y[is.na(edge_calc$val_yt1)]
  
  
  return <- edge_calc
  edge_calc <<- edge_calc #return and store edge_calc
  
  #nu moeten values naar nodeslist  en kijken of consistent is over de from/to lijsten. Voor x staan waarden in xt1
  #naam val veranderen
  xt1 <- rename (xt1,val_run1 = val_xt1_sum)
  
  xt1 <- rename (xt1,id = from)
  
  
  yt1 <- unique(edge_calc[, c("to", "val_yt1")]) %>% #haal unieke yt1 uit tabel met ids
    rename (val_run1 = val_yt1) %>% 
    rename (id=to)
  
  node_val_run1 <- merge(xt1, yt1, all=TRUE) #merge xt2 en yt1 dfs alles behouden, overlap samenvoegen
  
  node_calc <- node_calc %>% 
    left_join(node_val_run1, by = "id") #node_val_run1 aan node_calc binden
  
  return <- node_calc
  node_calc <<- node_calc #return and store node_calc
  
  #nu checken op stop****
  #STOP als node_calc$value = node_calc$val_run1, STOP condition als alles TRUE is
  stop <- table (ifelse(node_calc$value==node_calc$val_run1, TRUE, FALSE)) #JE HEBT NU NIET OPGESLAGEN HOEVEEL T OF F WAREN 
  print(stop)
  
}
  
  
  
  
  
  
  
  
  
  
  
  
}