context("untangle2")

test_that("target variable is called 'regex'", {
  df <- data.frame(regex=c("gpA","a","b","gpB","c","c"),
                   vals = c(NA,1,2,NA,3,4),stringsAsFactors = FALSE)

  expect_warning(
    untangle2(df,regex = "anything",orig = regex,new = new_col))
})


