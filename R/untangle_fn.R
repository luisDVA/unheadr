#' Rectangling extraneous header rows.
#'
#' @param df A data frame with non-data rows embedded in the data rectangle.
#' @param regex Regular expression to match the extraneous headers.
#' @param orig Variable containing the extraneous header strings.
#' @param new Name of variable that will contain the extraneous header info in a
#'   tidier format.
#'
#' @return A tibble without the extra headers and a new variable containing
#'   the header data.
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
#' # with magrittr pipes
#' primates2017 %>%
#'     untangle2("DAE$",scientific_name,family) %>%
#'     untangle2("Asia|Madagascar|Mainland Africa|Neotropics",scientific_name,family)
#'
#' @export
untangle2 <- function(df, regex, orig, new) {
  orig <- dplyr::enquo(orig)
  new  <- dplyr::ensym(new)

  to_fill <- dplyr::mutate(
    df,
    !!new := dplyr::if_else(grepl(regex, !!orig), !!orig, NA_character_)
  )
  dffilled <- tidyr::fill(to_fill, !!new)
  dplyr::filter(dffilled, !grepl(regex, !!orig))
}
