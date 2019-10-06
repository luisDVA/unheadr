#' Unwrap values and clean up NAs used as padding
#'
#' @param df A data frame with wrapped values and an inconsistent number of NA
#'   values used to as within-group padding.
#' @param groupingVar Name of the variable describing the observational units.
#' @param separator Character string defining the separator that will delimit
#'   the elements of the unrwapped value.
#'
#' @return A summarized tibble. Order is preserved in the grouping variable by making it a factor.
#'
#' @details For more examples and background, see
#' \url{https://luisdva.github.io/rstats/unbreaking-vals/}.
#'
#' @examples
#' data(primates2017_wrapped)
#' # using commas to separate elements
#' unwrap_cols(primates2017_wrapped,scientific_name,", ")
#'
#' # separating with semicolons
#' df <- data.frame(ounits=c("A",NA,"B","C","D",NA),
#'     vals=c(1,2,2,3,1,3))
#' unwrap_cols(df,ounits,";")
#'
#' @export
unwrap_cols <- function(df, groupingVar, separator) {
  groupingVar <- dplyr::enquo(groupingVar)
  groupVarFctName <- rlang::as_name(groupingVar)

  dffilled <- tidyr::fill(df, !!groupingVar)
  dffilled_grpd <- dplyr::group_by(dffilled, !!groupVarFctName := forcats::fct_inorder(!!groupingVar))
  dfsummarised <- dplyr::summarise_all(dffilled_grpd, ~ paste(na.omit(.), collapse = separator))
  dplyr::mutate(dfsummarised, !!groupVarFctName := as.character(forcats::fct_inorder(!!groupingVar)))
}
