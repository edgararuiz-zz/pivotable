context("drill")

test_that("drill", {
  pv <- retail_orders %>%
    pivot_columns(country) %>%
    pivot_rows(status) %>%
    pivot_values(n())
  expect_is(pivot_drill(pv), "pivot_table")
})

test_that("mqy dimension", {
  expect_is(
    dim_hierarchy_mqy(as.Date("2012-01-01")),
    "dim_hierarchy"
    )
})
