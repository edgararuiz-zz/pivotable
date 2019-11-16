context("drill")

pv <- retail_orders %>%
  pivot_columns(country) %>%
  pivot_rows(status) %>%
  pivot_values(n())

test_that("drill", {
  expect_is(pivot_drill(pv), "pivot_table")
})

test_that("mqy dimension", {
  expect_is(
    dim_hierarchy_mqy(as.Date("2012-01-01")),
    "dim_hierarchy"
    )
})

context("focus")

test_that("focus", {
  expect_is(
    pivot_focus(pv, country == "Australia"),
    "pivot_table"
    )
})
