
# //////////////////////////////////////////////////////////////////////////////
#
# !!! explain the duo-part of the paradigms
# !!! here you have two functions in 1 file, so rename them
# !!! make these functions generic
#//////////////////////////////////////////////////////////////////////////////

#' calc_dims
#'
#' This function will provide you with a indication of how a cognitive map scores
#' in terms of a certain paradigm (see Van Esch & Snellens, 2023). It requires
#' you to run the calc_degrees_goW function and evaluation_loop_apply function
#' first. In addition, it requires that in the initial nodeslist all causal and
#' effect concepts in the cognitive map are categorised as belonging to a paradigm
#' or not. This function will calculate the average saliency of all the concepts
#' that are assigned to a category relative to the total saliency of all concepts
#' in the cognitive map
#'
#'
#' @param nodecalc_valrun_nr, This is the output of the evaluation_loop function
#' @param name, name of actor/speaker on whose ideas the CM is based
#' @param period, period of the sources on which the CM is based
#'
#' @return dataframe
#' @export
#'
#' @examples x
calc_dims <- function(nodecalc_valrun_nr, name, period){


  #Ordoliberal concepten w_degree toewijzen, drop de ambigue concepten, draai neg Keynes om
  #optie 1, werkt case_when met toewijzen van waarden uit df?
  node_calc$ordo <- dplyr::case_when (node_calc$eco == "Ordoliberal" &
                                 nodecalc_valrun_nr>0 ~ node_calc$w_degree,
                               node_calc$eco == "Keynesian" &
                                 nodecalc_valrun_nr < 0 ~ node_calc$w_degree)

  node_calc$ordo[base::is.na(node_calc$ordo)] <- 0 #nan omzetten in 0

  #zelfde voor keynes
  node_calc$keyn <- dplyr::case_when (node_calc$eco == "Keynesian" &
                                 nodecalc_valrun_nr > 0 ~ node_calc$w_degree,
                               node_calc$eco == "Ordoliberal" &
                                 nodecalc_valrun_nr < 0 ~ node_calc$w_degree)

  node_calc$keyn[base::is.na(node_calc$keyn)] <- 0 #nan omzetten in 0


# Zelfde voor dim int, is simpeler

node_calc$intgov <- dplyr::case_when(node_calc$int == "Intergovernmental" &
                                nodecalc_valrun_nr > 0 ~ node_calc$w_degree)

node_calc$intgov[base::is.na(node_calc$intgov)] <- 0 #nan omzetten in 0


node_calc$supra <- dplyr::case_when(node_calc$int == "Supranational" &
                               nodecalc_valrun_nr > 0 ~ node_calc$w_degree)

node_calc$supra[base::is.na(node_calc$supra)] <- 0 #nan omzetten in 0

base::return <- node_calc
node_calc <<- node_calc #return and store node_calc

# w-degree & dims optellen en met name/period in matrix droppen
sums <- base::colSums(node_calc[,c("w_degree", "ordo", "keyn", "intgov", "supra")])

av <- (sums/352)*100

mpname <- c(name, period)
dim_scores <- c(mpname, sums, av[-1])
dim_scores

results <- base::rbind(results, dim_scores)

base::return <- results
results <<- results

}
