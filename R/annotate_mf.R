#' Annotate meaningful formatting
#'
#' @param xlfilepath Path to a single-sheet spreadsheet file (xls or xlsx).
#' @param orig Variable to annotate formatting in.
#' @param new Name of new variable with cell formatting pasted as a string.
#'
#' @return A tibble with a new column with meaningful formatting embedded as
#'   text.
#' @details At this point, only four popular approaches for meaningful
#'   formatting (bold, italic, underline, cell highlighting) are hardcoded in
#'   the function. `sheets`, `skip`, and `range` arguments for spreadsheet input
#'   are not supported. The HTML code of the fill color used for cell
#'   highlighting is also appended in the output. Ensure the data in the
#'   spreadsheet are rectangular before running.
#' @examples
#' example_spreadsheet <- system.file("extdata/dog_test.xlsx", package = "unheadr")
#' annotate_mf(example_spreadsheet, orig = Task, new = Task_annotated)
#' @importFrom rlang :=
#' @importFrom rlang .data
#' @export
annotate_mf <- function(xlfilepath, orig, new) {
  orig <- dplyr::enquo(orig) # tidyeval
  new <- dplyr::enquo(new) # tidyeval

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

  # meaningful formatting
  bolded <- format_defs$local$font$bold
  italic <- format_defs$local$font$italic
  underlined <- format_defs$local$font$underline
  highlighted <- format_defs$local$fill$patternFill$patternType
  hl_color <- format_defs$local$fill$patternFill$fgColor$rgb
  format_opts <- tibble::lst(bolded, italic, highlighted, underlined, hl_color)
  formatting_indicators <- dplyr::bind_cols(lapply(
    format_opts,
    function(x) x[m_formatting$local_format_id]
  ))
  format_joined <- dplyr::bind_cols(m_formatting, formatting_indicators)
  col_orig <- format_joined$col[match(
    paste0(rlang::as_name(orig)),
    format_joined$character
  )]

  # target variable
  orig_format <- dplyr::filter(format_joined, row >= 2 & col == col_orig)
  orig_format <- dplyr::select(orig_format, bolded:hl_color)
  formatted <- dplyr::bind_cols(spsheet, orig_format)
  formatted <- dplyr::mutate_at(
    formatted, dplyr::vars(bolded:hl_color),
    ~ replace(., is.na(.), FALSE)
  )
  formatted$highlighted <- gsub(
    pattern = "[^FALSE].*", replacement = "TRUE",
    formatted$highlighted
  )
  formatted$underlined <- gsub(
    pattern = "[^FALSE].*", replacement = "TRUE",
    formatted$underlined
  )
  formatted$hl_color <- gsub(
    pattern = "FALSE", replacement = "",
    formatted$hl_color
  )
  formatted <- dplyr::mutate_at(
    formatted, dplyr::vars(bolded:underlined),
    as.logical
  )
  # swap na with variable names
  formatted <- dplyr::mutate_at(
    formatted, dplyr::vars(bolded:underlined),
    function(x) {
      ifelse(x == TRUE, deparse(substitute(x)), x)
    }
  )
  formatted <- dplyr::mutate_at(
    formatted,
    dplyr::vars(bolded:underlined), ~ replace(., . == "FALSE", "")
  )
  # build annotation strings
  formatted$highlighted <- ifelse(formatted$highlighted != "",
                                  paste0(formatted$highlighted, "-", formatted$hl_color), formatted$highlighted
  )
  formatted$hl_color <- NULL
  formatted$newvar <-
    paste(
      formatted$bolded, formatted$italic,
      formatted$highlighted, formatted$underlined
    )
  formatted$newvar <- stringr::str_squish(formatted$newvar)
  formatted$newvar <- gsub(" ", ", ", formatted$newvar)
  formatted <- dplyr::select(formatted, -c(bolded:underlined))
  formatted <- dplyr::mutate(
    formatted,
    !!new := ifelse(test = .data$newvar != "",
                    yes = paste0("(", .data$newvar, ") ", !!orig),
                    no = !!orig
    )
  )
  formatted$newvar <- NULL
  formatted <- dplyr::select(formatted, !!orig, !!new, dplyr::everything())
  formatted
}
