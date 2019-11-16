#' @export
as_tibble.pivot_table <- function(x, ..., .rows = NULL,
                                  .name_repair = c("check_unique", "unique", "universal", "minimal"),
                                  rownames = pkgconfig::get_config("tibble::rownames", NULL)) {
  pt <- to_pivottabler(
    x,
    include_column_totals = FALSE,
    include_row_totals = FALSE
  )
  tb <- as_tibble(
    pt$asDataFrame(),
    .rows = .rows,
    .name_repair = .name_repair,
    rownames = "row_name",
    ...
  )
  tb
}
