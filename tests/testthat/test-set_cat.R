context("set_cat")

test_that("set_cat", {
  expect_is(set_cat(mtcars, "measure", am), "pivot_table")
  expect_is(set_cat(dplyr::as_tibble(mtcars), "measure", am), "pivot_table")
})


test_that("set_cat pivot def", {
  pf <- dimensions(mtcars, am, cyl)
  expect_is(set_cat(pf), "pivot_prep")
  expect_is(get_dim_quo(dim_hierarchy(cyl, am), 2), "quosures")
})
