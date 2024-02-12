#' Displays the cognitive map as a simple graph.
#'
#' This function is used to provide a first simple visualisation of the CM as
#' recorded in the edgelist and nodelist. The "interactive_CM_visualization
#' function in this package provides a more sufficated and easier to read graph
#' (see below).It takes an edgelist and nodelist, you may use either the original
#' nodelist or the node_measures list.
#'
#' @param edgelist an edgelist
#' @param nodelist an nodelist
#' @return Returns a visual graph
#' @export
#' @examples
#' \dontrun{
#' # draw the CM graph
#' cognitivemapr::draw_cm(rutte_p2_edgelist, rutte_p2_nodelist)
#'
#' # to store the cm as a png or pdf (other formats are possible), use the
#' following code:
#'
#' # Save as PDF
#' grDevices::pdf(pdf_file)
#' cognitivemapr::draw_cm(rutte_p2_edgelist, rutte_p2_nodelist)
#' grDevices::dev.off()
#'
#' # Save as PNG
#' grDevices::png(png_file, width = 800, height = 800)
#' cognitivemapr::draw_cm(rutte_p2_edgelist, rutte_p2_nodelist)
#' grDevices::dev.off()
#' #'
#' }
#'
draw_cm <- function(edgelist, nodelist){

  cm <- igraph::graph_from_data_frame(d=edgelist, vertices=nodelist, directed = T)# make map from df

  plot(cm, mode = "fruchtermanreingold", edge.arrow.size=.08, edge.curved=.2, edge.width=.18, #draw pretty graph
       edge.color = dplyr::case_when (edgelist$edge_value>0 ~ "green",
                                      edgelist$edge_value<0 ~ "red",
                                      edgelist$edge_value==0 ~ "black"),
       vertex.size =0.4, vertex.shape= "none",vertex.label=nodelist$node_name,
       vertex.label.color = dplyr::case_when (nodelist$value > 0 ~ "blue",
                                              nodelist$value < 0 ~ "red",
                                              nodelist$value == 0 ~ "black"), vertex.label.cex=.15)
  return(cm)
}
