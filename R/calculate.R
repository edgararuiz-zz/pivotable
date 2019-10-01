calculate_pivot <- function(x) {
  gtl <-  calculate_aggregate(x)
  if(!is.null(x$focus)) {
    gtl <- filter(gtl, !!! setNames(x$focus, NULL))
  }
  gtl
}

calculate_aggregate <- function(x) {
  grp_tbl <- x$src
  rows <- get_dim_quo(x$rows, x$level)
  columns <- get_dim_quo(x$columns, x$level)
  if (!is.null(rows) | !is.null(columns)) {
    grp_tbl <- group_by(x$src, !!!c(rows, columns))
  }
  grp_tbl <- summarise(grp_tbl, !!!x$values)
  grp_tbl <- ungroup(grp_tbl)
  collect(grp_tbl)
}
