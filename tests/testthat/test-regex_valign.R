context("vertical string alignment")

test_that("stringvec gets aligned", {
  guests <-
    unlist(strsplit(c("6       COAHUILA        20/03/2020
712       COAHUILA             20/03/2020"), "\n"))
  guests_aligned <- regex_valign(guests, "\\b(?=[A-Z])")
  guests_manual_align <- unlist(strsplit(c(
    "6         COAHUILA        20/03/2020
712       COAHUILA             20/03/2020"
  ), "\n"))

  expect_identical(guests_aligned, guests_manual_align)
})

test_that("error when input is not a character vector", {
  expect_error(regex_valign(c(1:4), "xyx"))
})
