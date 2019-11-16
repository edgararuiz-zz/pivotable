#' Switch the columns with the rows on a pivot table
#'
#' @param .data A pivot_table object
#'
#' @examples
#' retail_orders %>%
#'   pivot_rows(status) %>%
#'   pivot_columns(country) %>%
#'   pivot_values(n()) %>%
#'   pivot_flip()
#' @export
pivot_flip <- function(.data) {
  UseMethod("pivot_flip")
}

#' @export
pivot_flip.pivot_table <- function(.data) {
  rws <- .data$rows
  cls <- .data$columns
  .data$columns <- rws
  .data$rows <- cls
  .data
}

#' @export
pivot_flip.pivot_prep <- function(.data, ...) {
  pivot_flip(.data$.pivot_table)
}


#' @export
t.pivot_table <- function(x) {
  pivot_flip(x)
}

#' @export
t.pivot_prep <- function(x) {
  pivot_flip(x$.pivot_table)
}
