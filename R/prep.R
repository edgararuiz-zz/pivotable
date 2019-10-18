#' Develop grouping categories for pivot tables
#'
#' @param x A pivot_prep object
#' @param ... A set of variable or named variables
#'
#' @examples
#'
#' sales_pivot <- retail_orders %>%
#'   prep_dimensions(order_date = dim_hierarchy(
#'     year = as.integer(format(orderdate, "%Y")),
#'     month = as.integer(format(orderdate, "%m"))
#'   )) %>%
#'   prep_measures(no_orders = n(), total_orders = sum(sales))
#'
#' sales_pivot %>%
#'   pivot_columns(order_date) %>%
#'   pivot_values(total_orders)
#'
#' @export
prep_dimensions <- function(x, ...) {
  pivot_prep(
    dimensions = name_quos(...),
    measures = if (is.null(x[[".struct"]])) {
      NULL
    } else {
      x$.struct$measures
    },
    src = get_src(x)
  )
}

#' Develop values to aggregate by for pivot tables
#'
#' @param x A pivot_prep object
#' @param ... A set of variable or named variables
#'
#' @examples
#'
#' sales_pivot <- retail_orders %>%
#'   prep_dimensions(order_date = dim_hierarchy(
#'     year = as.integer(format(orderdate, "%Y")),
#'     month = as.integer(format(orderdate, "%m"))
#'   )) %>%
#'   prep_measures(no_orders = n(), total_orders = sum(sales))
#'
#' sales_pivot %>%
#'   pivot_columns(order_date) %>%
#'   pivot_values(total_orders)
#'
#' @export
prep_measures <- function(x, ...) {
  pivot_prep(
    dimensions = if (is.null(x[[".struct"]])) {
      NULL
    } else {
      x$.struct$dimensions
    },
    measures = name_quos(...),
    src = get_src(x)
  )
}

#' @export
print.pivot_prep <- function(x, ...) {
  if (is.null(x$.pivot_table$src)) {
    print("pivot_prep")
  } else {
    print(to_pivottabler(x$.pivot_table))
  }
}

get_src <- function(x) {
  UseMethod("get_src")
}

get_src.pivot_prep <- function(x) {
  x$.struct$src
}

get_src.default <- function(x) {
  x
}

pivot_prep <- function(dimensions = NULL, measures = NULL, src = NULL) {
  struc <- c(measures, dimensions)
  struc$.struct <- list(
    dimensions = dimensions,
    measures = measures,
    src = src
  )
  struc$.pivot_table <- pivot_table()
  structure(struc, class = "pivot_prep")
}
