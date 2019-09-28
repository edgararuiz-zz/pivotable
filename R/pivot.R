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

calculate_pivot <- function(x) {
  grp_tbl <- x$src
  rows <- get_dim_quo(x$rows, x$level)
  columns <- get_dim_quo(x$columns, x$level)

  if(!is.null(rows) | !is.null(columns)) {
    grp_tbl <-  group_by(x$src, !!! c(rows, columns))
  }
  grp_tbl <- summarise(grp_tbl, !!! x$values)
  grp_tbl <- ungroup(grp_tbl)
  collect(grp_tbl)
}

