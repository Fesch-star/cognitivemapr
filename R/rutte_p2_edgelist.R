#' rutte_p2_edgelist
#'
#' An edgelist consisting of a list of directed relations between concepts.
#' The variables are as follows:
#'
#' @name rutte_p2_edgelist
#' @docType data
#'
#' @format A data frame with 106 rows and 10 variables:
#' \describe{
#'   \item{from}{numerical id for the cause concept}
#'   \item{to}{numerical id for the effect concept}
#'   \item{weight}{number of times the relation is mentioned (can have any number)}
#'   \item{edge_value}{sign/value of the relation: can be 1 (positive relation), -1 (negative relation), or 0 (non-existent relation)}
#'   \item{edge_id}{unique numerical id for the edge/relation}
#'   \item{map_id}{numerical id for this cognitive map}
#'   \item{map_date}{the date of the speech from which the relation was derived}
#'   \item{speaker}{name of the actor from whose assertions the edgelist was derived}
#'   \item{value.x}{the evaluation (pos, neg ambiguous) of the 'from' concept}
#'   \item{value.y}{the evaluation (pos, neg ambiguous) of the 'to' concept}
#' }
#'
#' @source ain of ideational policy studies. Journal of European Public Policy, 31(2), 428–451. <https://doi.org/10.1080/13501763.2022.2155215>
"rutte_p2_edgelist"
