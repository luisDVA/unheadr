context("format parsing")

test_that("no annotations when there is no formatting", {
  ogsprdsht <- readxl::read_excel("./dog_test_plain.xlsx")
  annot <- annotate_mf("./dog_test_plain.xlsx",
              orig = Task, new = Task_annotated)
  expect_identical(ogsprdsht$Task,annot$Task_annotated)
})

test_that("error when spreadsheet has empty or NA values in the header row", {
  expect_error(
    annotate_mf("./dog_testNAvar.xlsx", orig = emptyvar, new = Task_annotated),
    "Check the spreadsheet for empty values in the header row"
  )
})

test_that("error when path does not exist", {
  expect_error(annotate_mf("./wrongpath.xlsx",
                           orig = emptyvar, new = Task_annotated))
})



test_that("all four formatting options are annotated", {
  df_ann <- annotate_mf("./dog_test_f.xlsx", orig = Task, new = Task_annotated)
  expect_equal(sum(lengths(regmatches(
    df_ann$Task_annotated,
    gregexpr(pattern = "bolded|highlighted|italic|underlined",
             text = df_ann$Task_annotated)
  ))), 4)
})
