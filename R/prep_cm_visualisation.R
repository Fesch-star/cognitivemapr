#' Prepares the edge and node_measures list for VisNetwork graph
#'
#' It needs to be run on the edgelist and node_measures list and to have run the
#' calculate_degrees, evaluate_concepts, paradigm_support and instrument_support
#' prior to running this function to reap the function's full potential.
#' It prepares the resulting egdelist and node_measure list for the interactive_cm
#' function
#'
#' @param edgelist an edgelist
#' @param nodelist an node_measures list
#' @return Returns a list of lists
#' @export
#' @examples
#' \dontrun{
#' #
#'
#'
#'}
prep_cm_visualisation <- function(edgelist, node_measures) {

# in the visNetwork package the column name "value" is reserved for the size of
# the nodes rather than its evaluation, so rename the value column in the node_measure list
# idem for the column node_name which needs to be relabelled into "label"
node_measures <- node_measures %>%
  dplyr::rename(evaluation = value) %>%
  dplyr::rename(label = node_name)

# rename the column to "value", but rescale to optimise visualisation, the range
# of the maps of political leaders derived from speeches is often about 1-10 so
# (wdegree/5)+1 appears to be a useful scale
node_measures <- dplyr::mutate(node_measures, value = w_degree/5 + 1)

# create a 'neutral' category for NA's in the paradigms and instruments columns,
# so it is possible to distinguish all categories and the neutral by colour in
# the visualisation

node_measures$paradigms <- node_measures$paradigms %>% tidyr::replace_na("Neutral")
node_measures$instruments <- node_measures$instruments %>% tidyr::replace_na("Neutral")

# create a new column with associated shapes
node_measures <- node_measures %>%
  dplyr::mutate(shape = dplyr::case_when(
      paradigms == paradigm_a ~ "square",
      paradigms == paradigm_b ~ "triangleDown",
      paradigms == "Neutral" ~ "dot"))

# to be able to cluster the types of instruments in the visualisation, copy their
# value into a new column called group.
node_measures <- node_measures %>%
  dplyr::mutate(group = instruments)

# There are also changes needed to the column names of the edgelist
# the function 'title' in the visNetworks packages provides the label of the edge
# when you hoover over it with your cursor, let's use the edge_value column for this
# as this gives the weight and sign together

edgelist <- edgelist %>%
  dplyr::rename(title = edge_value)

# to scale the values, the column needs to be labelled 'value', we will add
# a column for this with a scaling on the basis of the weight of the edge.

edgelist <- dplyr::mutate(edgelist, value = weight/5+1)

# let's add coloured edges dependent on their value (which I have renamed as 'title')

edgelist <- edgelist %>%
  dplyr::mutate(
    color = dplyr::case_when (
      title > 0 ~ "green",
      title == 0 ~ "black",
      title < 0 ~ "red"))

base::return(list(edgelist, node_measures))
}





