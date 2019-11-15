#' Coerce to a pivottabler object
#'
#' @param x A pivot_prep or pivot_table object
#' @param remove_totals Indicates if the totals are included in the pivot table
#'
#' @examples
#'
#' pt <- retail_orders %>%
#'   pivot_rows(status) %>%
#'   pivot_columns(country) %>%
#'   pivot_values(n()) %>%
#'   to_pivottabler()
#'
#' pt$asMatrix()
#' @export
to_pivottabler <- function(x, remove_totals = FALSE) {
  UseMethod("to_pivottabler")
}

#' @export
to_pivottabler.pivot_prep <- function(x, remove_totals = FALSE) {
  to_pivottabler(x$.pivot_table, remove_totals = remove_totals)
}

#' @export
to_pivottabler.pivot_table <- function(x, remove_totals = FALSE) {
  grp_tbl <- calculate_pivot(x)

  rows <- get_dim_quo(x$rows, x$level)
  columns <- get_dim_quo(x$columns, x$level)

  row_names <- names(rows)
  col_names <- names(columns)
  val_names <- names(x$values)

  pt <- pivottabler::PivotTable$new()
  pt$addData(grp_tbl)
  if (!is.null(col_names)) {
    for (i in seq_along(col_names))
      pt$addColumnDataGroups(col_names[i], addTotal = !remove_totals)
  }
  if (!is.null(row_names)) {
    for (i in seq_along(row_names))
      pt$addRowDataGroups(row_names[i], addTotal = !remove_totals)
  }
  if (!is.null(val_names)) {
    for (i in seq_along(val_names)) {
      pt$defineCalculation(
        calculationName = val_names[i],
        summariseExpression = paste0("sum(`", val_names[i], "`)")
      )
    }
  }
  pt$evaluatePivot()
  pt
}
