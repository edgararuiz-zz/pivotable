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

to_pivottabler <- function(x) {
  grp_tbl <- x$src
  rows <- get_dim_quo(x$rows, x$level)
  columns <- get_dim_quo(x$columns, x$level)

  if(!is.null(rows) | !is.null(columns)) {
    grp_tbl <-  group_by(x$src, !!! c(rows, columns))
  }
  grp_tbl <- summarise(grp_tbl, !!! x$values)
  grp_tbl <- ungroup(grp_tbl)

  row_names <- names(rows)
  col_names <- names(columns)
  val_names <- names(x$values)

  pt <- pivottabler::PivotTable$new()
  pt$addData(grp_tbl)
  if(!is.null(col_names))
    for(i in seq_along(col_names)) pt$addColumnDataGroups(col_names[i])
  if(!is.null(row_names))
    for(i in seq_along(row_names)) pt$addRowDataGroups(row_names[i])
  if(!is.null(val_names)) {
    for(i in seq_along(val_names)) {
      pt$defineCalculation(
        calculationName = val_names,
        summariseExpression = paste0("sum(`", val_names, "`)")
      )
    }
  }
  pt$evaluatePivot()
  pt
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
  print(to_pivottabler(x))
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

#' @export
pivot <- function(.data, atr = "", ...) {
  UseMethod("pivot")
}

get_dim_quo <- function(x, level) {
  dim_classes <- as.character(
    lapply(x,function(y) class(rlang::quo_squash(y)))
  )
  dc <- quos()
  for(i in seq_along(dim_classes)) {
    if(dim_classes[i] == "call") {
      fd <- eval(rlang::quo_squash(x[[i]]))
      lvs <-  sum(level == names(x)) + 1
      ts <- quos()
      for(j in seq_len(lvs)) {
        ts <- c(ts, name_quos(!!! fd[j]))
      }
      dc <- c(dc, ts)
    } else {
      dc <- c(dc, x[i])
    }
  }
  if(length(dc) == 0) {
    return(NULL)
  } else {
    dc
  }
}

#' @export
dim_hierarchy <- function(...) {
  structure(
    enquos(...),
    class = "dim_hierarchy"
  )
}
