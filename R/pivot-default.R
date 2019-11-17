#' Set the default agregation for an R session
#'
#' @param ...   Variables or calculation to aggregate by
#'
#' @details
#'
#' It records the named quotation variables into via the options() command, inside
#' the "pivotable_default_values" option.
#'
#' @examples
#'
#' pivot_default_values(n())
#'
#' retail_orders %>%
#'   pivot_rows(status)
#'
#' pivot_default_values(sum(sales))
#'
#' retail_orders %>%
#'   pivot_rows(status)
#' @export
pivot_default_values <- function(...) {
  vrs <- name_quos(...)
  options(pivotable_default_values = vrs)
}

#' Set a default to display totals for an R session
#'
#' @param include_column_totals Indicates if the column totals are included in the pivot table
#' @param include_row_totals Indicates if the row totals are included in the pivot table
#'
#' @examples
#'
#' pivot_default_totals(TRUE, TRUE)
#'
#' retail_orders %>%
#'   pivot_rows(status, country) %>%
#'   pivot_values(n())
#'
#' @export
pivot_default_totals <- function(include_column_totals = TRUE,
                                 include_row_totals = TRUE) {
  options(pivotable_include_columns = include_column_totals)
  options(pivotable_include_rows = include_row_totals)
}
