#' Annotate meaningful formatting
#'
#' Turns cell formatting into annotations for values in the target variable.
#'
#' @param xlfilepath Path to a single-sheet spreadsheet file (xls or xlsx).
#' @param orig Target variable to annotate formatting in.
#' @param new Name of new variable with cell formatting pasted as a string.
#'
#' @return A tibble with a new column in which the meaningful formatting is
#'   embedded as text.
#' @details Seven popular approaches for meaningful formatting (bold, colored
#'   text, italic, strikethrough, underline, double underline, and cell
#'   highlighting) are hardcoded in the function. `sheets`, `skip`, and `range`
#'   arguments for spreadsheet input are not supported. The hex8 code of the
#'   fill color used for text color and cell highlighting is also appended in
#'   the output. Ensure the data in the spreadsheet are rectangular before
#'   running; this includes blank but formatted cells beyond the data rectangle.
#' @examples
#' example_spreadsheet <- system.file("extdata/dog_test.xlsx", package = "unheadr")
#' annotate_mf(example_spreadsheet, orig = Task, new = Task_annotated)
#' @importFrom rlang :=
#' @importFrom rlang .data
#' @export
annotate_mf <- function(xlfilepath, orig, new) {

  spsheet <- readxl::read_excel(xlfilepath)
  if (any(grepl("^\\.\\.\\.", names(spsheet)))) {
    stop("Check the spreadsheet for empty values in the header row")
  }
  m_formatting <- tidyxl::xlsx_cells(xlfilepath)
  m_formatting <-
    dplyr::ungroup(tidyr::complete(dplyr::group_by(m_formatting, col),
                                   row = tidyr::full_seq(row, 1)
    ))

  if (length(unique(stats::na.omit(m_formatting$sheet))) != 1) {
    stop("Data in spreadsheet does not appear to be rectangular (this includes multisheet files)")
  }

  format_defs <- tidyxl::xlsx_formats(xlfilepath)

  # meaningful formatting
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
  origstr <- deparse(substitute(orig))
  col_orig <- format_joined$col[match(
    paste0(origstr),
    format_joined$character
  )]

  # target variable
  orig_format <- dplyr::filter(format_joined, row >= 2 & col == col_orig)
  orig_format <- dplyr::select(orig_format, bold:underlined)
  formatted <- dplyr::bind_cols(spsheet, orig_format)
  formatted <- dplyr::mutate(
    formatted, dplyr::across(
      bold:underlined,
      \(x) replace(x, is.na(x), FALSE)
    )
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
  formatted <- dplyr::mutate(
    formatted, dplyr::across(
      c(bold, italic, strikethrough),
      as.logical
    )
  )
  # swap na with variable names
  formatted <- dplyr::mutate(
    formatted, dplyr::across(
      bold:underlined,
      \(x) {
        ifelse(x == TRUE, deparse(substitute(x)), x)
      }
    )
  )
  formatted <- dplyr::mutate(
    formatted,
    dplyr::across(bold:underlined, \(x) replace(x, x == "FALSE", ""))
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
  formatted <- dplyr::mutate(
    formatted,
    {{new}} := ifelse(test = .data$newvar != "",
                      yes = paste0("(", .data$newvar, ") ", {{orig}}),
                      no = {{orig}}
    )
  )
  formatted$newvar <- NULL
  dplyr::select(formatted, {{orig}}, {{new}}, dplyr::everything())

}

