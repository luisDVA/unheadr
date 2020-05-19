context("format parsing")

test_that("no annotations when there is no formatting", {
  ogsprdsht <- readxl::read_excel("./dog_test_plain.xlsx")
  annot <- annotate_mf_all("./dog_test_plain.xlsx")
  expect_identical(ogsprdsht[, 1], annot[, 1])
})

test_that("error when spreadsheet has empty or NA values in the header row", {
  expect_error(
    annotate_mf_all("./dog_testNAvar.xlsx"),
    "Check the spreadsheet for empty values in the header row"
  )
})

test_that("error when spreadsheet has multiple sheets", {
  expect_error(
    annotate_mf_all("./dog_test_mult.xlsx")
  )
})

test_that("error when data is non-rectangular", {
  expect_error(
    annotate_mf_all("./dog_test_nonrect.xlsx")
  )
})

test_that("error when path does not exist", {
  expect_error(annotate_mf_all("./wrongpath.xlsx"))
})
