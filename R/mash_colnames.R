#' Make many header rows into column names
#'
#' @param df A `data.frame` or `tibble` object in which the names are broken up
#'   across the top _n_ rows.
#' @param n_name_rows Number of rows at the top of the data to be used to create
#'   the new variable (column) names. Must be >= 1.
#' @param keep_names If TRUE, existing names will be included in building the
#'   new variable names. Defaults to TRUE.
#' @param sliding_headers If TRUE, empty values in the first (topmost) header
#'   header row be filled column-wise. Defaults to FALSE. See details.
#' @param sep Character string to separate the unified values (default is
#'   underscore).
#'
#' @return The original data frame, but with new column names and without the
#'   top n rows that held the broken up names.
#'
#' @details Tables are often shared with the column names broken up across the
#'   first few rows. This function takes the number of rows at the top of a
#'   table that hold the broken up names and whether or not to include the
#'   names, and mashes the values column-wise into a single string for each
#'   column. The \code{keep_names} argument can be helpful for tables we
#'   imported using a `skip` argument. If \code{keep_names} is set to `FALSE`,
#'   adjust the value of `n_name_rows` accordingly.
#'
#'   This function will throw a warning when possible `NA` values end up in the
#'   variable names. \code{sliding_headers} can be used for tables with ragged
#'   names in which not every column has a value in the very first row. In these
#'   cases attribution by adjacency is assumed, and when \code{sliding_headers}
#'   is set to `TRUE` the names in the topmost row are filled row-wise. This can
#'   be useful for tables reporting survey data or experimental designs in an
#'   untidy manner.
#' @author This function was originally contributed by Jarrett Byrnes through a
#'   GitHub issue.
#' @examples
#' babies <-
#'   data.frame(
#'     stringsAsFactors = FALSE,
#'     Baby = c(NA, NA, "Angie", "Yean", "Pierre"),
#'     Age = c("in", "months", "11", "9", "7"),
#'     Weight = c("kg", NA, "2", "3", "4"),
#'     Ward = c(NA, NA, "A", "B", "C")
#'   )
#' # Including the object names
#' mash_colnames(babies, n_name_rows = 2, keep_names = TRUE)
#'
#' babies_skip <-
#'   data.frame(
#'     stringsAsFactors = FALSE,
#'     X1 = c("Baby", NA, NA, "Jennie", "Yean", "Pierre"),
#'     X2 = c("Age", "in", "months", "11", "9", "7"),
#'     X3 = c("Hospital", NA, NA, "A", "B", "A")
#'   )
#' #' # Discarding the automatically-generated names (X1, X2, etc...)
#' mash_colnames(babies_skip, n_name_rows = 3, keep_names = FALSE)
#'
#' fish_experiment <-
#'   data.frame(
#'     stringsAsFactors = FALSE,
#'     X1 = c("Sample", NA, "Pacific", "Atlantic", "Freshwater"),
#'     X2 = c("Larvae", "Control", "12", "11", "10"),
#'     X3 = c(NA, "Low Dose", "11", "12", "8"),
#'     X4 = c(NA, "High Dose", "8", "7", "9"),
#'     X5 = c("Adult", "Control", "13", "13", "8"),
#'     X6 = c(NA, "Low Dose", "13", "12", "7"),
#'     X7 = c(NA, "High Dose", "10", "10", "9")
#'   )
#' # Ragged names
#' mash_colnames(fish_experiment,
#'   n_name_rows = 2,
#'   keep_names = FALSE, sliding_headers = TRUE
#' )
#' @importFrom rlang .data
#' @export
mash_colnames <- function(df,
                          n_name_rows,
                          keep_names = TRUE,
                          sliding_headers = FALSE,
                          sep = "_") {

  # Variable names
  var_names <- names(df)
  # Check that n_name_rows isn't 0
  if (n_name_rows == 0) {
    stop("Setting n_name_rows to 0 implies that names are not broken")
  }
  # Get the top n rows of the data frame that contain the column names
  new_namesdf <- df[seq_len(n_name_rows), ]
  new_namesdf$ROW_ID <- 1:n_name_rows
  # All variables as character
  new_namesdf <- data.frame(lapply(new_namesdf, as.character), stringsAsFactors = FALSE)
  # Melt for easy manipulation
  # Assign a column position
  # Make "" into NA for easier replacement
  long_namesdf <-
    tidyr::pivot_longer(new_namesdf,
      cols = -.data$ROW_ID,
      names_to = "ogcols",
      values_to = "values"
    )
  long_namesdf$values <- gsub("^$", NA, long_namesdf$values)
  long_namesdf <- dplyr::mutate(long_namesdf, col_pos = rep(
    seq_len(dplyr::n_distinct(.data$ogcols)),
    dplyr::n() / dplyr::n_distinct(.data$ogcols)
  ))

  if (sliding_headers) {
    # Group by rows
    longnamesdf_grouped <- dplyr::group_by(long_namesdf, .data$ROW_ID)
    # Slide headers in top row only
    rel_toprow <- min(longnamesdf_grouped$ROW_ID)
    toprowdf <- dplyr::filter(longnamesdf_grouped, .data$ROW_ID == rel_toprow)
    remainingrowsdf <- dplyr::filter(longnamesdf_grouped, .data$ROW_ID != rel_toprow)
    longnamesdf_grouped_filled <- tidyr::fill(toprowdf, .data$values, .direction = "down")
    # Combine
    long_namesdf_all <- dplyr::bind_rows(longnamesdf_grouped_filled, remainingrowsdf)
    long_namesdf <- dplyr::ungroup(long_namesdf_all)
  }

  # Collapse the column names together into single elements
  summrzddf <-
    dplyr::summarize(dplyr::group_by(long_namesdf, .data$col_pos),
      values = paste0(.data$values, collapse = sep),
      .groups = "keep"
    )

  if (keep_names) {
    summrzddf$headers <- var_names
    summrzddf$values <- paste(summrzddf$headers, summrzddf$values, sep = sep)
    summrzddf$headers <- NULL
  }
  # Remove NAs
  summrzddf$values <- gsub(paste0(NA,sep,"|",sep,NA), "", summrzddf$values)

  # Pivot wide with the correct column order
  summrzddfwide <-
    tidyr::pivot_wider(summrzddf,
      names_from = .data$col_pos,
      values_from = .data$values
    )
  # Assign names
  names(df) <- as.character(summrzddfwide[1, ])

  # strip the first few rows of the data frame
  df <- df[-seq_len(n_name_rows), ]
  # Check for NAs in names
  if (any(grepl("^NA$", names(df)) == TRUE)) warning("possible NA values in variable names, check the `n_name_rows` argument ")
  # Return
  df
}
