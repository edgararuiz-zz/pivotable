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
