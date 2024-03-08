#' Calculates the level of support for different policy instruments
#'
#' Calculates to what extent the cognitive map signals support for certain types
#' of policy instruments. More specifically, it determines the saliency of all
#' concepts classified as a type of policy instrument which are valued positively
#' as determined via the "evaluate_concepts" function. To be able to run this
#' function, the functions "calculate-degrees" AND "evaluate_concepts" should have
#' been run first. Also the nodelist (node_measures) this function takes,
#' needs to contain a column with the name 'instruments' in which for each concept
#' it is noted what type of policy instrument it represents. If a concept does
#' not refer to a policy instrument, the cell should be left empty.
#' The researcher can use any typology of policy instruments that is relevant to
#' their research. This function can also be used to conduct a similar analysis
#' on categories other than policy instruments, like a thematic analysis.
#'
#' @param node_measures An object of class "dataframe" including all measures
#' returned when running the functions calculate_degrees & evaluate_concepts, as
#' well as a column with the title "instruments" in which the concepts are
#' classified as belonging to a pre-determined set of policy instrument type. If
#' a concept does not refer to a policy instrument, the cell should be left empty.
#' @param instruments An object of class "vector" containing all of the types of
#' policy instruments that occur in the node_measures list. To derive such a vector
#' run the following code:
#' "instruments <- unique(node_measures$instruments) #deriving all instrument-types
#' from the node_measures dataframe
#' instruments <- na.omit(instruments) #omitting the empty cells (NULL category)
#' from the analysis"
#' @return Returns an object of class "dataframe" with a additional columns with
#' the instrument types as column titles and the saliency scores for those concepts
#' that are evaluated positively and that belong to these categories.
#' @examples
#' # deriving all instrument-typesfrom the node_measures dataframe
#' \dontrun{
#' library(readr)
#' load("./data/rutte_p2_edgelist.rda")
#' load("./data/rutte_p2_nodelist.rda")
#' instruments <- base::unique(rutte_p2_node_measures$instruments)
#' # omitting the empty cells (NULL category) from the analysis
#' instruments <- base::na.omit(instruments)
#' rutte_p2_node_measures <- cognitivemapr::calculate_degrees(rutte_p2_edgelist, rutte_p2_nodelist)
#' rutte_p2_node_measures <- instrument_support(rutte_p2_node_measures, instruments)
#' }
#' @export

instrument_support <- function(node_measures, instruments) {
  for (instrument in instruments) {
    node_measures[, instrument] <- dplyr::case_when(node_measures$instruments == instrument &
                                         node_measures$val_run1 > 0 ~ node_measures$w_degree,
                                       node_measures$instruments == instrument &
                                         node_measures$val_run1 < 0 ~-(node_measures$w_degree))

    node_measures[instrument][base::is.na(node_measures[instrument])] <- 0
  }
  return(node_measures)
}




