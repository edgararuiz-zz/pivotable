context("pivottabler")

test_that("pivottabler", {
  t <- mtcars %>%
    columns(am) %>%
    rows(cyl) %>%
    values(sum(mpg))
  expect_is(to_pivottabler(t), "PivotTable")
})
