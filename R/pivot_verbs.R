#' Manipulate pivot tables
#'
#' @param .data A data.frame or a pivot_prep object
#' @param ...   Variables or calculation to group by
#' @name rows-cols

#' @rdname rows-cols
#'
#' @examples
#'
#' sales %>%
#'   rows(status) %>%
#'   columns(year_id) %>%
#'   values(n())
#'
#' @export
rows <- function(.data, ...) {
  set_cat(.data, "rows", ...)
}

#' @rdname rows-cols
#' @export
columns <- function(.data, ...) {
  set_cat(.data, "columns", ...)
}

#' Add an aggregation to a pivot table
#'
#' @param .data A data.frame or a pivot_prep object
#' @param ...   Variables or calculation to aggregate by
#'
#' @examples
#'
#' sales %>%
#'   rows(status) %>%
#'   values(n())
#'
#' @export
values <- function(.data, ...) {
  set_cat(.data, "values", ...)
}


