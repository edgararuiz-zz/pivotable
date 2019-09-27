#' @export
set_cat <- function(.data, atr = "", ...) {
  UseMethod("set_cat")
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

