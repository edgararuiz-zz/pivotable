pivot_table <- function(rows = NULL, columns = NULL, values = NULL, src = NULL) {
  structure(
    list(
      rows = rows,
      columns = columns,
      values = values,
      focus = NULL,
      retain = NULL,
      level = list()
    ),
    class = "pivot_table"
  )
}

#' @export
print.pivot_table <- function(x, ...) {
  print(to_pivottabler(x))
}
