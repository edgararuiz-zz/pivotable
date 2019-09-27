#' @export
to_pivottabler <- function(x) {
  UseMethod("to_pivottabler")
}

#' @export
to_pivottabler.pivot_prep <- function(x) {
  to_pivottabler(x$.pivot_table)
}

#' @export
to_pivottabler.pivot_table <- function(x) {
  grp_tbl <- x$src
  rows <- get_dim_quo(x$rows, x$level)
  columns <- get_dim_quo(x$columns, x$level)

  if(!is.null(rows) | !is.null(columns)) {
    grp_tbl <-  group_by(x$src, !!! c(rows, columns))
  }
  grp_tbl <- summarise(grp_tbl, !!! x$values)
  grp_tbl <- ungroup(grp_tbl)

  row_names <- names(rows)
  col_names <- names(columns)
  val_names <- names(x$values)

  pt <- pivottabler::PivotTable$new()
  pt$addData(grp_tbl)
  if(!is.null(col_names))
    for(i in seq_along(col_names)) pt$addColumnDataGroups(col_names[i])
  if(!is.null(row_names))
    for(i in seq_along(row_names)) pt$addRowDataGroups(row_names[i])
  if(!is.null(val_names)) {
    for(i in seq_along(val_names)) {
      pt$defineCalculation(
        calculationName = val_names,
        summariseExpression = paste0("sum(`", val_names, "`)")
      )
    }
  }
  pt$evaluatePivot()
  pt
}
