context("pivot_prep")

test_that("Pivot preparation works", {
  sales_pivot <- sales %>%
    start_pivot_prep() %>%
    dimensions(order_date = dim_hierarchy(year_id, month_id)) %>%
    measures(no_orders = n(), total_orders = sum(sales))
  expect_equal(class(sales_pivot), "pivot_prep")
})
