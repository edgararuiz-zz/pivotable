context("coerce table")

test_that("from pivot_table", {
  pv <- retail_orders %>%
    pivot_columns(country) %>%
    pivot_rows(status) %>%
    pivot_values(sum(sales))
  expect_is(as_tibble(pv), "tbl")
})
