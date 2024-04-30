#' rutte_p2_nodelist
#'
#' The data includes a nodelist with all of the concepts that are used in _rutte_p2_edgelist_,
#' categorised in terms of the policy-paradigms and policy-instruments that they
#' are associated with.
#'
#' @name rutte_p2_nodelist
#' @docType data
#'
#' @format A data frame with 84 rows and 6 variables:
#' \describe{
#'   \item{id}{_num_ numerical id for all unique concepts in the associated edgelist}
#'   \item{node_name}{_chr_ name of  all unique concepts in the associated edgelist}
#'   \item{paradigms}{_chr_ the categorisation of the concept as belonging to/being associated with one of two incommensurable paradigms}
#'   \item{int}{_chr_ the categorisation of the concept as intergovernmental or supranational (superfluous column for now)}
#'   \item{value}{_num_ the intrinsic (normative) value of the concept displayed as a number: 1 = positive/neutral, -1 = negative.}
#'   \item{instruments}{_chr_ the categorisation of the concept as a particular type of policy-instrument. This column can also be used for any other type of categorization of the concepts that
#' is deemed relevant}
#' }
#'
#' @source van Esch, F., & Snellens, J. (2024). How to ‘measure’ ideas. Introducing the method of cognitive mapping to the domain of ideational policy studies. Journal of European Public Policy, 31(2), 428–451. <https://doi.org/10.1080/13501763.2022.2155215>
"rutte_p2_nodelist"
