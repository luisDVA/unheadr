context("unbreak_vals")

test_that("0-row output when regex does not match", {
  df <- data.frame(
    groupvar = c("Grp a", "Grp", "b", "Grp c", "Grp d"),
    vals = c(2, 1, NA, 1, 1), stringsAsFactors = FALSE
  )
  dfub <- unbreak_vals(df, regex = "nothing", ogcol = groupvar, newcol = r_ub, .slice_groups = TRUE)
  expect_true(
    nrow(dfub) == 0
  )
})

test_that("nrows unchanged when .slice_groups= FALSE", {
  df <- data.frame(
    groupvar = c("Grp a", "Grp", "b", "Grp c", "Grp d"),
    vals = c(2, 1, NA, 1, 1), stringsAsFactors = FALSE
  )
  dfub <- unbreak_vals(df, regex = "nothing", ogcol = groupvar, newcol = r_ub, .slice_groups = FALSE)
  expect_true(
    nrow(dfub) == nrow(df)
  )
})
