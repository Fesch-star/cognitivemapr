#' Reformats a simple edgelist into an edgelist and nodelist that have the required
#' format for the cognitivemapr package
#'
#' This function is used to determine to derive a nodelist from a simple edgelist
#' as well as reformat a simple edgelist so it will ready for analysis with the
#' cognitivemapr Rpackage.
#' It takes an edgelist with the following 4 mandatory columns:
#' "from": cause concept
#' "to": effect concept
#' "weight": number of times the relation is mentioned (can have any number,
#'           if left empty the function will set it by default to 1)
#' "edge_value": sign/value of the relation: can be 1 (positive relation),
#'            -1 (negative relation), or 0 (non-existent relation). If left empty
#'            the function will set it by default to 1 (positive)
#' in addition any number of columns with meta-data may be added.
#'
#' The function replaces the concepts in the edgelist with id's that
#' correspond to those in the nodelist and reorders the columns, to match the
#' requirements of the other functions in this package. It checks whether columns
#' weight and edge-value in the edgelist have values, and sets these values to
#' the default of 1 (weight = 1, edge_value = positive)if they were left empty.
#' It assumes all the concepts in the edgelist are in principle normatively positive
#' or neutral by adding two columns: value.x (value of concepts in 'from' column)
#' and value.y (value of concepts in 'to'  column) and sets all values to 1 (=positive)
#'
#' It derives a nodelist from the edgelist with all unique concepts and an id to
#' link the edge and nodelists. It adds three  columns to the nodelist,
#' a column 'value' which is set to 1 (concept has a positive or neutral value)
#' by default. This value may be changed manually in excel if needed after
#' running this function. It also adds two empty columns named "paradigms" and
#' "instruments", for the researcher to fill in manually via excel after running
#' the function. Categorizing concepts as paradigmatic or as instruments is optional,
#' but required to run the functions paradigm_support and instrument_support
#' functions - see more instructions in the documentation of these functions).
#'
#' @param edgelist an edgelist
#' @return Returns a list with the resulting edgelist and nodelist
#' @export
#' @examples
#' \dontrun{
#' # INCOMPLETE
#' # Load the data
#' data("edgelist")
#'
#' # Run the following lines of code to save the edge and nodelist
#' speaker_edgelist <- prepare_lists_from_edgelist(edgelist)[[1]]
#' speaker_nodelist <- prepare_lists_from_edgelist(edgelist)[[2]]
#'
#' # You may store the nodelist as csv and fill in the value, paradigms and
#' # instruments column via excel by running the following code:
#' write.csv(df,file='/.../new_file.csv',fileEncoding = "UTF-8")
#'}
prepare_lists_from_edgelist <- function(edgelist){

  #list only unique concepts in from-column
  nodelist_from <- base::unique(edgelist$from)

  #list only the unique concepts in to-column
  nodelist_to <- base::unique(edgelist$to)

  #join the two nodelist together
  nodelist <- c(nodelist_from, nodelist_to)

  #retain only the unique values
  nodelist <- base::unique(nodelist)

  #make vector into a dataframe
  nodelist <- base::as.data.frame(nodelist)

  #rename the column into node_name
  nodelist <- dplyr::rename(nodelist, node_name = nodelist)

  #put id's in front of the nodes
  nodelist <- tibble::rowid_to_column(nodelist, "id")

  #add a value column to the nodelist, set all values to 1 (=positive)
  nodelist <- base::cbind(nodelist, value = 1)

  #add corresponding id's for the concepts from the nodelist to the edgelist
  #first for the 'from' concepts
  edgelist <- dplyr::left_join(edgelist, nodelist, by = c("from" = "node_name"))

  #then for the 'to' concepts
  edgelist <- dplyr::left_join(edgelist, nodelist, by = c("to" = "node_name"))

  #beware it renames the first(from) id to id.x and the second(to)id to id.y

  #drop the concept names: so the from and to columns with the concept names
  edgelist <- dplyr::select(edgelist, -c(from,to))

  #rename id.x to 'from'
  edgelist <- dplyr::rename(edgelist, from = id.x)

  #rename id.y to 'to'
  edgelist <- dplyr::rename(edgelist, to = id.y)

  #to put the from and to columns in the first two columns in edgelist (needed to
  #turn it into a CM later) when we do not know what kind and how much meta-data
  #is in the edgelist, use the dplyr select function with the option 'everything()'
  edgelist <- dplyr::select(edgelist, from, to, weight, everything())

  #safety check: if weight and edge-value are left empty, replace with a value 1,
  #so the map reads that all edges are included once with a positive sign
  edgelist <- dplyr::mutate(edgelist, weight = ifelse(is.na(weight), 1, weight))
  edgelist <- dplyr::mutate(edgelist, edge_value = ifelse(is.na(edge_value), 1, edge_value))

  #now return to the nodelist and add empty columns for optional node characteristics
  nodelist <- base::cbind(nodelist, paradigms = NA, instruments = NA)

  #return the edgelist and a nodelist to which paradigms and instruments can be addedrut
  return (list(edgelist, nodelist))
}
