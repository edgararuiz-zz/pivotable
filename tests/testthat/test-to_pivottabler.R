context("pivottabler")

test_that("pivottabler", {
  t <- retail_orders %>%
    pivot_columns(country) %>%
    pivot_rows(status) %>%
    pivot_values(sum(sales))
  expect_is(to_pivottabler(t), "PivotTable")
})
