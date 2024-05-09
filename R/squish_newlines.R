#' Deduplicate and remove trailing line breaks
#'
#' @param sepstring A character vector with new line control characters.
#'
#' @return A vector without trailing or multiple consecutive new line sequences.
#' @details Useful for tables with merged cells, often imported from Word or PDF
#'   files. Can be applied across multiple columns before separating into rows.
#' @examples
#' vecWithNewlines <- c("dog\n\ncat\n\n\npig\n")
#' squish_newlines(vecWithNewlines)
#'
#' @export
squish_newlines <- function(sepstring){
  sqstring <-  stringr::str_replace_all(sepstring,"\\n(\\s*\\n)+","\n")
  stringr::str_remove(sqstring,"\n$")
}
