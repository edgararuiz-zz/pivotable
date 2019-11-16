context("set_cat")

test_that("set_cat", {
  expect_is(
    set_cat(as.data.frame(retail_orders), "measure", status),
    "pivot_table"
    )
  expect_is(
    set_cat(dplyr::as_tibble(retail_orders), "measure", status),
    "pivot_table"
    )
})


test_that("set_cat pivot def", {
  pf <- prep_dimensions(retail_orders, status, country)
  expect_is(set_cat(pf), "pivot_prep")
  expect_is(
    get_dim_quo(dim_hierarchy(status, country), 2),
    "quosures"
    )
})
