#' Vertical character string alignment through regular expressions
#'
#' Aligning strings with regex.
#'
#' @param stringvec A character vector with one element for each line.
#' @param regex_ai A regular expression matching the position for alignment.
#' @param sep_str Optional character vector that will be inserted at the
#'   positions matched by the regular expression.
#'
#' @return A character vector with one element for each line, with padding
#'   inserted at the matched postitions so that elements are vertically aligned
#'   across lines.
#' @details Written mainly for reading fixed width files, text, or tables parsed
#'   from PDFs.
#' @seealso This function is based loosely on
#'   \code{\link[textutils:valign]{textutils::valign()}}.
#' @examples
#' guests <-
#'   unlist(strsplit(c("6       COAHUILA        20/03/2020
#' 7       COAHUILA             20/03/2020
#' 18 BAJA CALIFORNIA     16/03/2020
#' 109       CDMX      12/03/2020
#' 1230   QUERETARO       21/03/2020"), "\n"))
#'
#' # align at first uppercase word boundary , inserting a separator
#' regex_valign(guests, "\\b(?=[A-Z])", " - ")
#' # align dates at end of string
#' regex_valign(guests, "\\b(?=[0-9]{2}[\\/]{1}[0-9]{2}[\\/]{1}[0-9]{4}$)")
#' @export
regex_valign <- function(stringvec, regex_ai, sep_str = "") {
  if (!is.character(stringvec)) {
    stop("input 'stringvec' must be a character vector")
  }
  match_position <- regexpr(regex_ai, stringvec, perl = TRUE, ignore.case = TRUE)
  padding <- function(x) {
    padspacing <- paste(rep.int(" ", max(x)), collapse = "")
    substring(padspacing, 0L, x)
  }
  nspaces <- padding(max(match_position) - match_position)
  for (i in seq_along(stringvec)) {
    stringvec[i] <- sub(regex_ai, nspaces[i], stringvec[i],
      perl = TRUE, ignore.case = TRUE
    )
  }
  sub(regex_ai, sep_str, stringvec, perl = TRUE, ignore.case = TRUE)
}
