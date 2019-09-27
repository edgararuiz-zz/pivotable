#' @importFrom tidyr pivot_wider
#' @import pivottabler

pivot_table <- function(rows = NULL, columns = NULL, values = NULL, src = NULL){
  structure(
    list(
      rows = rows,
      columns = columns,
      values = values,
      level = list()
    ),
    class = "pivot_table"
  )
}

#' @export
print.pivot_table <- function(x, ...) {
  print(to_pivottabler(x))
}

#' @export
rows <- function(.data, ...) {
  set_cat(.data, "rows", ...)
}

#' @export
columns <- function(.data, ...) {
  set_cat(.data, "columns", ...)
}

#' @export
values <- function(.data, ...) {
  set_cat(.data, "values", ...)
}

#' @export
drill <- function(.data, ...) {
  set_drill(.data, ...)
}

create_table <- function(x) {
  grp_tbl <- x$src
  rows <- get_dim_quo(x$rows, x$level)
  columns <- get_dim_quo(x$columns, x$level)
  if(!is.null(rows) | !is.null(columns)) {
    grp_tbl <-  group_by(x$src, !!! c(rows, columns))
  }
  grp_tbl <- summarise(grp_tbl, !!! values)
  grp_tbl <- ungroup(grp_tbl)
  if(!is.null(columns)) {
    pivot_wider(
      grp_tbl,
      names_from = names(columns),
      values_from =  names(values)
    )
  }  else {
    grp_tbl
  }
}
