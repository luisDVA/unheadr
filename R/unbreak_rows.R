#' Merge rows up
#'
#' @param df A data frame with at least two contiguous rows to be merged.
#' @param regex A regular expression to identify sets of rows to be merged,
#'   meant for the leading of the two contiguous rows.
#' @param ogcol Variable with the text strings to match.
#' @param sep Character string to separate the unified values (default is space).
#'
#' @return  A tibble or data frame with merged rows values. Values of the
#'   lagging rows are pasted to the values in the leading row, squished, and the
#'   lagging row is dropped.
#'
#' @examples
#' bball <-
#' data.frame(stringsAsFactors=FALSE,
#'            v1 = c("Player", NA, "Sleve McDichael", "Dean Wesrey",
#'                   "Karl Dandleton"),
#'            v2 = c("Most points", "in a game", "55", "43", "41"),
#'            v3 = c("Season", "(year ending)", "2001", "2000", "2010")
#' )
#'unbreak_rows(bball,"Most",v2)
#'
#' @export
unbreak_rows <- function (df, regex, ogcol, sep = " ") {
  ogcol <- dplyr::enquo(ogcol)
  countmatches <- function(df, regex, ogcol) {
    xtxt <- dplyr::pull(df, !!ogcol)
    sum(lengths(regmatches(xtxt, gregexpr(pattern = regex, text = xtxt))))
  }
  nmatches <- countmatches(df, regex, ogcol)
  if (nmatches == 0) {
    stop("no matches")
  } else if (nmatches == 1) {
    message(paste(nmatches, "match"))
  }
  else {
    message(paste(nmatches, "matches"))
  }
  dfind <- dplyr::mutate_all(df, ~ifelse(stringr::str_detect(df[[dplyr::quo_name(ogcol)]],stringr::regex(regex)),
                                         yes = stringr::str_squish(paste(ifelse(is.na(.), "", .),
                                                                         dplyr::lead(ifelse(is.na(.), "", .)),sep = sep)), no = ifelse(is.na(.), "", .)))
  dfsliced <- dplyr::slice(dfind, -(which(stringr::str_detect(!!ogcol,stringr::regex(regex))) + 1))
  dfsliced
}
