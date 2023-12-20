#############################################################
##  relevant periods
#p0 <-interval(start = ymd (1945-01-01), end = ymd(2009-11-04))
#p1 <-interval(start = ymd (2009-11-05), end = ymd(2010-05-01))
#p2 <-interval(start = ymd (2010-05-02), end = ymd(2012-07-25))
#p3 <-interval(start = ymd (2012-07-26), end = ymd(2014-12-31))
#p4 <-interval(start = ymd (2015-01-01), end = ymd(2015-06-07))
#p5 <-interval(start = ymd (2015-06-08), end = ymd(2015-12-31))
##############################################################


#' select_speaker_period_make_lists
#'
#' This is a helper function to select a particular set of edges & nodes from
#' the bigger edgelist [sumvalue_weighted_edges_leaders] and
#' nodelist [nodes_leaders_idecointvalinstr] that are part of the H2020 Transcrisis
#' research project of F.A.W.J. van Esch (Van Esch etal 2018). This database
#' will be made public at a later date.
#' You select the edges by (speaker)name and period and the function
#' returns the accompanying edgelist and nodelist.
#' Enter variables between " ", "eind" refers to the end date.
#' In using this function, you can name and store the created node and edgelist
#' reflecting its content by using the codes:
#' name_period_nodelist <- select_speaker_period_make_lists ("name", "start", "eind")[[1]]
#' name_period_edgelist <- select_speaker_period_make_lists ("name", "start", "eind")[[2]]
#'
#'
#' @param name Name of leader or actor
#' @param start start of period from which to draw the edges and nodes
#' @param eind end of period from which to draw the edges and nodes
#'
#' @return two data frames: one nodelist with the categorisations of the nodes
#' and intrinsic value (positive/negative concept) and a edgelist with the weight
#' of the edge and value (pos/neg/zero) and metadata
#'
#'
#' @examples
#'
#' @export
select_speaker_period_make_lists <- function(name, start, eind){
  edgelist <- dplyr::select(dplyr::filter(sumvalue_weighted_edges_leaders, speaker == name &
                           map_date > start & map_date <= eind),
                  c(source, target, weight, edge_value, map_id, map_date, speaker)) |> #select right speeches for map, with only the relevant columns
    dplyr::left_join(nodes_leaders_idecointvalinstr, by = c("source" = "node_name")) |> #connect node characteristics to edgelist, by source
    dplyr::rename(from = id) |>
    dplyr::left_join(nodes_leaders_idecointvalinstr, by = c("target" = "node_name")) |> #connect node characteristics to edgelist, by target
    dplyr::rename(to = id)

   #Make the accompanying nodelist by limiting total nodelist to only the nodes that are feature in the edges selected above
   nodes <- base::sort (base::unique (c(base::unique(edgelist$from), base::unique(edgelist$to)))) #derive from & to nodes from edgelist

   nodelist <- nodes_leaders_idecointvalinstr [c(nodes),] # limit total nodelist [nodes_leaders_idecointval] to nodes from this map

   #add an id to the edges in the edgelist - so each edge become unique
   edge_id <- base::rownames(edgelist)
   edgelist <- base::cbind(edge_id=edge_id, edgelist)

    #Clean edgelist (delete names & dimensions) & put in right order
   # you cannot put the edge_id be the first column because transitioning the data into a map/graph requires from/to/weight to appear first in the df
   edgelist <- dplyr::select(edgelist, from, to, weight, edge_value, edge_id, map_id, map_date, speaker, value.x, value.y)

    base::return (list(nodelist, edgelist))
  }

