
#' @export
as_tibble.pivot_prep <- function(x, ..., .rows = NULL,
                                 .name_repair = c("check_unique", "unique", "universal", "minimal"),
                                 rownames = pkgconfig::get_config("tibble::rownames", NULL)) {
  as_tibble(
    x$.pivot_table,
    .rows = .rows,
    .name_repair = .name_repair,
    rownames = rownames,
    ...
  )
}

#' @export
as_tibble.pivot_table <- function(x, ..., .rows = NULL,
                                  .name_repair = c("check_unique", "unique", "universal", "minimal"),
                                  rownames = pkgconfig::get_config("tibble::rownames", NULL)) {
  pt <- to_pivottabler(x)
  tb <- as_tibble(
    pt$asDataFrame(),
    .rows = .rows,
    .name_repair = .name_repair,
    rownames = rownames,
    ...
  )
  tb
}
