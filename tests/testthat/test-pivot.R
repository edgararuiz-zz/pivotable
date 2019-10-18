context("pivot")

test_that("pivot", {
  t <- retail_orders %>%
    pivot_columns(country) %>%
    pivot_rows(status) %>%
    pivot_values(n())
  expect_is(pivot_flip(t), "pivot_table")
})
