context("unwrap_cols")

test_that("grouping variable exists", {
  df <- data.frame(
    ounits = c("A", NA, "B", "C", "D", NA),
    vals = c(1, 2, 2, 3, 1, 3)
  )
  expect_error(
    unwrap_cols(df, ounitsss, ",")
  )
})

test_that("fn cleans up NAs in grouping variable", {
  df <- data.frame(
    ounits = c("A", NA, "B", "C", "D", NA),
    vals = c(1, 2, 2, 3, 1, 3)
  )

  dfuw <- unwrap_cols(df, ounits, ",")
  expect_false(anyNA(dfuw$ounits))
})
