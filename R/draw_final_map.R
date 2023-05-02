#draw graph
draw_final_map <-  function(nodecalc_valrun_nr) {

map <- graph_from_data_frame(d=edge_calc, vertices=node_calc, directed = T)#make map van df

plot(map, mode = "fruchtermanreingold", edge.arrow.size=.08, edge.curved=.2, edge.width=.18, #draw pretty graph
     edge.color = case_when (edge_calc$edge_value>0 ~ "green", 
                             edge_calc$edge_value<0 ~ "orange",
                             edge_calc$edge_value==0 ~ "black"), 
     vertex.size =0.4, vertex.shape= "none",vertex.label=node_calc$node_name, 
     vertex.label.color = case_when (nodecalc_valrun_nr > 0 ~ "blue", 
                                     nodecalc_valrun_nr <0 ~ "red",
                                     nodecalc_valrun_nr == 0 ~ "black"), vertex.label.cex=.15)

}
