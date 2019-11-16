context("pivottabler")

test_that("pivot_table", {
  pv <- retail_orders %>%
    pivot_columns(country) %>%
    pivot_rows(status) %>%
    pivot_values(sum(sales))
  expect_is(to_pivottabler(pv), "PivotTable")
})

test_that("pivot_prep", {
  dm <- prep_measures(
    total_sales = sum(sales),
    prep_dimensions(retail_orders, status)
  )
  pv <- dm %>%
    pivot_columns(status) %>%
    pivot_values(total_sales)
  expect_is(to_pivottabler(pv), "PivotTable")
})
