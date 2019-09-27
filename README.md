
<!-- README.md is generated from README.Rmd. Please edit that file -->

# pivotable

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![Travis build
status](https://travis-ci.org/edgararuiz/pivotable.svg?branch=master)](https://travis-ci.org/edgararuiz/pivotable)
[![Codecov test
coverage](https://codecov.io/gh/edgararuiz/pivotable/branch/master/graph/badge.svg)](https://codecov.io/gh/edgararuiz/pivotable?branch=master)
[![CRAN
status](https://www.r-pkg.org/badges/version/pivotable)](https://CRAN.R-project.org/package=pivotable)
<!-- badges: end -->

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

sales %>%
  values(sum(sales))
#>   sum(sales)   
#>   10032628.85
```

``` r
sales %>%
  rows(status) %>%
  values(sum(sales)) 
#>             sum(sales)   
#> Cancelled     194487.48  
#> Disputed       72212.86  
#> In Process    144729.96  
#> On Hold       178979.19  
#> Resolved      150718.28  
#> Shipped      9291501.08  
#> Total       10032628.85
```

``` r
sales %>%
  rows(status) %>%
  columns(year_id) %>%
  values(sum(sales))
#>             2003        2004        2005        Total        
#> Cancelled     48710.92   145776.56                194487.48  
#> Disputed                              72212.86     72212.86  
#> In Process                           144729.96    144729.96  
#> On Hold                   26260.21   152718.98    178979.19  
#> Resolved      28550.59    24078.61    98089.08    150718.28  
#> Shipped     3439718.03  4528047.22  1323735.83   9291501.08  
#> Total       3516979.54   4724162.6  1791486.71  10032628.85
```

``` r
sales %>%
  rows(status) %>%
  columns(year_id) %>%
  values(sum(sales)) %>%
  pivot()
#>        Cancelled  Disputed  In Process  On Hold    Resolved   Shipped     Total        
#> 2003    48710.92                                    28550.59  3439718.03   3516979.54  
#> 2004   145776.56                         26260.21   24078.61  4528047.22    4724162.6  
#> 2005              72212.86   144729.96  152718.98   98089.08  1323735.83   1791486.71  
#> Total  194487.48  72212.86   144729.96  178979.19  150718.28  9291501.08  10032628.85
```

## Dimensions and Measures

``` r
orders <- sales %>%
  group_by(ordernumber, country, year_id, month_id, customername, state, status) %>% 
  summarise(order_sale = sum(sales)) %>%
  ungroup() %>%
  start_pivot_prep() %>%
  dimensions(
    order_date = dim_hierarchy(
      year_id,
      month_id      
    ),
    status, 
    country
  ) %>%
  measures(
    no_orders = n(), 
    order_amount = sum(order_sale),
    no_sales = sum(ifelse(status %in% c("In Process", "Shipped"), 1, 0)),
    sales_amount = sum(ifelse(status %in% c("In Process", "Shipped"), order_sale, 0))
    )
```

``` r
orders %>%
  rows(status)
#> Cancelled     
#> Disputed      
#> In Process    
#> On Hold       
#> Resolved      
#> Shipped       
#> Total
```

``` r
orders %>%
  rows(order_date) %>%
  values(sales_amount) 
#>        sales_amount  
#> 2003     3439718.03  
#> 2004     4528047.22  
#> 2005     1468465.79  
#> Total    9436231.04
```

``` r
orders %>%
  rows(order_date) %>%
  values(sales_amount) %>%
  drill(order_date)
#>               sales_amount  
#> 2003   1          129753.6  
#>        2         140836.19  
#>        3          174504.9  
#>        4         201609.55  
#>        5         192673.11  
#>        6         168082.56  
#>        7         187731.88  
#>        8          197809.3  
#>        9         263973.36  
#>        10        491029.46  
#>        11       1029837.66  
#>        12        261876.46  
#>        Total    3439718.03  
#> 2004   1         316577.42  
#>        2         311419.53  
#>        3         205733.73  
#>        4         206148.12  
#>        5         228080.73  
#>        6         186255.32  
#>        7         327144.09  
#>        8         461501.27  
#>        9         320750.91  
#>        10        552924.25  
#>        11       1038709.19  
#>        12        372802.66  
#>        Total    4528047.22  
#> 2005   1         295270.06  
#>        2         358186.18  
#>        3         320447.04  
#>        4         131218.33  
#>        5         363344.18  
#>        Total    1468465.79  
#> Total           9436231.04
```

## pivottabler

``` r
pt <- orders %>%
  rows(order_date) %>%
  values(no_orders) %>%
  to_pivottabler()

pt$asMatrix(repeatHeaders = TRUE, includeHeaders = TRUE)
#>      [,1]    [,2]       
#> [1,] ""      "no_orders"
#> [2,] "2003"  "104"      
#> [3,] "2004"  "144"      
#> [4,] "2005"  "59"       
#> [5,] "Total" "307"
```
