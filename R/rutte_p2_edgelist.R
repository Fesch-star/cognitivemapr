#' rutte_p2_edgelist
#'
#' This dataset consists of an edgelist with causal and utility relations derived
#' from speeches by the Dutch prime-minister Mark Rutte on the Eurozone crisis
#' from the period from 2nd May 2010 to 26th July 2012.
#'
#' @name rutte_p2_edgelist
#' @docType data
#'
#' @format A data frame with 106 rows and 10 variables:
#' \describe{
#'   \item{from}{_num_ numerical id for the cause concept}
#'   \item{to}{_num_ numerical id for the effect concept}
#'   \item{weight}{_num_ number of times the relation is mentioned (can have any number)}
#'   \item{edge_value}{_num_ sign/value of the relation: can be 1 (positive relation), -1 (negative relation), or 0 (non-existent relation)}
#'   \item{edge_id}{_num_ unique numerical id for the edge/relation}
#'   \item{map_id}{_num_ numerical id for this cognitive map}
#'   \item{map_date}{_Date_ the date of the speech from which the relation was derived}
#'   \item{speaker}{_chr_ name of the actor from whose assertions the edgelist was derived}
#'   \item{value.x}{_num_ the evaluation (pos, neg ambiguous) of the 'from' concept}
#'   \item{value.y}{_num_ the evaluation (pos, neg ambiguous) of the 'to' concept}
#' }
#'
#' @source van Esch, F., & Snellens, J. (2024). How to ‘measure’ ideas. Introducing the method of cognitive mapping to the domain of ideational policy studies. Journal of European Public Policy, 31(2), 428–451. https://doi.org/10.1080/13501763.2022.2155215
"rutte_p2_edgelist"
