#' Coerce to a pivottabler object
#'
#' @param x A pivot_prep or pivot_table object
#' @param include_column_totals Indicates if the column totals are included in the pivot table
#' @param include_row_totals Indicates if the row totals are included in the pivot table
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
to_pivottabler <- function(x,
                           include_column_totals = NULL,
                           include_row_totals = NULL
                           ) {
  UseMethod("to_pivottabler")
}

#' @export
to_pivottabler.pivot_prep <- function(x,
                                      include_column_totals = NULL,
                                      include_row_totals = NULL
                                      ) {
  to_pivottabler(
    x$.pivot_table,
    include_column_totals = include_column_totals,
    include_row_totals = include_row_totals
    )
}

#' @export
to_pivottabler.pivot_table <- function(x,
                                       include_column_totals = NULL,
                                       include_row_totals = NULL
                                       ) {

  total_cols <- TRUE
  if(!is.null(x$totals$include_column))
    total_cols <- get_expr(x$totals$include_column)
  if(!is.null(include_column_totals))
    total_cols <- include_column_totals

  total_rows <- TRUE
  if(!is.null(x$totals$include_row))
    total_rows <- get_expr(x$totals$include_row)
  if(!is.null(include_row_totals))
    total_rows <- include_row_totals

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
      pt$addColumnDataGroups(
        col_names[i],
        addTotal = total_cols
        )
  }
  if (!is.null(row_names)) {
    for (i in seq_along(row_names))
      pt$addRowDataGroups(
        row_names[i],
        addTotal = total_rows
        )
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
