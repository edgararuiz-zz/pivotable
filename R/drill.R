#' Ordered list to create a  hierarchical dimension
#'
#' @param ... Ordered set of measures names
#'
#' @examples
#'
#' sales %>%
#'   rows(date = dim_hierarchy(year_id, month_id)) %>%
#'   values(n())
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
#' sales %>%
#'   rows(date = dim_hierarchy(year_id, month_id)) %>%
#'   values(n()) %>%
#'   drill()
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
