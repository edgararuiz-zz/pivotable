#' Ordered list to create a  hierarchical dimension
#'
#' @param ... Ordered set of measures names
#'
#' @examples
#'
#' retail_orders %>%
#'   rows(order_date = dim_hierarchy(
#'     year = as.integer(format(orderdate, "%Y")),
#'     month = as.integer(format(orderdate, "%m"))
#'   )) %>%
#'   values(sum(sales))
#'
#' @export
dim_hierarchy <- function(...) {
  structure(
    enquos(...),
    class = "dim_hierarchy"
  )
}

#' Drill into a hierarchy dimension
#'
#' @param .data A data.frame or a pivot_prep object
#' @param ...   Variable or variables to drill by
#'
#' @examples
#'
#' retail_orders %>%
#'   rows(order_date = dim_hierarchy(
#'     year = as.integer(format(orderdate, "%Y")),
#'     month = as.integer(format(orderdate, "%m"))
#'   )) %>%
#'   values(sum(sales))
#'
#' @export
drill <- function(.data, ...) {
  set_drill(.data, ...)
}

set_drill <- function(.data, ...) {
  UseMethod("set_drill")
}

set_drill.pivot_prep <- function(.data, ...) {
  set_drill(.data$.pivot_table, ...)
}

set_drill.pivot_table <- function(.data, ...) {
  vars <- enquos(...)
  fields <- lapply(vars, function(x) as_label(x))
  fields <- as.character(fields)
  .data$level <- c(.data$level, fields)
  .data
}
