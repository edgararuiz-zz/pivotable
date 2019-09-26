
<!-- README.md is generated from README.Rmd. Please edit that file -->

# pivotable

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/pivotable)](https://CRAN.R-project.org/package=pivotable)
<!-- badges: end -->

The goal of pivotable is to …

## Installation

You can install the released version of pivotable from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("pivotable")
```

## Example

``` r
library(dplyr)
library(pivotable)

mtcars %>%
  values(sum(mpg))
#>   sum(mpg)
#> 1    642.9

mtcars %>%
  rows(am) %>%
  values(sum(mpg))
#> # A tibble: 2 x 2
#>      am `sum(mpg)`
#>   <dbl>      <dbl>
#> 1     0       326.
#> 2     1       317.

mtcars %>%
  rows(am) %>%
  columns(cyl) %>%
  values(sum(mpg))
#> # A tibble: 2 x 4
#>      am   `4`   `6`   `8`
#>   <dbl> <dbl> <dbl> <dbl>
#> 1     0  68.7  76.5 181. 
#> 2     1 225.   61.7  30.8

mtcars %>%
  rows(am) %>%
  columns(cyl) %>%
  values(sum(mpg)) %>%
  pivot()
#> # A tibble: 3 x 3
#>     cyl   `0`   `1`
#>   <dbl> <dbl> <dbl>
#> 1     4  68.7 225. 
#> 2     6  76.5  61.7
#> 3     8 181.   30.8
```

``` r
car_pivot <- mtcars %>%
  start_pivot_prep() %>%
  dimensions(
    transmission = am,
    cylinder = cyl
  ) %>%
  measures(
    no_vehicles = n(),
    avg_miles = mean(mpg)
  )

car_pivot %>%
  rows(transmission) %>%
  columns(cylinder) %>%
  values(no_vehicles)
#> # A tibble: 2 x 4
#>   transmission   `4`   `6`   `8`
#>          <dbl> <int> <int> <int>
#> 1            0     3     4    12
#> 2            1     8     3     2

car_pivot %>%
  rows(transmission) %>%
  columns(cylinder) %>%
  values(no_vehicles) %>%
  pivot()
#> # A tibble: 3 x 3
#>   cylinder   `0`   `1`
#>      <dbl> <int> <int>
#> 1        4     3     8
#> 2        6     4     3
#> 3        8    12     2
```
