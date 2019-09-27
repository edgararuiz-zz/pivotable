#' @importFrom magrittr %>%
#' @export %>%
#' @importFrom dplyr summarise
#' @importFrom dplyr group_by
#' @importFrom dplyr ungroup
#' @importFrom dplyr as_tibble
#' @importFrom stats setNames
#' @import pivottabler
#' @import rlang

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

# create_table <- function(x) {
#   grp_tbl <- x$src
#   rows <- get_dim_quo(x$rows, x$level)
#   columns <- get_dim_quo(x$columns, x$level)
#   if(!is.null(rows) | !is.null(columns)) {
#     grp_tbl <-  group_by(x$src, !!! c(rows, columns))
#   }
#   grp_tbl <- summarise(grp_tbl, !!! values)
#   grp_tbl <- ungroup(grp_tbl)
#   if(!is.null(columns)) {
#     pivot_wider(
#       grp_tbl,
#       names_from = names(columns),
#       values_from =  names(values)
#     )
#   }  else {
#     grp_tbl
#   }
# }
