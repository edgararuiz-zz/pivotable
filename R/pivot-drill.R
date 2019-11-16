#' Ordered list to create a  hierarchical dimension
#'
#' @param ... Ordered set of measures names
#'
#' @examples
#'
#' retail_orders %>%
#'   pivot_rows(order_date = dim_hierarchy(
#'     year = as.integer(format(orderdate, "%Y")),
#'     month = as.integer(format(orderdate, "%m"))
#'   )) %>%
#'   pivot_values(sum(sales))
#' @export
dim_hierarchy <- function(...) {
  structure(
    enquos(...),
    class = "dim_hierarchy"
  )
}

#' Builds a date hierarchy dimension
#'
#' @details
#'
#' Helper function that creates the unevaluated code that creates the
#' year, quarter and month on the fly.
#'
#' @param x A date variable
#'
#' @examples
#'
#' retail_orders %>%
#'   pivot_columns(order_date = dim_hierarchy_mqy(orderdate)) %>%
#'   pivot_values(n()) %>%
#'   pivot_drill(order_date)
#' @export
dim_hierarchy_mqy <- function(x) {
  x <- enquo(x)
  dim_hierarchy(
    year = as.integer(format(!!x, "%Y")),
    quarter = ifelse(as.integer(format(!!x, "%m")) <= 3, 1,
      ifelse(as.integer(format(!!x, "%m")) <= 6, 2,
        ifelse(as.integer(format(!!x, "%m")) <= 9, 3, 4)
      )
    ),
    month = as.integer(format(!!x, "%m"))
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
#'   pivot_rows(order_date = dim_hierarchy(
#'     year = as.integer(format(orderdate, "%Y")),
#'     month = as.integer(format(orderdate, "%m"))
#'   )) %>%
#'   pivot_values(sum(sales)) %>%
#'   pivot_drill(order_date)
#' @export
pivot_drill <- function(.data, ...) {
  set_pivot_drill(.data, ...)
}

set_pivot_drill <- function(.data, ...) {
  UseMethod("set_pivot_drill")
}

set_pivot_drill.pivot_prep <- function(.data, ...) {
  set_pivot_drill(.data$.pivot_table, ...)
}

set_pivot_drill.pivot_table <- function(.data, ...) {
  vars <- enquos(...)
  fields <- lapply(vars, function(x) as_label(x))
  fields <- as.character(fields)
  .data$level <- c(.data$level, fields)
  .data
}
