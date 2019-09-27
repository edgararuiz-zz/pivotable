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
