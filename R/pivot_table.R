#' @importFrom tidyr pivot_wider


pivot_table <- function(rows = NULL, columns = NULL, values = NULL, src = NULL){
  structure(
    list(
      rows = rows,
      columns = columns,
      values = values,
      src = src,
      res = NULL
    ),
    class = "pivot_table"
  )
}

create_table <- function(x) {
  grp_tbl <- x$src
  if(!is.null(x$rows) | !is.null(x$columns)) {
    grp_tbl <-  group_by(x$src, !!! c(x$rows, x$columns))
  }
  grp_tbl <- summarise(grp_tbl, !!! x$values)
  grp_tbl <- ungroup(grp_tbl)
  if(!is.null(x$columns)) {
    pivot_wider(
      grp_tbl,
      names_from = names(x$columns),
      values_from =  names(x$values)
    )
  }  else {
    grp_tbl
  }
}

#' @export
pivot.pivot_table <- function(.data, ...) {
  rws <- .data$rows
  cls <- .data$columns
  .data$columns <- rws
  .data$rows <- cls
  .data
}

#' @export
print.pivot_table <- function(x, ...) {
  print(create_table(x))
}

#' @export
set_cat <- function(.data, atr = "", ...) {
  UseMethod("set_cat")
}

name_quos <- function(...) {
  vars <- as.list(enquos(...))
  nm_n <- names(vars)
  nm_f <- as.character(lapply(vars, rlang::get_expr))
  nm_s <- lapply(
    seq_along(nm_n),
    function(x) ifelse(nm_n[[x]] == "", nm_f[[x]], nm_n[[x]])
  )
  nm <- as.character(nm_s)
  setNames(vars, nm)
}

set_cat.data.frame <- function(.data, atr = "", ...) {
  pt <- pivot_table()
  pt$src <- .data
  pt[[atr]] <- name_quos(...)
  pt
}

set_cat.pivot_table <- function(.data, atr = "", ...) {
  .data[[atr]] <- name_quos(...)
  .data
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
pivot <- function(.data, atr = "", ...) {
  UseMethod("pivot")
}
