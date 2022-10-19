# Calculate the eco and int dimension scores

calc_dims <- function(nodecalc_valrun_nr, name, period){
  
  
  #Ordoliberal concepten w_degree toewijzen, drop de ambigue concepten, draai neg Keynes om
  #optie 1, werkt case_when met toewijzen van waarden uit df?
  node_calc$ordo <- case_when (node_calc$eco == "Ordoliberal" & 
                                 nodecalc_valrun_nr>0 ~ node_calc$w_degree, 
                               node_calc$eco == "Keynesian" & 
                                 nodecalc_valrun_nr < 0 ~ node_calc$w_degree)
  
  node_calc$ordo[is.na(node_calc$ordo)] <- 0 #nan omzetten in 0 
  
  #zelfde voor keynes
  node_calc$keyn <- case_when (node_calc$eco == "Keynesian" & 
                                 nodecalc_valrun_nr > 0 ~ node_calc$w_degree, 
                               node_calc$eco == "Ordoliberal" & 
                                 nodecalc_valrun_nr < 0 ~ node_calc$w_degree)
  
  node_calc$keyn[is.na(node_calc$keyn)] <- 0 #nan omzetten in 0 


# Zelfde voor dim int, is simpeler

node_calc$intgov <- case_when(node_calc$int == "Intergovernmental" &
                                nodecalc_valrun_nr > 0 ~ node_calc$w_degree)

node_calc$intgov[is.na(node_calc$intgov)] <- 0 #nan omzetten in 0 


node_calc$supra <- case_when(node_calc$int == "Supranational" &
                               nodecalc_valrun_nr > 0 ~ node_calc$w_degree)

node_calc$supra[is.na(node_calc$supra)] <- 0 #nan omzetten in 0 

return <- node_calc
node_calc <<- node_calc #return and store node_calc

# w-degree & dims optellen en met name/period in matrix droppen
sums <- colSums(node_calc[,c("w_degree", "ordo", "keyn", "intgov", "supra")]) 

av <- (sums/352)*100

mpname <- c(name, period)
dim_scores <- c(mpname, sums, av[-1])
dim_scores

results <- rbind(results, dim_scores)  

return <- results
results <<- results

}
