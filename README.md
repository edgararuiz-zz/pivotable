
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
#>      642.9

mtcars %>%
  values(sum(mpg)) %>%
  rows(am) 
#>        sum(mpg)  
#> 0         325.8  
#> 1         317.1  
#> Total     642.9
```

``` r
mtcars %>%
  rows(am) %>%
  columns(cyl) %>%
  values(sum(mpg))
#>        4      6      8      Total  
#> 0       68.7   76.5  180.6  325.8  
#> 1      224.6   61.7   30.8  317.1  
#> Total  293.3  138.2  211.4  642.9

mtcars %>%
  rows(am) %>%
  columns(cyl) %>%
  values(sum(mpg)) %>%
  pivot()
#>        0      1      Total  
#> 4       68.7  224.6  293.3  
#> 6       76.5   61.7  138.2  
#> 8      180.6   30.8  211.4  
#> Total  325.8  317.1  642.9
```

``` r
mtcars %>%
  rows(am, cyl) %>%
  values(n())
#>               n()  
#> 0      4        3  
#>        6        4  
#>        8       12  
#>        Total   19  
#> 1      4        8  
#>        6        3  
#>        8        2  
#>        Total   13  
#> Total          32
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
#>        4   6  8   Total  
#> 0       3  4  12     19  
#> 1       8  3   2     13  
#> Total  11  7  14     32

car_pivot %>%
  rows(transmission) %>%
  columns(cylinder) %>%
  values(no_vehicles) %>%
  pivot()
#>        0   1   Total  
#> 4       3   8     11  
#> 6       4   3      7  
#> 8      12   2     14  
#> Total  19  13     32
```
