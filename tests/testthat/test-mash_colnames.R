context("broken names")

test_that("n_name_rows set to 0 throws error", {
  babies <-
    data.frame(
      stringsAsFactors = FALSE,
      Baby = c(NA, NA, "Angie", "Yean", "Pierre"),
      Age = c("in", "months", "11", "9", "7"),
      Weight = c("kg", NA, "2", "3", "4"),
      Ward = c(NA, NA, "A", "B", "C")
    )
  expect_error(
    mash_colnames(babies, n_name_rows = 0, keep_names = TRUE)
  )
})

test_that("output data has fewer rows after mashing names", {
  fish_experiment <-
    data.frame(
      stringsAsFactors = FALSE,
      X1 = c("Sample", NA, "Pacific", "Atlantic", "Freshwater"),
      X2 = c("Larvae", "Control", "12", "11", "10"),
      X3 = c(NA, "Low Dose", "11", "12", "8"),
      X4 = c(NA, "High Dose", "8", "7", "9"),
      X5 = c("Adult", "Control", "13", "13", "8"),
      X6 = c(NA, "Low Dose", "13", "12", "7"),
      X7 = c(NA, "High Dose", "10", "10", "9")
    )
  expect_warning(
    mash_colnames(fish_experiment, n_name_rows = 1, keep_names = F)
  )
})

test_that("warning when NA values make it onto column names", {
  babies <-
    data.frame(
      stringsAsFactors = FALSE,
      Baby = c(NA, NA, "Angie", "Yean", "Pierre"),
      Age = c("in", "months", "11", "9", "7"),
      Weight = c("kg", NA, "2", "3", "4"),
      Ward = c(NA, NA, "A", "B", "C")
    )
  toprowint <- 2
  mashed <- mash_colnames(babies, n_name_rows = toprowint, keep_names = TRUE)

  expect_true(
    nrow(mashed) == nrow(babies) - toprowint
  )
})

test_that("colwise filling leads to duplication of name fragments", {
  fish_experiment <-
    data.frame(
      stringsAsFactors = FALSE,
      X1 = c("Sample", NA, "Pacific", "Atlantic", "Freshwater"),
      X2 = c("Larvae", "Control", "12", "11", "10"),
      X3 = c(NA, "Low Dose", "11", "12", "8"),
      X4 = c(NA, "High Dose", "8", "7", "9"),
      X5 = c("Adult", "Control", "13", "13", "8"),
      X6 = c(NA, "Low Dose", "13", "12", "7"),
      X7 = c(NA, "High Dose", "10", "10", "9")
    )
  fishm <- mash_colnames(fish_experiment, n_name_rows = 2, keep_names = F, sliding_headers = TRUE)
  name_fragments <- unlist(strsplit(names(fishm), split = "_"))
  expect_true(
    any(duplicated(name_fragments))
  )
})
