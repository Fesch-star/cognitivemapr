#' Creates an interactive graph of the CM
#'
#' It needs to be run on the edgelist and node_measures list and you need to run
#' calculate_degrees, evaluate_concepts, paradigm_support and instrument_support
#' prior to running this function to reap the function's full potential.
#' It uses the 'layout nicely' algorithm, you can move the concepts
#' zoom in and out, it shows the sign of the relations in colors, as well as
#' different node forms for the different paradigmatic concepts. it creates
#' containers for the different instruments so you can show the 'instrument-concepts'
#' individually or collapse them into one category. The resulting CM has legends.
#'
#' You need to reformat you edge and nodelist first to work with the specifications
#' of VisNetworks - by using the function "prep-cm_visualisations" from our
#' cogntivemapr package first.
#'
#' @param edgelist an edgelist prepared to work with VisNetworks
#' @param node_measures an node_measures prepared to work with VisNetworks
#' @return Returns an VisNetwork interactive graph
#' @export
#' @examples
#' \dontrun{
#' #
#'
#' To save the graph run: cognitive_map %>% visSave(file = "results/cognitive_map.html")
#'}

interactive_visual_cm <- function(edgelist, node_measures) {

  # make a list of instrument and paradigm names

  linstr <- base::unique(node_measures$instruments)
  lparad <- base::unique(node_measures$paradigms)

  # prepare df for the legends for both nodes and edges,
  # edges first
  ledges <- base::data.frame(color = c("green", "red", "black"),
                             label = c("positive", "negative", "neutral"))

  # then for the nodes
  lnodes <- base::data.frame(shape = c("square", "triangleDown","dot"),
                             label = c(lparad))

  # derive the name of the edgelist to use as a subtitle
  subtitle <- deparse(substitute(edgelist))

  interactive_cm <- visNetwork::visNetwork(node_measures, edgelist, width = "100%", height = "600px",
                                           main = "Cognitive Map",
                                           submain = subtitle,
                                           footer = "click on the containers to reveal the concept names per instrument category") %>%
    visNetwork::visNodes(color = "lightblue") %>%
    visNetwork::visEdges(shadow = TRUE,
                         arrows =list(to = list(enabled = TRUE, scaleFactor = 2))) %>%
    visNetwork::visOptions(selectedBy = "paradigms",
                           nodesIdSelection = TRUE) %>%
    visNetwork::visLegend(addEdges = ledges, addNodes = lnodes, useGroups = FALSE) %>%
    visNetwork::visIgraphLayout(layout = "layout_nicely") %>%
    visNetwork::visClusteringByGroup(groups = linstr, shape = "ellipse", label = "Group : ", ) %>%
    visNetwork::visInteraction(dragNodes = TRUE,
                               dragView = TRUE,
                               zoomView = TRUE,
                               navigationButtons = TRUE) %>%
    visNetwork::visLayout(randomSeed = 12) # to have always the same network

  interactive_cm %>% visNetwork::visSave(file = "interactive_cm.html")

  return(interactive_cm)
}





