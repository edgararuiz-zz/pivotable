context("pivot")

test_that("pivot", {
  pv <- retail_orders %>%
    pivot_columns(country) %>%
    pivot_rows(status) %>%
    pivot_values(n())

  expect_is(pivot_flip(pv), "pivot_table")
  expect_equal(pivot_flip(pv), t(pv))
})
