#' Performs one iteration through the CM to determine the (normative) value
#' of the nodes in the CM
#'
#' This function runs a single evaluation step
#'
#' @param edgelist an edgelist
#' @param nodelist a nodelist, if you want to add the evaluation
#' to the dataframe with the basic CM measures as calculated above, be
#' sure to use the 'node_measures' list that was returned when running the
#' calculate_degrees function.
#' @return Returns a list with the resulting edgelist and nodelist
#' @export

evaluation_step <- function(edgelist, nodelist) {

  # Conduct the first evaluation calculations
  edgelist$val_xt1 <- edgelist$value.y * edgelist$edge_value # Calculating the value of x at t1 (val_xt1)
  edgelist$val_xt1 <- edgelist$val_xt1 / base::sqrt(edgelist$val_xt1 ^ 2) # Make val_xt1 unweighted
  edgelist$val_xt1[base::is.na(edgelist$val_xt1)] <- 0 # Transform NaN values to 0

  # Put the val_xt1 values with their ID in a separate df called xt1
  xt1 <- edgelist[, c("from", "val_xt1")]

  # Add up the xt1 scores per id/concept - then store this in the df xt1
  xt1 <- xt1 %>%
    dplyr::group_by(from) %>%
    dplyr::summarise(val_xt1_sum = sum(val_xt1))

  # Make the val_xt values unweighted
  xt1$val_xt1_sum <- xt1$val_xt1_sum / base::sqrt(xt1$val_xt1_sum ^ 2)

  # Replace NaN by 0
  xt1$val_xt1_sum[base::is.na(xt1$val_xt1_sum)] <- 0

  # Here the transformation of value.y starts
  # Meaning that you will replace the original value.y with the newly calculated values
  # Rename from=to and add a val_yt1 value that takes the value of val_xt1 as calculated above
  # this is wrong, it reorders the to column

  xt1_to_yt1 <- xt1

  xt1_to_yt1 <- dplyr::rename(xt1_to_yt1, to = from)

  xt1_to_yt1 <- dplyr::rename(xt1_to_yt1, val_yt1 = val_xt1_sum)

  # Join this to the original edgelist
  edgelist <- edgelist %>%
    dplyr::left_join(xt1_to_yt1, by = c("to" = "to"))

  # Replace NA by value.y (so you basically keep the value.y in instances when y
  # only appears as an effect ('to') concept and thus has no new value
  edgelist$val_yt1[base::is.na(edgelist$val_yt1)] <- edgelist$value.y[base::is.na(edgelist$val_yt1)]

  # Now start transferring these values to the nodeslist
  # and check if they are consistent over the from/to columns.
  # For x, you need to take the values in column xt1
  # Change the names of the columns accordingly
  xt1 <- dplyr::rename(xt1, val_run1 = val_xt1_sum)
  xt1 <- dplyr::rename(xt1, id = from)

  # Take the unique yt1 variables from the table with ids
  yt1 <- unique(edgelist[, c("to", "val_yt1")]) %>%
    dplyr::rename(val_run1 = val_yt1) %>%
    dplyr::rename(id = to)

  # Merge xt2 and yt1 while retaining all other columns, collapse the overlap
  node_val_run1 <- merge(xt1, yt1, all = TRUE)

  # Bind node_val_run1 to nodelist
  nodelist <- dplyr::select(nodelist, -which(names(nodelist) %in% c('val_run1'))) %>%
    dplyr::left_join(node_val_run1, by = "id")

  # Rename some columns to prepare for the next run of the loop
  edgelist$value.x <- edgelist$val_xt1
  edgelist$value.y <- edgelist$val_yt1

  edgelist <- dplyr::select(edgelist, -c(val_xt1, val_yt1))

  # Return the resulting edge and nodelists with the new values
  return(list(edgelist, nodelist))
}
