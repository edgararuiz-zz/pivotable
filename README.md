
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

  - [Intro](#intro)
  - [Installation](#installation)
  - [Pivot table](#pivot-table)
      - [Values](#values)
      - [Rows](#rows)
      - [Columns](#columns)
      - [Pivot](#pivot)
      - [Focus](#focus)
      - [Drill](#drill)
      - [Convert to tibble](#convert-to-tibble)
  - [Define dimensions and measures](#define-dimensions-and-measures)
  - [Database connections](#database-connections)
      - [Measures and dimensions](#measures-and-dimensions)
  - [pivottabler](#pivottabler)

## Intro

Create pivot tables with commonly used terms as commands such as:
`rows()`, `columns()` and `values()`, and string them together with a
pipe (`%>%`).

The idea is that the creation of a pivot table is done using code, as
opposed to drag-and-drop. This means that actions such as `pivot()` and
`drill()` are also possible, and performed using R commands.

Another goal of `pivotable` is to provide a framework to easily define
`measures()` and `dimensions()` of your data. The resulting R object can
then be used as the source of the pivot table. This should make it
possible to create consistent analysis, and subsequent reporting of the
data.

## Installation

``` r
# install.packages("remotes")
remotes::install_github("edgararuiz/pivotable")
```

## Pivot table

### Values

The `values()` function is used to add an aggregation in the pivot
table. When used against a data frame, you will have to provide an
aggregation formula of a field, or fields, within the data. If using a
pre-defined set of dimensions and measures, then simply call the desired
measure field, no need to re-aggregate. For more info see [Define
dimensions and measures](#define-dimensions-and-measures).

``` r
library(dplyr)
library(pivotable)

retail_orders %>%
  values(sum(sales))
#>   sum(sales)   
#>   10032628.85
```

### Rows

As its name indicates, `rows()` adds a data grouping based on the
variable or variables passed to the function. The aggregation is split
by the variable(s) and each total is displayed by row.

``` r
retail_orders %>%
  rows(country) %>%
  values(sum(sales)) 
#>              sum(sales)   
#> Australia       630623.1  
#> Austria        202062.53  
#> Belgium        108412.62  
#> Canada         224078.56  
#> Denmark        245637.15  
#> Finland        329581.91  
#> France        1110916.52  
#> Germany        220472.09  
#> Ireland         57756.43  
#> Italy          374674.31  
#> Japan          188167.81  
#> Norway          307463.7  
#> Philippines     94015.73  
#> Singapore      288488.41  
#> Spain         1215686.92  
#> Sweden         210014.21  
#> Switzerland    117713.56  
#> UK             478880.46  
#> USA           3627982.83  
#> Total        10032628.85
```

### Columns

As its name indicates, `rows()` adds a data grouping based on the
variable or variables passed to the function. The aggregation is split
by the variable(s) and each total is displayed by column.

``` r
retail_orders %>%
  rows(country) %>%
  columns(status) %>%
  values(sum(sales))
#>              Cancelled  Disputed  In Process  On Hold    Resolved   Shipped     Total        
#> Australia               14378.09    43971.43                         572273.58     630623.1  
#> Austria                                                   28550.59   173511.94    202062.53  
#> Belgium                              8411.95                         100000.67    108412.62  
#> Canada                                                               224078.56    224078.56  
#> Denmark                 26012.87                          24078.61   195545.67    245637.15  
#> Finland                                                              329581.91    329581.91  
#> France                              43784.69                        1067131.83   1110916.52  
#> Germany                                                              220472.09    220472.09  
#> Ireland                                                               57756.43     57756.43  
#> Italy                                                                374674.31    374674.31  
#> Japan                                                                188167.81    188167.81  
#> Norway                                                                307463.7     307463.7  
#> Philippines                                                           94015.73     94015.73  
#> Singapore                                                            288488.41    288488.41  
#> Spain         50010.65   31821.9    35133.34              53815.72  1044905.31   1215686.92  
#> Sweden        48710.92                         26260.21              135043.08    210014.21  
#> Switzerland                                                          117713.56    117713.56  
#> UK            50408.25                                               428472.21    478880.46  
#> USA           45357.66              13428.55  152718.98   44273.36  3372204.28   3627982.83  
#> Total        194487.48  72212.86   144729.96  178979.19  150718.28  9291501.08  10032628.85
```

### Pivot

Instead of “manually” switching the content of `rows()` and `columns()`,
specially during data exploration, simply pipe the code to the `pivot()`
command.

``` r
retail_orders %>%
  rows(country) %>%
  columns(status) %>%
  values(sum(sales)) %>%
  pivot()
#>             Australia  Austria    Belgium    Canada     Denmark    Finland    France      Germany    Ireland   Italy      Japan      Norway    Philippines  Singapore  Spain       Sweden     Switzerland  UK         USA         Total        
#> Cancelled                                                                                                                                                                50010.65   48710.92                50408.25    45357.66    194487.48  
#> Disputed     14378.09                                    26012.87                                                                                                         31821.9                                                    72212.86  
#> In Process   43971.43               8411.95                                     43784.69                                                                                 35133.34                                       13428.55    144729.96  
#> On Hold                                                                                                                                                                             26260.21                           152718.98    178979.19  
#> Resolved                28550.59                         24078.61                                                                                                        53815.72                                       44273.36    150718.28  
#> Shipped     572273.58  173511.94  100000.67  224078.56  195545.67  329581.91  1067131.83  220472.09  57756.43  374674.31  188167.81  307463.7     94015.73  288488.41  1044905.31  135043.08    117713.56  428472.21  3372204.28   9291501.08  
#> Total        630623.1  202062.53  108412.62  224078.56  245637.15  329581.91  1110916.52  220472.09  57756.43  374674.31  188167.81  307463.7     94015.73  288488.41  1215686.92  210014.21    117713.56  478880.46  3627982.83  10032628.85
```

### Focus

To limit the pivot table to display only a subset of the pivot table,
use `focus()`

``` r
retail_orders %>%
  rows(country) %>%
  columns(status) %>%
  values(total_sales = sum(sales)) %>%
  focus(
    country %in% c("Japan", "USA", "UK"), 
    status == "Shipped",
    total_sales > 200000
    )
#>        Shipped     Total       
#> UK      428472.21   428472.21  
#> USA    3372204.28  3372204.28  
#> Total  3800676.49  3800676.49
```

### Drill

Another powerful thing of pivot tables is the ability to drill down into
the data. To do this in `pivotable`, you will need to define a hierarchy
dimension using the `dim_hierarchy()` command. That command is made to
be called within one of the dimension definition functions, such as
`rows()` or `columns()`. The order of the hierarchy is defined by the
order in which the variables is passed to the function.

``` r
retail_orders %>%
  rows(order_date = dim_hierarchy(
    year = as.integer(format(orderdate, "%Y")),
    month = as.integer(format(orderdate, "%m"))
    )
  ) %>%
  values(sum(sales))
#>        sum(sales)   
#> 2003    3516979.54  
#> 2004     4724162.6  
#> 2005    1791486.71  
#> Total  10032628.85
```

The `drill()` command will add the next level of the hierarchy dimension
to the pivot table.

``` r
retail_orders %>%
  rows(order_date = dim_hierarchy(
    year = as.integer(format(orderdate, "%Y")),
    month = as.integer(format(orderdate, "%m"))
    )
  ) %>%
  values(sum(sales)) %>%
  drill(order_date)
#>               sum(sales)   
#> 2003   1         129753.6  
#>        2        140836.19  
#>        3         174504.9  
#>        4        201609.55  
#>        5        192673.11  
#>        6        168082.56  
#>        7        187731.88  
#>        8         197809.3  
#>        9        263973.36  
#>        10       568290.97  
#>        11      1029837.66  
#>        12       261876.46  
#>        Total   3516979.54  
#> 2004   1        316577.42  
#>        2        311419.53  
#>        3        205733.73  
#>        4        206148.12  
#>        5        273438.39  
#>        6        286674.22  
#>        7        327144.09  
#>        8        461501.27  
#>        9        320750.91  
#>        10       552924.25  
#>        11      1089048.01  
#>        12       372802.66  
#>        Total    4724162.6  
#> 2005   1        339543.42  
#>        2        358186.18  
#>        3        374262.76  
#>        4        261633.29  
#>        5        457861.06  
#>        Total   1791486.71  
#> Total         10032628.85
```

A helper function called `dim_hierarchy_mqy()` creates a three level
date hierarchy: year, quarter and month. The function will create the
formulas to calculate each level, but those formulas will not be
evaluated until the drilling into the level. The formulas are generic
enough to work on database back-ends.

``` r
retail_orders %>%
  rows(order_date = dim_hierarchy_mqy(orderdate)) %>%
  values(sum(sales)) %>%
  drill(order_date)
#>               sum(sales)   
#> 2003   1        445094.69  
#>        2        562365.22  
#>        3        649514.54  
#>        4       1860005.09  
#>        Total   3516979.54  
#> 2004   1        833730.68  
#>        2        766260.73  
#>        3       1109396.27  
#>        4       2014774.92  
#>        Total    4724162.6  
#> 2005   1       1071992.36  
#>        2        719494.35  
#>        Total   1791486.71  
#> Total         10032628.85
```

### Convert to tibble

The `as_tibble()` function is supported to convert the resulting pivot
table into a rectangular `tibble()`

``` r
retail_orders %>%
  rows(country) %>%
  columns(status) %>%
  values(sum(sales)) %>%
  as_tibble()
#> # A tibble: 19 x 7
#>    row_name    Cancelled Disputed `In Process` `On Hold` Resolved  Shipped
#>    <chr>           <dbl>    <dbl>        <dbl>     <dbl>    <dbl>    <dbl>
#>  1 Australia         NA    14378.       43971.       NA       NA   572274.
#>  2 Austria           NA       NA           NA        NA    28551.  173512.
#>  3 Belgium           NA       NA         8412.       NA       NA   100001.
#>  4 Canada            NA       NA           NA        NA       NA   224079.
#>  5 Denmark           NA    26013.          NA        NA    24079.  195546.
#>  6 Finland           NA       NA           NA        NA       NA   329582.
#>  7 France            NA       NA        43785.       NA       NA  1067132.
#>  8 Germany           NA       NA           NA        NA       NA   220472.
#>  9 Ireland           NA       NA           NA        NA       NA    57756.
#> 10 Italy             NA       NA           NA        NA       NA   374674.
#> 11 Japan             NA       NA           NA        NA       NA   188168.
#> 12 Norway            NA       NA           NA        NA       NA   307464.
#> 13 Philippines       NA       NA           NA        NA       NA    94016.
#> 14 Singapore         NA       NA           NA        NA       NA   288488.
#> 15 Spain          50011.   31822.       35133.       NA    53816. 1044905.
#> 16 Sweden         48711.      NA           NA     26260.      NA   135043.
#> 17 Switzerland       NA       NA           NA        NA       NA   117714.
#> 18 UK             50408.      NA           NA        NA       NA   428472.
#> 19 USA            45358.      NA        13429.   152719.   44273. 3372204.
```

## Define dimensions and measures

With `pivotable`, it is possible to pre-define a set of dimensions and
measures that can then be easily accesses and re-used by pivot tables.
The idea is to provide a way to centralize data definitions, which
creates a consistent reporting.

``` r
orders <- retail_orders %>%
  dimensions(
    order_date = dim_hierarchy(
      year = as.integer(format(orderdate, "%Y")),
      month = as.integer(format(orderdate, "%m"))
    ),
    status, 
    country
  ) %>%
  measures(
    orders_qty = n(), 
    order_total = sum(sales),
    sales_qty = sum(ifelse(status %in% c("In Process", "Shipped"), 1, 0)),
    sales_total = sum(ifelse(status %in% c("In Process", "Shipped"), sales, 0))
    )
```

``` r
orders %>%
  rows(status) %>%
  columns(order_date) %>%
  values(sales_total)
#>             2003        2004        2005        Total       
#> Cancelled            0           0                       0  
#> Disputed                                     0           0  
#> In Process                           144729.96   144729.96  
#> On Hold                          0           0           0  
#> Resolved             0           0           0           0  
#> Shipped     3439718.03  4528047.22  1323735.83  9291501.08  
#> Total       3439718.03  4528047.22  1468465.79  9436231.04
```

``` r
orders %>%
  rows(status) %>%
  columns(order_date) %>%
  values(sales_total) %>%
  drill(order_date)
#>             2003                                                                                                                                          2004                                                                                                                                             2005                                                               Total       
#>             1         2          3         4          5          6          7          8         9          10         11          12         Total       1          2          3          4          5          6          7          8          9          10         11          12         Total       1          2          3          4          5          Total                   
#> Cancelled                                                                                                           0                                  0                                                      0          0                                                                              0                                                                              0  
#> Disputed                                                                                                                                                                                                                                                                                                                                            0          0           0           0  
#> In Process                                                                                                                                                                                                                                                                                                                                             144729.96   144729.96   144729.96  
#> On Hold                                                                                                                                                                                                                                                                          0                      0                                           0          0           0           0  
#> Resolved                                                                                                            0                                  0                                                                                                                         0                      0          0                     0                                 0           0  
#> Shipped     129753.6  140836.19  174504.9  201609.55  192673.11  168082.56  187731.88  197809.3  263973.36  491029.46  1029837.66  261876.46  3439718.03  316577.42  311419.53  205733.73  206148.12  228080.73  186255.32  327144.09  461501.27  320750.91  552924.25  1038709.19  372802.66  4528047.22  295270.06  358186.18  320447.04  131218.33  218614.22  1323735.83  9291501.08  
#> Total       129753.6  140836.19  174504.9  201609.55  192673.11  168082.56  187731.88  197809.3  263973.36  491029.46  1029837.66  261876.46  3439718.03  316577.42  311419.53  205733.73  206148.12  228080.73  186255.32  327144.09  461501.27  320750.91  552924.25  1038709.19  372802.66  4528047.22  295270.06  358186.18  320447.04  131218.33  363344.18  1468465.79  9436231.04
```

## Database connections

Because `pivotable` uses `dplyr` commands to create the aggregations.
This allows `pivotable` to take advantage of the same integration that
`dplyr` has, such as Spark, databases and `data.table`.

``` r
library(DBI)
library(RSQLite)

con <- dbConnect(SQLite(), ":memory:")

tbl_sales <- copy_to(con, retail_orders)

tbl_sales %>%
  columns(status) %>%
  rows(country) %>%
  values(sum(sales, na.rm = TRUE))
#>              Cancelled  Disputed  In Process  On Hold    Resolved   Shipped     Total        
#> Australia               14378.09    43971.43                         572273.58     630623.1  
#> Austria                                                   28550.59   173511.94    202062.53  
#> Belgium                              8411.95                         100000.67    108412.62  
#> Canada                                                               224078.56    224078.56  
#> Denmark                 26012.87                          24078.61   195545.67    245637.15  
#> Finland                                                              329581.91    329581.91  
#> France                              43784.69                        1067131.83   1110916.52  
#> Germany                                                              220472.09    220472.09  
#> Ireland                                                               57756.43     57756.43  
#> Italy                                                                374674.31    374674.31  
#> Japan                                                                188167.81    188167.81  
#> Norway                                                                307463.7     307463.7  
#> Philippines                                                           94015.73     94015.73  
#> Singapore                                                            288488.41    288488.41  
#> Spain         50010.65   31821.9    35133.34              53815.72  1044905.31   1215686.92  
#> Sweden        48710.92                         26260.21              135043.08    210014.21  
#> Switzerland                                                          117713.56    117713.56  
#> UK            50408.25                                               428472.21    478880.46  
#> USA           45357.66              13428.55  152718.98   44273.36  3372204.28   3627982.83  
#> Total        194487.48  72212.86   144729.96  178979.19  150718.28  9291501.08  10032628.85
```

### Measures and dimensions

It is also possible create a data definition against a database
connection. The `dimensions()` and `measures()` calculations will not be
send to the database until used in the pivot table.

``` r
orders_db <- tbl_sales %>%
  dimensions(
    status, 
    country
  ) %>%
  measures(
    orders_qty = n(), 
    order_total = sum(sales, na.rm = TRUE),
    sales_qty = sum(ifelse(status %in% c("In Process", "Shipped"), 1, 0), na.rm = TRUE),
    sales_total = sum(ifelse(status %in% c("In Process", "Shipped"), sales, 0), na.rm = TRUE)
    )
```

``` r
orders_db %>%
  columns(status) %>%
  values(sales_total)
#>   Cancelled  Disputed  In Process  On Hold  Resolved  Shipped     Total       
#>           0         0   144729.96        0         0  9291501.08  9436231.04
```

``` r
dbDisconnect(con)
```

## pivottabler

`pivotable` uses `pivottabler` to print the pivot table into the R
console. The `to_pivottabler()` returns the actual `pivottabler` object.
This allows you to further customize the pivot table using that
package’s API.

``` r
pt <- orders %>%
  rows(order_date) %>%
  values(orders_qty) %>%
  to_pivottabler()

pt$asMatrix(repeatHeaders = TRUE, includeHeaders = TRUE)
#>      [,1]    [,2]        
#> [1,] ""      "orders_qty"
#> [2,] "2003"  "104"       
#> [3,] "2004"  "144"       
#> [4,] "2005"  "59"        
#> [5,] "Total" "307"
```
