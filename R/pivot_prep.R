pivot_prep <- function(dimensions = NULL, measures = NULL, src = NULL){
  struc <- c(measures, dimensions)
  struc$.struct = list(
    dimensions = dimensions,
    measures = measures,
    src = src
  )
  struc$.pivot_table = pivot_table()
  structure(struc, class = "pivot_prep")
}

#' Initialize a pivot data object
#'
#' @param .data A data.frame or tbl object
#'
#' @examples
#' sales_pivot <- sales %>%
#'   start_pivot_prep() %>%
#'   dimensions(order_date = dim_hierarchy(year_id, month_id)) %>%
#'   measures(no_orders = n(), total_orders = sum(sales))
#'
#' sales_pivot %>%
#'   columns(order_date) %>%
#'   values(total_orders)
#'
#' @export
start_pivot_prep <- function(.data) {
  x <- pivot_prep()
  x$.struct$src <- .data
  x
}

#' Develop grouping categories for pivot tables
#'
#' @param x A pivot_prep object
#' @param ... A set of variable or named variables
#'
#' @examples
#' sales_pivot <- sales %>%
#'   start_pivot_prep() %>%
#'   dimensions(order_date = dim_hierarchy(year_id, month_id)) %>%
#'   measures(no_orders = n(), total_orders = sum(sales))
#'
#' sales_pivot %>%
#'   columns(order_date) %>%
#'   values(total_orders)
#'
#' @export
dimensions <- function(x, ...) {
  pivot_prep(
    dimensions = name_quos(...),
    measures = x$.struct$measures,
    src = x$.struct$src
  )
}

#' Develop values to aggregate by for pivot tables
#'
#' @param x A pivot_prep object
#' @param ... A set of variable or named variables
#'
#' @examples
#' sales_pivot <- sales %>%
#'   start_pivot_prep() %>%
#'   dimensions(order_date = dim_hierarchy(year_id, month_id)) %>%
#'   measures(no_orders = n(), total_orders = sum(sales))
#'
#' sales_pivot %>%
#'   columns(order_date) %>%
#'   values(total_orders)
#'
#' @export
measures <- function(x, ...) {
  pivot_prep(
    dimensions = x$.struct$dimensions,
    measures = name_quos(...),
    src = x$.struct$src
  )
}

#' @export
print.pivot_prep <- function(x, ...) {
  if(is.null(x$.pivot_table$src)) {
    print("pivot_prep")
  } else {
    print(to_pivottabler(x$.pivot_table))
  }
}
