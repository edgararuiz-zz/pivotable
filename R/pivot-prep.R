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

pivot_prep_print <- function(x) {
  struct <-  x$.struct
  d_names <- names(struct$dimensions)
  d_names <- c("**Name**", d_names)
  d_max <- max(nchar(d_names))
  d_names <- lapply(d_names, function(x) paste0(x, paste0(rep(" ", d_max - nchar(x)), collapse = "")))
  d_exprs <- lapply(struct$dimensions, as_label)
  #d_exprs <- lapply(d_exprs, function(x) x[[2]])
  d_exprs <- c("**Field / Calc**", d_exprs)
  d_lines <- lapply(
    seq_along(d_names),
    function(x) {
      paste0("  ", d_names[x], " - ", d_exprs[x], " \n")
    }
  )
  d_lines <- as.character(d_lines)
  m_names <- names(struct$measures)
  m_names <- c("**Name**", m_names)
  m_max <- max(nchar(m_names))
  m_names <- lapply(m_names, function(x) paste0(x, paste0(rep(" ", m_max - nchar(x)), collapse = "")))
  m_exprs <- lapply(struct$measures, as_label)
  m_exprs <- c("**Aggregate Calc**", m_exprs)
  m_lines <- lapply(
    seq_along(m_names),
    function(x) {
      paste0("  ", m_names[x], " - ", m_exprs[x], "\n")
    }
  )
  m_lines <- as.character(m_lines)
  c("pivot_prep\n", "Dimensions\n", d_lines, "Measures\n", m_lines)
}

#' @export
print.pivot_prep <- function(x, ...) {
  if (is.null(x$.pivot_table$src)) {
    cat(pivot_prep_print(x))
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
