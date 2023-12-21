test_that("columns are created", {
  expect_true(file.exists("data/rutte_p2_edgelist.rda"))
  load("data/rutte_p2_edgelist.rda")
  load("data/rutte_p2_nodelist.rda")
  new_df <- cognitivemapr::calculate_degrees(rutte_p2_edgelist, rutte_p2_nodelist)

  expect_that( new_df, is_a("data.frame") )
  expect_equal(length(colnames(new_df))-length(colnames(rutte_p2_nodelist)), 8)
})
