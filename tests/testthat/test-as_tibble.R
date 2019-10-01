context("coerce table")

test_that("from pivot_table", {
  t <- mtcars %>%
    columns(am) %>%
    rows(cyl) %>%
    values(sum(mpg))
  expect_is(as_tibble(t), "tbl")
})
