#' Reformats a simple edgelist and nodelist into an edgelist and nodelist that
#' have the required format for the cognitivemapr package
#'
#' This function is used to reformat both a simple node and edgelist into a node
#' and edgelist that have the proper format to conduct all analyses in the
#' cognitivemapr Rpackage.
#'
#  It takes an edgelist with the following 3 mandatory columns:
#' "from": cause concept
#' "to": effect concept
#' "weight": number of times the relation is mentioned (can have any number,
#'           if left empty the function will set it by default to 1)
#' "edge_value": sign/value of the relation: can be 1 (positive relation),
#'            -1 (negative relation), or 0 (non-existent relation). If left empty
#'            the function will set it by default to 1 (positive)
#'  in addition any number of columns with meta-data may be added.
#'
#' It takes a nodelist with the following 4 mandatory columns:
#' "node_name": name of all unique concepts in an edgelist
#' "value": the intrisic (normative) value of the concept displayed as a number:
#'          1 = positive/neutral, -1 = negative. You should use the negative
#'          value sparsely as whether a concept is positive or negative is often
#'          subjective. If a cell that is left empty in this column the function
#'          will set it by default to 1 (positive/neutral).
#' "paradigms": the categorisation of the concept as belonging to/being associated
#'              with one of two incommensurable paradigms, such as Ordoliberal
#'              versus Keynesian. You can only distinguish two paradigms in this
#'              column or leave the cell empty when a concept does not align with
#'              one of these two paradigms.
#' "instruments": the categorisation of the concept as a particular type of
#'                policy-instrument. You can distinguish any number of different
#'                instruments in this column or leave the cell empty when a
#'                concept is not a policy instrument. This column can also be
#'                used for any other type of categorisation of the concepts that
#'                is deemed relevant, but you cannot change the name of the column
#' in addition any number of columns with meta-data may be added.
#'
#' The function adds id's to the nodelist and replaces the concepts in the edgelist
#' with id's that correspond to those in the nodelist. It reorders the columns in
#' the edgelist to match the requirements of the  functions in this package.
#' It checks whether the columns weight and edge-value in the edgelist and the
#' column value in the nodelist have values, and sets these values to the default
#' of 1 (weight = 1, edge_value = positive, (node)value = positive/neutral) if
#' they were left empty in the uploaded lists.
#' It assigns all the concepts in the edgelist the value they were given in the
#' nodelist (or if left empty set to the default of 1) by adding two columns to
#' the edgelist: value_x (value of concepts in 'from' column) and value_y (value
#' of concepts in 'to'  column).
#'
#' It returns an edgelist and a nodelist with all the information needed
#' to run the functions in the cognitivemapr package in the proper order, and
#' retains all meta-data that was included in the original lists.
#'
#' @param edgelist an edgelist
#' @param nodelist a nodelist,
#' @return Returns a list with the resulting edgelist and nodelist
#' @export
#' @examples
#' \dontrun{
#' # INCOMPLETE
#' # Load the data
#' data("edgelist")
#'
#' # Run the following lines of code to save the edge and nodelist
#' speaker_edgelist <- reformat_edge_nodelist(edgelist, nodelist)[[1]]
#' speaker_nodelist <- reformat_edge_nodelist(edgelist, nodelist)[[2]]
#'
#' }
#'
reformat_edge_nodelist <- function(edgelist, nodelist){

  #safety check: if column 'value'in the nodelist is left empty, replace with value 1,
  #1, so all concepts are seen as neutral or positive
  nodelist <- dplyr::mutate(nodelist, value = ifelse(is.na(value), 1, value))

  # add id's to the nodelist
  nodelist <- tibble::rowid_to_column(nodelist, "id")

  #add id and value for the corresponding concepts from the nodelist to the edgelist
  #isolate only the columns needed from nodelist
  nodes <- dplyr:: select(nodelist, c(id, node_name, value))

  #first for the 'from' concepts
  edgelist <- dplyr::left_join(edgelist, nodes, by = c("from" = "node_name"))

  #then for the 'to' concepts
  edgelist <- dplyr::left_join(edgelist, nodes, by = c("to" = "node_name"))

  #beware that the function renames the id and value of the cause to id.x and value.x
  # and the id and value of the effect to id.y and value.y

  #drop the concept names from edgelist: so drop the from and to columns
  edgelist <- dplyr::select(edgelist, -c(from,to))

  #rename id.x to 'from'
  edgelist <- dplyr::rename(edgelist, from = id.x)

  #rename id.y to 'to'
  edgelist <- dplyr::rename(edgelist, to = id.y)

  #do NOT rename value.x and value.y, these names are used in later functions

  #to put the from and to and weight columns in the first three columns in edgelist
  #(needed to turn it into a CM later) when we do not know what kind and how much meta-data
  #is in the edgelist, use the dplyr select function with the option 'everything()'
  edgelist <- dplyr::select(edgelist, from, to, weight, edge_value, value.x, value.y, everything())

  #safety check: if weight and edge-value are left empty, replace with a value 1,
  #so the map reads that all edges are included once with a positive sign
  edgelist <- dplyr::mutate(edgelist, weight = ifelse(is.na(weight), 1, weight))
  edgelist <- dplyr::mutate(edgelist, edge_value = ifelse(is.na(edge_value), 1, edge_value))


  #return the edgelist and a nodelist to which paradigms and instruments can be added rut
  return (list(edgelist, nodelist))
}
