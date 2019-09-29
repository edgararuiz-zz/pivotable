#' @importFrom magrittr %>%
#' @export %>%
#' @importFrom dplyr summarise
#' @importFrom dplyr group_by
#' @importFrom dplyr ungroup
#' @importFrom dplyr as_tibble
#' @importFrom dplyr collect
#' @importFrom stats setNames
#' @import pivottabler
#' @import rlang

pivot_table <- function(rows = NULL, columns = NULL, values = NULL, src = NULL) {
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
