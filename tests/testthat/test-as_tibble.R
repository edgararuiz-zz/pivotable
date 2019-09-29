context("coerce table")

test_that("from pivot_table", {
  t <- mtcars %>%
    columns(am) %>%
    rows(cyl) %>%
    values(sum(mpg))
  expect_is(as_tibble(t), "tbl")
})

test_that("from pivot_table", {
  t <- mtcars %>%
    dimensions(am) %>%
    measures(counts = sum(mpg)) %>%
    rows(am) %>%
    values(counts)
  expect_is(as_tibble(t), "tbl")
})
