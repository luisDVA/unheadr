#' Annotate meaningful formatting for all cells
#'
#' Turns cell formatting into annotations for all values across all variables.
#'
#' @param xlfilepath Path to a single-sheet spreadsheet file (xls or xlsx).
#'
#' @return A tibble with meaningful formatting embedded as text for all rows and
#'   columns.
#' @details At this point, seven popular approaches for meaningful
#'   formatting (bold, colored text, italic, strikethrough, underline, double underline, and cell highlighting) are hardcoded in
#'   the function. `sheets`, `skip`, and `range` arguments for spreadsheet input
#'   are not supported. The hex8 code of the fill color used for text color and cell
#'   highlighting is also appended in the output. Ensure the data in the
#'   spreadsheet are rectangular before running.
#' @examples
#' example_spreadsheet <- system.file("extdata/boutiques.xlsx", package = "unheadr")
#' annotate_mf_all(example_spreadsheet)
#' @importFrom rlang :=
#' @importFrom rlang .data
#' @export
annotate_mf_all <- function(xlfilepath) {
  spsheet <- readxl::read_excel(xlfilepath)
  if (any(grepl("^\\.\\.\\.", names(spsheet)))) {
    stop("Check the spreadsheet for empty values in the header row")
  }
  m_formatting <- tidyxl::xlsx_cells(xlfilepath)
  rowtally <- dplyr::count(m_formatting, row)
  if (length(unique(rowtally$n)) != 1) {
    stop("Data in spreadsheet does not appear to be rectangular (this includes multisheet files)")
  }
  format_defs <- tidyxl::xlsx_formats(xlfilepath)

  bold <- format_defs$local$font$bold
  italic <- format_defs$local$font$italic
  underlined <- format_defs$local$font$underline
  highlighted <- format_defs$local$fill$patternFill$patternType
  hl_color <- format_defs$local$fill$patternFill$fgColor$rgb
  strikethrough <- format_defs$local$font$strike
  text_clr <- format_defs$local$font$color$rgb
  format_opts <- tibble::lst(
    bold, highlighted, hl_color, italic,
    strikethrough, text_clr, underlined
  )
  formatting_indicators <- dplyr::bind_cols(lapply(
    format_opts,
    function(x) x[m_formatting$local_format_id]
  ))
  format_joined <- dplyr::bind_cols(m_formatting, formatting_indicators)

  cols_spsheet <- match(
    names(spsheet),
    format_joined$character
  )

  # annotate target variable
  target_var_fmt <- function(col_ind) {
    orig_format <- dplyr::filter(format_joined, row >= 2 & col == col_ind)
    orig_format <- dplyr::select(orig_format, bold:underlined)
    formatted <- dplyr::bind_cols(spsheet, orig_format)
    formatted <- dplyr::mutate_at(
      formatted, dplyr::vars(bold:underlined),
      ~ replace(., is.na(.), FALSE)
    )
    # set up multi-category annotations
    formatted$highlighted <- gsub(
      pattern = "FALSE", replacement = "",
      formatted$highlighted
    )
    formatted$text_clr <- gsub(
      pattern = "FALSE", replacement = "",
      formatted$text_clr
    )
    formatted$underlined <- gsub(
      pattern = "FALSE", replacement = "",
      formatted$underlined
    )
    formatted$hl_color <- gsub(
      pattern = "FALSE", replacement = "",
      formatted$hl_color
    )
    formatted <- dplyr::mutate_at(
      formatted, dplyr::vars(bold, italic, strikethrough),
      as.logical
    )
    # swap na with variable names
    formatted <- dplyr::mutate_at(
      formatted, dplyr::vars(bold:underlined),
      function(x) {
        ifelse(x == TRUE, deparse(substitute(x)), x)
      }
    )
    formatted <- dplyr::mutate_at(
      formatted,
      dplyr::vars(bold:underlined), ~ replace(., . == "FALSE", "")
    )
    # build annotation strings
    formatted$highlighted <- ifelse(formatted$highlighted != "",
                                    paste0("highlight", "-", formatted$hl_color), formatted$highlighted
    )
    formatted$hl_color <- NULL
    formatted$text_clr <- ifelse(formatted$text_clr != "",
                                 paste0("color", "-", formatted$text_clr), formatted$text_clr
    )
    formatted$underlined <- ifelse(formatted$underlined != "",
                                   paste0("underlined", "-", formatted$underlined), formatted$underlined
    )
    formatted$newvar <-
      paste(
        formatted$bold, formatted$highlighted,
        formatted$italic, formatted$strikethrough, formatted$text_clr,
        formatted$underlined
      )
    formatted$newvar <- stringr::str_squish(formatted$newvar)
    formatted$newvar <- gsub(" ", ", ", formatted$newvar)
    formatted <- dplyr::select(formatted, -c(bold:underlined))
    formatted[[names(spsheet)[col_ind]]] <-
      paste0("(", formatted$newvar, ") ", formatted[[names(spsheet)[col_ind]]])
    formatted[[names(spsheet)[col_ind]]]
  }

  for (i in seq_along(cols_spsheet)) {
    spsheet[, names(spsheet)[i]] <- target_var_fmt(i)
  }

  spsheet
  dplyr::mutate_all(spsheet, stringr::str_remove, "^\\(\\) ")
}
