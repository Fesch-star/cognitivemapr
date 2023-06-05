#Calculate the support - need to change this to automatic
calc_support_by_category <- function(all_node_calc, category_a, category_b, category_c, category_d, category_e, category_f, category_g) {
  all_node_calc$category_a <- case_when(all_node_calc$instr == category_a & 
                                          all_node_calc$val_run1 > 0 ~ all_node_calc$w_degree,
                                        all_node_calc$instr == category_a &
                                          all_node_calc$val_run1 < 0 ~-(all_node_calc$w_degree))
  
  all_node_calc$category_a[is.na(all_node_calc$category_a)] <- 0 
  
  
  all_node_calc$category_b <- case_when(all_node_calc$instr == category_b & 
                                          all_node_calc$val_run1 > 0 ~ all_node_calc$w_degree,
                                        all_node_calc$instr == category_b &
                                          all_node_calc$val_run1 < 0 ~-(all_node_calc$w_degree))
  
  all_node_calc$category_b[is.na(all_node_calc$category_b)] <- 0 
  
  
  all_node_calc$category_c <- case_when(all_node_calc$instr == category_c & 
                                          all_node_calc$val_run1 > 0 ~ all_node_calc$w_degree,
                                        all_node_calc$instr == category_c &
                                          all_node_calc$val_run1 < 0 ~-(all_node_calc$w_degree))
  
  all_node_calc$category_c[is.na(all_node_calc$category_c)] <- 0 
  
  
  all_node_calc$category_d <- case_when(all_node_calc$instr == category_d & 
                                          all_node_calc$val_run1 > 0 ~ all_node_calc$w_degree,
                                        all_node_calc$instr == category_d &
                                          all_node_calc$val_run1 < 0 ~-(all_node_calc$w_degree))
  
  all_node_calc$category_d[is.na(all_node_calc$category_d)] <- 0 
  
  
  all_node_calc$category_e <- case_when(all_node_calc$instr == category_e & 
                                          all_node_calc$val_run1 > 0 ~ all_node_calc$w_degree,
                                        all_node_calc$instr == category_e &
                                          all_node_calc$val_run1 < 0 ~-(all_node_calc$w_degree))
  
  all_node_calc$category_e[is.na(all_node_calc$category_e)] <- 0 
  
  
  all_node_calc$category_f <- case_when(all_node_calc$instr == category_f & 
                                          all_node_calc$val_run1 > 0 ~ all_node_calc$w_degree,
                                        all_node_calc$instr == category_f &
                                          all_node_calc$val_run1 < 0 ~-(all_node_calc$w_degree))
  
  all_node_calc$category_f[is.na(all_node_calc$category_f)] <- 0 
  
  
  all_node_calc$category_g <- case_when(all_node_calc$instr == category_g & 
                                          all_node_calc$val_run1 > 0 ~ all_node_calc$w_degree,
                                        all_node_calc$instr == category_g &
                                          all_node_calc$val_run1 < 0 ~-(all_node_calc$w_degree))
  
  all_node_calc$category_g[is.na(all_node_calc$category_g)] <- 0 
  
  return <- all_node_calc #return and store node_calc
  
}
