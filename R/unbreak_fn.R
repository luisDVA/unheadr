#' Unbreak values using regex to match the broken half of the value
#'
#' @param df A data frame with one or more values within a variable broken up
#'   across two rows.
#' @param regex Regular expression for matching the second half of the broken
#'   values.
#' @param ogcol Variable to unbreak.
#' @param newcol Name of the new variable with the unified values.
#' @param sep Character string to separate the unified values (default is
#'   space).
#' @return A tibble with 'unbroken' values. The variable that originally
#'   contained the broken values gets dropped, and the new variable with the
#'   unified values is placed as the first column. The \code{slice_groups}
#'   argument is now deprecated; the extra rows and the variable with broken
#'   values will be dropped.
#'
#' @details This function is limited to quite specific cases, but useful when
#'   dealing with tables that contain scientific names broken across two rows.
#'   For unwrapping values, see \code{\link{unwrap_cols}}.
#'
#' @examples
#' data(primates2017_broken)
#' # regex matches strings starting in lowercase (broken species epithets)
#' unbreak_vals(primates2017_broken, "^[a-z]", scientific_name, sciname_new)
#' @importFrom rlang :=
#' @export
unbreak_vals <- function(df, regex, ogcol, newcol, sep = " ", slice_groups) {
  if (missing(regex)) {
    stop("no regular expression provided")
  }
  if (missing(ogcol)) {
    stop("must specify a name for 'ogcol'")
  }
  if (missing(newcol)) {
    stop("must specify a name for 'newcol'")
  }
  if (!missing(slice_groups)) {
    warning("argument slice_groups is deprecated; extra rows and the variable with broken values are now dropped by default.",
      call. = FALSE
    )
  }
  # tidyeval
  ogcol <- dplyr::enquo(ogcol)
  newcol <- dplyr::enquo(newcol)
  # conditionally unbreak vals
  dfind <- dplyr::mutate(
    df,
    !!newcol := ifelse(stringr::str_detect(!!ogcol, stringr::regex(regex)),
      yes = paste(dplyr::lag(!!ogcol), !!ogcol, sep = sep),
      no = !!ogcol
    )
  )

  # shuffle up
  matchedrows <-
    which(stringr::str_detect(dplyr::pull(dfind, !!ogcol), regex))
  dfind[matchedrows - 1, rlang::as_name(newcol)] <- dfind[matchedrows, rlang::as_name(newcol)]
  # slice
  dfsliced <- dplyr::slice(dfind, -(which(stringr::str_detect(!!ogcol, stringr::regex(regex)))))
  dfout <- dplyr::select(dfsliced, -!!ogcol)
  dplyr::select(dfout, !!newcol, dplyr::everything())
}
