context("untangle2")

test_that("target variable is called 'regex'", {
  df <- data_frame(regex=c("gpA","a","b","gpB","c","c"),
                   x = c(NA,1,2,NA,3,4))
  expect_warning(
    untangle2(df,regex = "anything",orig = regex,new = new_col))
})
