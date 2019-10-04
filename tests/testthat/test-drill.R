context("drill")

test_that("drill", {
  t <- mtcars %>%
    columns(am) %>%
    rows(cyl) %>%
    values(n())
  expect_is(drill(t), "pivot_table")
})

test_that("mqy dimension", {
  expect_is(
    dim_hierarchy_mqy(as.Date("2012-01-01")),
    "dim_hierarchy"
    )
})
