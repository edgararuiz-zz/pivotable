#' @export
pivot <- function(.data, atr = "", ...) {
  UseMethod("pivot")
}

#' @export
pivot.pivot_table <- function(.data, ...) {
  rws <- .data$rows
  cls <- .data$columns
  .data$columns <- rws
  .data$rows <- cls
  .data
}
