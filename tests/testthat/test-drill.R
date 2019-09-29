context("drill")

test_that("drill", {
  t <- mtcars %>%
    columns(am) %>%
    rows(cyl) %>%
    values(n())
  expect_is(drill(t), "pivot_table")
})
