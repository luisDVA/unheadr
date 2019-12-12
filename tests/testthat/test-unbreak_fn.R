context("unbreak_functions")

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


test_that("unbreak_rows stops if regex does not match anything", {
  bball <-
    data.frame(stringsAsFactors=FALSE,
               v1 = c("Player", NA, "Sleve McDichael", "Dean Wesrey",
                      "Karl Dandleton"),
               v2 = c("Most points", "in a game", "55", "43", "41"),
               v3 = c("Season", "(year ending)", "2001", "2000", "2010")
    )
  expect_error(unbreak_rows(bball,"many",v2))
  expect_error(unbreak_rows(bball,"many",v7))
  }
)

test_that("grepl matches produce message", {
  bball <-
    data.frame(stringsAsFactors=FALSE,
               v1 = c("Player", NA, "Sleve McDichael", "Dean Wesrey",
                      "Karl Dandleton"),
               v2 = c("Most points", "in a game", "55", "43", "41"),
               v3 = c("Season", "(year ending)", "2001", "2000", "2010")
    )
  expect_message(unbreak_rows(bball,"Most",v2)
  )
  bb3 <- data.frame(stringsAsFactors=FALSE,
                    v1 = c("Player", NA, "Sleve McDichael", "Dean Wesrey",
                           "Karl Dandleton", "Player",
                           NA,
                           "Mike Sernandez",
                           "Glenallen Mixon",
                           "Rey McSriff"),
                    v2 = c("Most points", "in a game", "55", "43", "41", "Most varsity",
                           "games played", "111", "109",
                           "104"),
                    v3 = c("Season", "(year ending)", "2001", "2000", "2010", "Season",
                           "(year ending)", "2005",
                           "2004", "2002")
  )
  expect_message(unbreak_rows(bb3,"Most",v2))
})
