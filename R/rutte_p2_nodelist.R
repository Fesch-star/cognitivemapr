#' rutte_p2_nodelist
#'
#' The nodelist containing all unique concepts in the edgelist with additional
#' information regarding these concepts, such as their intrinsic normative value
#' or their categorisation in terms of paradigms or (policy) instruments.
#' The variables are as follows:
#'
#' @name rutte_p2_nodelist
#' @docType data
#'
#' @format A data frame with 84 rows and 6 variables:
#' \describe{
#'   \item{id}{numerical id for all unique concepts in the associated edgelist}
#'   \item{node_name}{name of  all unique concepts in the associated edgelist}
#'   \item{paradigms}{the categorisation of the concept as belonging to/being associated with one of two incommensurable paradigms}
#'   \item{int}{the categorisation of the concept as intergovernmental or supranational (superfluous column for now)}
#'   \item{value}{the intrinsic (normative) value of the concept displayed as a number: 1 = positive/neutral, -1 = negative.}
#'   \item{instruments}{the categorisation of the concept as a particular type of policy-instrument. This column can also be used for any other type of categorization of the concepts that
#' is deemed relevant}
#' }
#'
#' @source van Esch, F., & Snellens, J. (2024). How to ‘measure’ ideas. Introducing the method of cognitive mapping to the domain of ideational policy studies. Journal of European Public Policy, 31(2), 428–451. <https://doi.org/10.1080/13501763.2022.2155215>
"rutte_p2_nodelist"
