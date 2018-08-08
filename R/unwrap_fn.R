#' Unwrap values and clean up NAs used as padding within observational units.
#'
#' @param df A data frame with wrapped values and an inconsistent number of NA
#'   values used to as within-group padding.
#' @param groupingVar Name of the variable describing the observational units.
#' @param separator Character string defining the separator that will delimit
#'   the elements of the unrwapped value.
#'
#' @return A summarized tibble. Order is preserved in the grouping variable.
#'
#' @details For more examples and background, see
#' \url{https://luisdva.github.io/rstats/unbreaking-vals/}.
#'
#' @examples
#' data(primates2017_wrapped)
#' #using commas to separate elements
#' unwrap_cols(primates2017_wrapped,scientific_name,", ")
#' @export
unwrap_cols <- function(df, groupingVar, separator) {
  groupingVar <- dplyr::enquo(groupingVar)

  dffilled <- tidyr::fill(df, !!groupingVar)
  dffilled_grpd <- dplyr::group_by(dffilled, forcats::fct_inorder(!!groupingVar))
  dplyr::summarise_all(dffilled_grpd, dplyr::funs(paste(na.omit(.), collapse = separator)))
}
