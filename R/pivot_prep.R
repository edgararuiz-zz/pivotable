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

#' @export
start_pivot_prep <- function(.data) {
  x <- pivot_prep()
  x$.struct$src <- .data
  x
}

#' @export
dimensions <- function(x, ...) {
  pivot_prep(
    dimensions = name_quos(...),
    measures = x$.struct$measures,
    src = x$.struct$src
  )
}

#' @export
measures <- function(x, ...) {
  pivot_prep(
    dimensions = x$.struct$dimensions,
    measures = name_quos(...),
    src = x$.struct$src
  )
}

#' @export
pivot.pivot_prep <- function(.data, ...) {
  pivot(.data$.pivot_table)
}

#' @export
print.pivot_prep <- function(x, ...) {
  if(is.null(x$.pivot_table$src)) {
    print("pivot_prep")
  } else {
    print(to_pivottabler(x$.pivot_table))
  }
}

set_cat.pivot_prep <- function(.data, atr = "", ...) {
  vars <- enquos(...)
  .data$.pivot_table$src <- .data$.struct$src
  nv <- lapply(
    as.list(vars),
    function(x) setNames(list(.data[[as_label(x)]]), as.character(as_label(x)))
  )
  nvt <- NULL
  for(i in seq_along(nv)){ nvt <- c(nvt, nv[[i]])}
  .data$.pivot_table[[atr]] <- nvt
  .data
}
