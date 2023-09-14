# Function to make the evaluation_step function iterate the number of times
# required (as determined by the max_runs function).
# I tried many things but nothing worked
# Below the suggestion by chatGPT - it indeed iterates the function
# and let you look back at the different steps, which is great. But the result
# is incorrect and does not correspond to running the evaluation_step function
# manually multiple times.
# I did not manage to solve it.
# Ultimately we should test how this responds to cyclical maps (once we have it working)


# Creating an empty list to store the results, with length determined by nr of
# iterations as established by the function max_runs
result_list <- vector("list", max_runs)

# Starting the for-loop
for (i in 1:max_runs) {
  # Call the function with appropriate edgelist and nodelist
  # Replace 'your_edgelist' and 'your_nodelist' with the actual data you want to pass to the function
  result_list[[i]] <- Evaluation_step(edgelist, node_calc)
}

# Access the results for each run
for (i in 1:max_runs) {
  edgelist_result <- result_list[[i]][[1]]
  nodelist_result <- result_list[[i]][[2]]

# Perform any additional actions or analysis on edgelist_result and nodelist_result here

  edgelist_result <- result_list[[i]][[i]]
}
