calc_paradigm_support <- function(all_node_calc, paradigm_a, paradigm_b){

  #if a paradigm1 concept is evaluated positively (> 0), add their w_degree to a new paradigm_a column in the all_node_calc df'
  all_node_calc$paradigm_a <- case_when (all_node_calc$eco == paradigm_a &
                                           all_node_calc$val_run1 > 0 ~ all_node_calc$w_degree,
                                         #if a paradigm_b concept is evaluated negatively, add their w_degree to a new paradigm1 column in the all_node_calc df'
                                         all_node_calc$eco == paradigm_b &
                                           all_node_calc$val_run1 < 0 ~ all_node_calc$w_degree)
  #all other concepts are assigned a zero score in the paradigm_a column by nan <- 0
  all_node_calc$paradigm_a[is.na(all_node_calc$paradigm_a)] <- 0

  #same process for paradigm_b
  all_node_calc$paradigm_b <- case_when (all_node_calc$eco == paradigm_b &
                                           all_node_calc$val_run1 > 0 ~ all_node_calc$w_degree,
                                         all_node_calc$eco == paradigm_a &
                                           all_node_calc$val_run1 < 0 ~ all_node_calc$w_degree)

  all_node_calc$paradigm_b[is.na(all_node_calc$paradigm_b)] <- 0 #nan omzetten in 0

  return <- all_node_calc


}
