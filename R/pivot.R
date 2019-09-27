#' Switch the columns with the rows on a pivot table
#'
#' @param .data A pivot_table object
#'
#' @examples
#' sales %>%
#'   rows(status) %>%
#'   columns(year_id) %>%
#'   values(n()) %>%
#'   pivot()
#'
#' @export
pivot <- function(.data) {
  UseMethod("pivot")
}

#' @export
pivot.pivot_table <- function(.data) {
  rws <- .data$rows
  cls <- .data$columns
  .data$columns <- rws
  .data$rows <- cls
  .data
}

#' @export
pivot.pivot_prep <- function(.data, ...) {
  pivot(.data$.pivot_table)
}

