# Calculate the support for policy instruments - function works.
# I also managed to create a loop to make it run over multiple categories.
# The function needs to be made generic: choosing a generic name for columns of the input data
# instead of 'Int' - lets discuss what is a logical name. This also requires us
# to change the column name in the example data (rutte_p2_nodelist), to keep this
# working.
# See below for questions regarding the loop that I created

calc_support_by_category_loop <- function(node_calc, category) {
  node_calc[, category] <- case_when(node_calc$Int == category &
                                          node_calc$val_run1 > 0 ~ node_calc$w_degree,
                                        node_calc$Int == category &
                                          node_calc$val_run1 < 0 ~-(node_calc$w_degree))

  node_calc[category][is.na(node_calc[category])] <- 0


  return <- node_calc #return and store node_calc

}

# to run it over multiple categories, you need to create a list with categories and
# then run the following for-loop. How can we integrate this? Make a helper function?
# or integrate in the function (I could not get that working)

#example which makes it work on my data:

category <- c("Intergovernmental", "Supranational", "bla")

for (cat in category) {
  test_node_calc <- calc_support_by_category_loop(test_node_calc, cat)
}

