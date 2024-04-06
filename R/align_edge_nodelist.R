#' Copies the (normative) value of nodes from the nodelist to the edgelist.
#'
#' This function is used to align the values of concepts in the edgelist and
#' nodelist so that the value of the concepts in both lists align with
#' each other.You only need to run this function if you changed the default
#' value of any of the concepts in the nodelist after running the
#' prepare_lists_from_edgelist' function. You do not need to run it
#' when you only added information in the paradigm or instruments columns of
#' the nodelist
#'
#' It takes the edgelist which was returns from the 'prepare_lists_from_edgelist'
#' function and the nodelist returned by the same function with the manually made
#' changes in the value column. Categorizing concepts as paradigmatic or as
#' instruments is optional, but required to run the functions paradigm_support
#' and instrument_support functions - see more instructions in the documentation
#' of these functions).
#'
#' @param edgelist an edgelist
#' @param nodelist an nodelist
#' @return Returns an edgelist and nodelist
#' @export
#' @examples
#' \dontrun{
#' # Load the data
#' data("edgelist", "nodelist")
#'
#' speaker_nodelist <- align_edge_nodelist(edgelist, nodelist)[[1]]
#' speaker_edgelist <- align_edge_nodelist(edgelist, nodelist)[[2]]
#'
#' You may store the nodelist as csv and fill in the value, paradigms and
#' instruments column via excel by running the following code:
#' write.csv(df,file='/.../new_file.csv',fileEncoding = "UTF-8")
#'
#'}
align_edge_nodelist <- function(edgelist, nodelist){

  #drop the old value.x and value.y columns
  edgelist <- dplyr::select(edgelist, -c(value.x,value.y))

  #derive only the ids and values from the nodelist
  nodes <- dplyr:: select(nodelist, c(id,value))

  # join edgeslist and nodes df by id's
  #first for the 'from' concepts
  edgelist <- dplyr::left_join(edgelist, nodes, by = c("from" = "id"))

  #then for the 'to' concepts
  edgelist <- dplyr::left_join(edgelist, nodes, by = c("to" = "id"))

  #return the edgelist and a nodelist
  return (list(nodelist, edgelist))
}
