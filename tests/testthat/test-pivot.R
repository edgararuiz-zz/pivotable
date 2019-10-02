context("pivot")

test_that("pivot", {
  t <- mtcars %>%
    columns(am) %>%
    rows(cyl) %>%
    values(mean(mpg)) %>%
    focus(cyl == 6)
  expect_is(pivot(t), "pivot_table")
})
