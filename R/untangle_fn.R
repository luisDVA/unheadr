#' Rectangling embedded subheaders
#'
#' @param df A data frame with embedded subheaders.
#' @param regex Regular expression to match the subheaders.
#' @param orig Variable containing the extraneous subheaders.
#' @param new Name of variable that will contain the group values.
#'
#' @return A tibble without the matched subheaders and a new variable containing
#'   the grouping data.
#'
#' @details For background and examples see
#' \url{https://luisdva.github.io/rstats/tidyeval/}. Special thanks to Jenny
#' Bryan for fixing the initial tidyeval code and overall function structure.
#'
#' @examples
#' data(primates2017)
#' # put taxonomic family in its own variable (matches the suffix "DAE")
#' untangle2(primates2017,"DAE$",scientific_name,family)
#' # put geographic regions in their own variable (matching them all by name)
#' untangle2(primates2017,"Asia|Madagascar|Mainland Africa|Neotropics",scientific_name,family)
#' # with magrittr pipes (re-exported in this package)
#' primates2017 %>%
#'     untangle2("DAE$",scientific_name,family) %>%
#'     untangle2("Asia|Madagascar|Mainland Africa|Neotropics",scientific_name,region)
#'
#' @export
untangle2 <- function(df, regex, orig, new) {
  orig <- dplyr::enquo(orig)
  new <- dplyr::enquo(new)
  countmatches <- function(df, regex, orig) {
    xtxt <- dplyr::pull(df, !!orig)
    sum(lengths(regmatches(xtxt, gregexpr(pattern = regex, text = xtxt))))
  }
  nmatches <- countmatches(df, regex, orig)
  if (nmatches == 0) {
    message("no matches")
  } else if (nmatches == 1) {
    message(paste(nmatches, "match"))
  }
  else {
    message(paste(nmatches, "matches"))
  }
  to_fill <- dplyr::mutate(
    df,
    !!new := dplyr::if_else(grepl(regex, !!orig), !!orig, NA_character_)
  )
  dffilled <- tidyr::fill(to_fill, !!new)
  dplyr::filter(dffilled, !grepl(regex, !!orig))
}
