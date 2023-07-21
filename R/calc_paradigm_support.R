# Calculate paradigm support in a zero-sum manner: meaning that a negative evaluation
# of concepts associated with paradigm a, is interpreted as support for paradigm b
# and vice versa.
# Function works but needs to be made generic: prescribing generic names for the
# columns in the input data. I propose 'paradigm' rather than eco. Changing this
# requires making a similar change in the test data in the package (rutte_p2_nodelist)

calc_paradigm_support <- function(node_calc, paradigm_a, paradigm_b){

  #if a paradigm concept is evaluated positively (> 0), add their w_degree to a new paradigm_a column in the node_calc df'
  node_calc[, paradigm_a] <- case_when (node_calc$eco == paradigm_a &
                                           node_calc$val_run1 > 0 ~ node_calc$w_degree,
                                         #if a paradigm_b concept is evaluated negatively, add their w_degree the paradigm_a column
                                         node_calc$eco == paradigm_b &
                                           node_calc$val_run1 < 0 ~ node_calc$w_degree)
  #all other concepts are assigned a zero score in the paradigm_a column by nan <- 0
  node_calc[paradigm_a][is.na(node_calc[paradigm_a])] <- 0

  #same process for paradigm_b
  node_calc[, paradigm_b] <- case_when (node_calc$eco == paradigm_b &
                                           node_calc$val_run1 > 0 ~ node_calc$w_degree,
                                         node_calc$eco == paradigm_a &
                                           node_calc$val_run1 < 0 ~ node_calc$w_degree)

  node_calc[paradigm_b][is.na(node_calc[paradigm_b])] <- 0 #nan omzetten in 0

  return <- node_calc


}
