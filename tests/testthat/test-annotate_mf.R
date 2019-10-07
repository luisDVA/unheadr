context("format parsing")

test_that("error when there is no formatting", {
  expect_error(annotate_mf("./dog_test_plain.xlsx", orig = Task, new = Task_annotated))
})

test_that("all four formatting options are annotated", {
  df_ann <- annotate_mf("./dog_test_f.xlsx", orig = Task, new = Task_annotated)
  expect_equal(sum(lengths(regmatches(
    df_ann$Task_annotated,
    gregexpr(pattern = "bolded|highlighted|italic|underlined", text = df_ann$Task_annotated)
  ))), 4)
})
