context("line break cleanup")

test_that("duplicate and trailing new line sequences removed", {
  vecWithNewlines <- c("dog\n\ncat\n\n\npig\n")

  expect_no_match(
    squish_newlines(vecWithNewlines),"\n\n"
  )
  expect_no_match(
    squish_newlines(vecWithNewlines),"\\n$"
  )
})
