#'  Calculates the level of support for two rivaling paradigms
#'
#' Calculates to what extent the cognitive map signals support for a set of two
#' commensurable policy paradigms. More specifically, it determines the saliency of all
#' concepts classified as aligning with one of the two paradigms which are valued
#' positively as determined via the evaluate_concepts function. As incommensurability
#' suggests that there is a zero-sum relation between the paradigms, negative valued
#' concepts belonging to paradigm a will be interpreted as support for paradigm b.
#' As such the function lists the saliency value of negatively valued concepts as
#' a positive score for the rival paradigm.
#' To be able to run this function, the functions calculate-degrees AND
#' evaluate_concepts should have been run first. Also the nodelist (node_measures)
#' list this function takes needs to contain a column with the name 'paradigms'
#' in which for each concept it is noted with which of the two paradigms it aligns.
#' If a concept does speak to either of the rival paradigms, the cell should be
#' left empty.
#' The researcher can use any rivaling set of paradigms that is relevant to
#' their research as long as no more or less than two are included.
#'
#' @param node_measures An object of class "dataframe" including all measures
#' returned when running the functions calculate_degrees & evaluate_concepts, as
#' well as a column with the title "paradigms" in which the concepts are
#' classified as belonging to a set of two pre-determined paradigms. If a concept
#' does not refer to either paradigm, the cell should be left empty.
#' @param paradigm_a An object of class "character string" / the first name of a
#' paradigm that occurs in the node_measures dataframe.
#' @param paradigm_b An object of class "character string" / the first name of a
#' paradigm that occurs in the node_measures dataframe.
#' To derive the exact names of the paradigms as they appear in the node_measures
#' dataframe, run the following code:
#' "paradigms <- unique(node_measures$paradigms) #deriving the names of the two
#' paradigms from the node_measures dataframe
#' paradigms <- na.omit(paradigms) #omitting the empty cells (NULL category)
#' from the analysis"
#' @return Returns an object of class "dataframe" with additional columns with
#' the paradigms as column titles and the saliency scores for those concepts
#' that indicate a positive stance towards the paradigm.
#' @examples
#' \dontrun{
#' #' library(readr)
#' load("./data/rutte_p2_edgelist.rda")
#' load("./data/rutte_p2_nodelist.rda")
#' rutte_p2_node_measures <- cognitivemapr::calculate_degrees(rutte_p2_edgelist, rutte_p2_nodelist)
#'
#' #first derive all paradigm-types from the node_measures dataframe from the analysis
#'
#' paradigms <- base::unique(rutte_p2_node_measures$paradigms)
#' paradigms <- stats::na.omit(paradigms) #omitting the empty cells (NULL category)
#' paradigm_a <- paradigms[1]
#' paradigm_b <- paradigms[2]
#'
#' rutte_p2_node_measures <- paradigm_support(rutte_p2_node_measures, paradigm_a, paradigm_b)
#' }
#' @export


paradigm_support <- function(node_measures, paradigm_a, paradigm_b){

  #if a paradigm concept is evaluated positively (> 0), add their w_degree to a new paradigm_a column in the node_measures df'
  node_measures[, paradigm_a] <- dplyr::case_when (node_measures$paradigms == paradigm_a &
                                           node_measures$val_run1 > 0 ~ node_measures$w_degree,
                                         #if a paradigm_b concept is evaluated negatively, add their w_degree the paradigm_a column
                                         node_measures$paradigms == paradigm_b &
                                           node_measures$val_run1 < 0 ~ node_measures$w_degree)
  #all other concepts are assigned a zero score in the paradigm_a column by nan <- 0
  node_measures[paradigm_a][base::is.na(node_measures[paradigm_a])] <- 0


  #same process for paradigm_b
  node_measures[, paradigm_b] <- dplyr::case_when (node_measures$paradigms == paradigm_b &
                                           node_measures$val_run1 > 0 ~ node_measures$w_degree,
                                         node_measures$paradigms == paradigm_a &
                                           node_measures$val_run1 < 0 ~ node_measures$w_degree)

  node_measures[paradigm_b][base::is.na(node_measures[paradigm_b])] <- 0 #nan omzetten in 0

  base::return <- node_measures


}
