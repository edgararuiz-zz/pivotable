context("pivot")

test_that("pivot", {
  t <- mtcars %>%
    columns(am) %>%
    rows(cyl) %>%
    values(n())
  expect_is(pivot(t), "pivot_table")
})
