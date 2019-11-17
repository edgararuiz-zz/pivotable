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

test_that("default total display works", {
  expect_silent(
    pivot_default_totals(
      include_column_totals = TRUE,
      include_row_totals = TRUE
    )
  )

  expect_is(
    retail_orders %>%
      pivot_rows(status, country) %>%
      pivot_values(sum(sales)) %>%
      to_pivottabler(),
    "PivotTable"
  )

  expect_silent(
    pivot_default_totals(
      include_column_totals = FALSE,
      include_row_totals = FALSE
    )
  )
})
