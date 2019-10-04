context("pivot_prep")

test_that("Pivot preparation works", {
  sales_pivot <- retail_orders %>%
    dimensions(order_date = dim_hierarchy(
      year = as.integer(format(orderdate, "%Y")),
      month = as.integer(format(orderdate, "%m"))
    )) %>%
    measures(no_orders = dplyr::n(), total_orders = sum(sales))
  expect_equal(class(sales_pivot), "pivot_prep")
  expect_output(print(sales_pivot))
  expect_output(print(values(sales_pivot, no_orders)))

  sales_pivot_2 <- retail_orders %>%
    measures(no_orders = n(), total_orders = sum(sales))
  expect_equal(class(sales_pivot_2), "pivot_prep")

  sales_pivot_3 <- retail_orders %>%
    dimensions(order_date = dim_hierarchy(
      year = as.integer(format(orderdate, "%Y")),
      month = as.integer(format(orderdate, "%m"))
    ))
  expect_equal(class(sales_pivot_3), "pivot_prep")
})

test_that("Pivot preparation works", {
  sales_pivot <- retail_orders %>%
    dimensions(order_date = dim_hierarchy(
      year = as.integer(format(orderdate, "%Y")),
      month = as.integer(format(orderdate, "%m"))
      )) %>%
    measures(no_orders = dplyr::n(), total_orders = sum(sales)) %>%
    rows(order_date) %>%
    values(no_orders)

  expect_output(print(drill(sales_pivot, order_date)))
  expect_output(print(pivot(sales_pivot)))
})

