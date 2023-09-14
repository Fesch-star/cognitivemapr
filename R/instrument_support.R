#' Instrument Support
#'
#' Calculate the support for policy instruments
#' @param node_calc An object of class "DataFrame". Description of parameter
#' @param second An object of class "vector". Description of parameter
#' @return Returns an object of class "Dataframe". Description of what the function returns
#' @examples
#' categories <- c("Intergovernmental", "Supranational", "bla")
#' test_node_calc <- calc_support_by_category_loop(test_node_calc, categories)
#' @export

# TODO
# The function needs to be made generic: choosing a generic name for columns of the input data
# instead of 'Int' - lets discuss what is a logical name. This also requires us
# to change the column name in the example data (rutte_p2_nodelist), to keep this
# working.
# See below for questions regarding the loop that I created

calc_support_by_category_loop <- function(node_calc, categories) {
  for (category in categories) {
    node_calc[, category] <- case_when(node_calc$Int == category &
                                         node_calc$val_run1 > 0 ~ node_calc$w_degree,
                                       node_calc$Int == category &
                                         node_calc$val_run1 < 0 ~-(node_calc$w_degree))
    
    node_calc[category][is.na(node_calc[category])] <- 0
  }
  return(node_calc)
}




