
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
  - [Pivot table operations](#pivot-table-operations)
      - [Switch rows to columns](#switch-rows-to-columns)
      - [Filter](#filter)
      - [Drill](#drill)
      - [Totals](#totals)
      - [Default values](#default-values)
      - [Convert to tibble](#convert-to-tibble)
  - [Define dimensions and measures](#define-dimensions-and-measures)
  - [Database, Spark and `data.table`
    connections](#database-spark-and-data-table-connections)
      - [Measures and dimensions](#measures-and-dimensions)
  - [pivottabler](#pivottabler)

## Intro

Create pivot tables with commonly used terms as commands such as:
`pivot_rows()`, `pivot_columns()` and `pivot_values()`, and string them
together with a pipe (`%>%`).

The idea is that the creation of a pivot table is done using code, as
opposed to drag-and-drop. This means that actions such as `pivot_flip()`
and `pivot_drill()` are also possible, and performed using R commands.

Another goal of `pivotable` is to provide a framework to easily define
`prep_measures()` and `prep_dimensions()` of your data. The resulting R
object can then be used as the source of the pivot table. This should
make it possible to create consistent analysis, and subsequent reporting
of the data.

## Installation

``` r
# install.packages("remotes")
remotes::install_github("edgararuiz/pivotable")
```

## Pivot table

### Values

The `pivot_values()` function is used to add an aggregation in the pivot
table. When used against a data frame, you will have to provide an
aggregation formula of a field, or fields, within the data. If using a
pre-defined set of dimensions and measures, then simply call the desired
measure field, no need to re-aggregate. For more info see [Define
dimensions and measures](#define-dimensions-and-measures).

``` r
library(dplyr)
library(pivotable)

retail_orders %>%
  pivot_values(sum(sales))
#>   sum(sales)   
#>   10032628.85
```

Multiple aggregations are supported by `pivot_values()`

``` r
retail_orders %>%
  pivot_values(sum(sales), n())
#>   sum(sales)   n()  
#>   10032628.85  307
```

The aggregations can also be named inside `pivot_values()`

``` r
retail_orders %>%
  pivot_values(total_sales = sum(sales), no_sales = n())
#>   total_sales  no_sales  
#>   10032628.85       307
```

### Rows

As its name indicates, `pivot_rows()` adds a data grouping based on the
variable or variables passed to the function. The aggregation is split
by the variable(s) and each total is displayed by row.

``` r
retail_orders %>%
  pivot_rows(country) %>%
  pivot_values(sum(sales)) 
#>              sum(sales)  
#> Australia      630623.1  
#> Austria       202062.53  
#> Belgium       108412.62  
#> Canada        224078.56  
#> Denmark       245637.15  
#> Finland       329581.91  
#> France       1110916.52  
#> Germany       220472.09  
#> Ireland        57756.43  
#> Italy         374674.31  
#> Japan         188167.81  
#> Norway         307463.7  
#> Philippines    94015.73  
#> Singapore     288488.41  
#> Spain        1215686.92  
#> Sweden        210014.21  
#> Switzerland   117713.56  
#> UK            478880.46  
#> USA          3627982.83
```

### Columns

As its name indicates, `pivot_rows()` adds a data grouping based on the
variable or variables passed to the function. The aggregation is split
by the variable(s) and each total is displayed by column.

``` r
retail_orders %>%
  pivot_rows(country) %>%
  pivot_columns(status) %>%
  pivot_values(sum(sales))
#>              Cancelled  Disputed  In Process  On Hold    Resolved  Shipped     
#> Australia               14378.09    43971.43                        572273.58  
#> Austria                                                  28550.59   173511.94  
#> Belgium                              8411.95                        100000.67  
#> Canada                                                              224078.56  
#> Denmark                 26012.87                         24078.61   195545.67  
#> Finland                                                             329581.91  
#> France                              43784.69                       1067131.83  
#> Germany                                                             220472.09  
#> Ireland                                                              57756.43  
#> Italy                                                               374674.31  
#> Japan                                                               188167.81  
#> Norway                                                               307463.7  
#> Philippines                                                          94015.73  
#> Singapore                                                           288488.41  
#> Spain         50010.65   31821.9    35133.34             53815.72  1044905.31  
#> Sweden        48710.92                         26260.21             135043.08  
#> Switzerland                                                         117713.56  
#> UK            50408.25                                              428472.21  
#> USA           45357.66              13428.55  152718.98  44273.36  3372204.28
```

## Pivot table operations

### Switch rows to columns

Instead of “manually” switching the content of `pivot_rows()` and
`pivot_columns()`, specially during data exploration, simply pipe the
code to the `pivot_flip()` command.

``` r
retail_orders %>%
  pivot_rows(country) %>%
  pivot_columns(status) %>%
  pivot_values(sum(sales)) %>%
  pivot_flip()
#>             Australia  Austria    Belgium    Canada     Denmark    Finland    France      Germany    Ireland   Italy      Japan      Norway    Philippines  Singapore  Spain       Sweden     Switzerland  UK         USA         
#> Cancelled                                                                                                                                                                50010.65   48710.92                50408.25    45357.66  
#> Disputed     14378.09                                    26012.87                                                                                                         31821.9                                                 
#> In Process   43971.43               8411.95                                     43784.69                                                                                 35133.34                                       13428.55  
#> On Hold                                                                                                                                                                             26260.21                           152718.98  
#> Resolved                28550.59                         24078.61                                                                                                        53815.72                                       44273.36  
#> Shipped     572273.58  173511.94  100000.67  224078.56  195545.67  329581.91  1067131.83  220472.09  57756.43  374674.31  188167.81  307463.7     94015.73  288488.41  1044905.31  135043.08    117713.56  428472.21  3372204.28
```

`pivotable` also includes support for the `t()` method from base R. It
will perform the exact same operation as `pivot_flip()`

``` r
retail_orders %>%
  pivot_rows(country) %>%
  pivot_columns(status) %>%
  pivot_values(sum(sales)) %>%
  t()
#>             Australia  Austria    Belgium    Canada     Denmark    Finland    France      Germany    Ireland   Italy      Japan      Norway    Philippines  Singapore  Spain       Sweden     Switzerland  UK         USA         
#> Cancelled                                                                                                                                                                50010.65   48710.92                50408.25    45357.66  
#> Disputed     14378.09                                    26012.87                                                                                                         31821.9                                                 
#> In Process   43971.43               8411.95                                     43784.69                                                                                 35133.34                                       13428.55  
#> On Hold                                                                                                                                                                             26260.21                           152718.98  
#> Resolved                28550.59                         24078.61                                                                                                        53815.72                                       44273.36  
#> Shipped     572273.58  173511.94  100000.67  224078.56  195545.67  329581.91  1067131.83  220472.09  57756.43  374674.31  188167.81  307463.7     94015.73  288488.41  1044905.31  135043.08    117713.56  428472.21  3372204.28
```

### Filter

To limit the pivot table to display only a subset of the pivot table,
use `pivot_focus()`

``` r
retail_orders %>%
  pivot_rows(country) %>%
  pivot_columns(status) %>%
  pivot_values(total_sales = sum(sales)) %>%
  pivot_focus(
    country %in% c("Japan", "USA", "UK"), 
    status == "Shipped",
    total_sales > 200000
    )
#>      Shipped     
#> UK    428472.21  
#> USA  3372204.28
```

`pivotable` also supports `dplyr`’s `filter()` command.

``` r
retail_orders %>%
  pivot_rows(country) %>%
  pivot_columns(status) %>%
  pivot_values(total_sales = sum(sales)) %>%
  filter(
    country %in% c("Japan", "USA", "UK"), 
    status == "Shipped",
    total_sales > 200000
    )
#>      Shipped     
#> UK    428472.21  
#> USA  3372204.28
```

### Drill

Another powerful thing of pivot tables is the ability to drill down into
the data. To do this in `pivotable`, you will need to define a hierarchy
dimension using the `dim_hierarchy()` command. That command is made to
be called within one of the dimension definition functions, such as
`pivot_rows()` or `pivot_columns()`. The order of the hierarchy is
defined by the order in which the variables is passed to the function.

``` r
retail_orders %>%
  pivot_rows(order_date = dim_hierarchy(
    year = as.integer(format(orderdate, "%Y")),
    month = as.integer(format(orderdate, "%m"))
    )
  ) %>%
  pivot_values(sum(sales))
#>       sum(sales)  
#> 2003  3516979.54  
#> 2004   4724162.6  
#> 2005  1791486.71
```

The `pivot_drill()` command will add the next level of the hierarchy
dimension to the pivot table.

``` r
retail_orders %>%
  pivot_rows(order_date = dim_hierarchy(
    year = as.integer(format(orderdate, "%Y")),
    month = as.integer(format(orderdate, "%m"))
    )
  ) %>%
  pivot_values(sum(sales)) %>%
  pivot_drill(order_date)
#>           sum(sales)  
#> 2003  1     129753.6  
#>       2    140836.19  
#>       3     174504.9  
#>       4    201609.55  
#>       5    192673.11  
#>       6    168082.56  
#>       7    187731.88  
#>       8     197809.3  
#>       9    263973.36  
#>       10   568290.97  
#>       11  1029837.66  
#>       12   261876.46  
#> 2004  1    316577.42  
#>       2    311419.53  
#>       3    205733.73  
#>       4    206148.12  
#>       5    273438.39  
#>       6    286674.22  
#>       7    327144.09  
#>       8    461501.27  
#>       9    320750.91  
#>       10   552924.25  
#>       11  1089048.01  
#>       12   372802.66  
#> 2005  1    339543.42  
#>       2    358186.18  
#>       3    374262.76  
#>       4    261633.29  
#>       5    457861.06
```

A helper function called `dim_hierarchy_mqy()` creates a three level
date hierarchy: year, quarter and month. The function will create the
formulas to calculate each level, but those formulas will not be
evaluated until the drilling into the level. The formulas are generic
enough to work on database back-ends.

``` r
retail_orders %>%
  pivot_rows(order_date = dim_hierarchy_mqy(orderdate)) %>%
  pivot_values(sum(sales)) %>%
  pivot_drill(order_date)
#>          sum(sales)  
#> 2003  1   445094.69  
#>       2   562365.22  
#>       3   649514.54  
#>       4  1860005.09  
#> 2004  1   833730.68  
#>       2   766260.73  
#>       3  1109396.27  
#>       4  2014774.92  
#> 2005  1  1071992.36  
#>       2   719494.35
```

### Totals

The display of the totals can be controlled using `pivot_totals()`. It
is possible to control the display of row and column totals
individually. **Currently, sub-totals and grand totals are `sum()`
aggregates, so if the actual calculations are not record counts, or
another `sum()` consider leaving them off. For example, if the
calculation is a `mean()`, then the sub-total and grand total will be
the aggregate `sum()` total of the averages, which would be incorrect**.

``` r
retail_orders %>%
  pivot_rows(status, country) %>%
  pivot_values(sum(sales)) %>%
  pivot_totals(
    include_row_totals = TRUE
  )
#>                          sum(sales)   
#> Cancelled   Spain           50010.65  
#>             Sweden          48710.92  
#>             UK              50408.25  
#>             USA             45357.66  
#>             Total          194487.48  
#> Disputed    Australia       14378.09  
#>             Denmark         26012.87  
#>             Spain            31821.9  
#>             Total           72212.86  
#> In Process  Australia       43971.43  
#>             Belgium          8411.95  
#>             France          43784.69  
#>             Spain           35133.34  
#>             USA             13428.55  
#>             Total          144729.96  
#> On Hold     Sweden          26260.21  
#>             USA            152718.98  
#>             Total          178979.19  
#> Resolved    Austria         28550.59  
#>             Denmark         24078.61  
#>             Spain           53815.72  
#>             USA             44273.36  
#>             Total          150718.28  
#> Shipped     Australia      572273.58  
#>             Austria        173511.94  
#>             Belgium        100000.67  
#>             Canada         224078.56  
#>             Denmark        195545.67  
#>             Finland        329581.91  
#>             France        1067131.83  
#>             Germany        220472.09  
#>             Ireland         57756.43  
#>             Italy          374674.31  
#>             Japan          188167.81  
#>             Norway          307463.7  
#>             Philippines     94015.73  
#>             Singapore      288488.41  
#>             Spain         1044905.31  
#>             Sweden         135043.08  
#>             Switzerland    117713.56  
#>             UK             428472.21  
#>             USA           3372204.28  
#>             Total         9291501.08  
#> Total                    10032628.85
```

A default can be set to control if the column or row totals are
displayed. The default is set to not show.

``` r
pivot_default_totals(
  include_column_totals = TRUE, 
  include_row_totals = TRUE
  )

retail_orders %>%
  pivot_rows(status, country) %>%
  pivot_values(sum(sales))
#>                          sum(sales)   
#> Cancelled   Spain           50010.65  
#>             Sweden          48710.92  
#>             UK              50408.25  
#>             USA             45357.66  
#>             Total          194487.48  
#> Disputed    Australia       14378.09  
#>             Denmark         26012.87  
#>             Spain            31821.9  
#>             Total           72212.86  
#> In Process  Australia       43971.43  
#>             Belgium          8411.95  
#>             France          43784.69  
#>             Spain           35133.34  
#>             USA             13428.55  
#>             Total          144729.96  
#> On Hold     Sweden          26260.21  
#>             USA            152718.98  
#>             Total          178979.19  
#> Resolved    Austria         28550.59  
#>             Denmark         24078.61  
#>             Spain           53815.72  
#>             USA             44273.36  
#>             Total          150718.28  
#> Shipped     Australia      572273.58  
#>             Austria        173511.94  
#>             Belgium        100000.67  
#>             Canada         224078.56  
#>             Denmark        195545.67  
#>             Finland        329581.91  
#>             France        1067131.83  
#>             Germany        220472.09  
#>             Ireland         57756.43  
#>             Italy          374674.31  
#>             Japan          188167.81  
#>             Norway          307463.7  
#>             Philippines     94015.73  
#>             Singapore      288488.41  
#>             Spain         1044905.31  
#>             Sweden         135043.08  
#>             Switzerland    117713.56  
#>             UK             428472.21  
#>             USA           3372204.28  
#>             Total         9291501.08  
#> Total                    10032628.85
```

``` r
pivot_default_totals(FALSE, FALSE)
```

### Default values

By themselves, `pivot_rows()` and `pivot_columns()` will only provide a
list of the unique values of the data frame. There is a way to setup a
default aggregation by using `pivot_default_values()`

``` r
pivot_default_values(n())

retail_orders %>%
  pivot_rows(status)
#>             n()  
#> Cancelled     4  
#> Disputed      3  
#> In Process    6  
#> On Hold       4  
#> Resolved      4  
#> Shipped     286
```

### Convert to tibble

The `as_tibble()` function is supported to convert the resulting pivot
table into a rectangular `tibble()`

``` r
retail_orders %>%
  pivot_rows(country) %>%
  pivot_columns(status) %>%
  pivot_values(sum(sales)) %>%
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
  prep_dimensions(
    order_date = dim_hierarchy(
      year = as.integer(format(orderdate, "%Y")),
      month = as.integer(format(orderdate, "%m"))
    ),
    status, 
    country
  ) %>%
  prep_measures(
    orders_qty = n(), 
    order_total = sum(sales),
    sales_qty = sum(ifelse(status %in% c("In Process", "Shipped"), 1, 0)),
    sales_total = sum(ifelse(status %in% c("In Process", "Shipped"), sales, 0))
    )

orders
#> pivot_prep
#>  Dimensions
#>    **Name**   - **Field / Calc** 
#>    order_date - dim_hierarchy(...) 
#>    status     - status 
#>    country    - country 
#>  Measures
#>    **Name**    - **Aggregate Calc**
#>    orders_qty  - n()
#>    order_total - sum(sales)
#>    sales_qty   - sum(ifelse(status %in% c("In Process", "Shipped"), 1, 0))
#>    sales_total - sum(ifelse(status %in% c("In Process", "Shipped"), sales, 0))
```

``` r
orders %>%
  pivot_rows(status) %>%
  pivot_columns(order_date) %>%
  pivot_values(sales_total)
#>             2003        2004        2005        
#> Cancelled            0           0              
#> Disputed                                     0  
#> In Process                           144729.96  
#> On Hold                          0           0  
#> Resolved             0           0           0  
#> Shipped     3439718.03  4528047.22  1323735.83
```

``` r
orders %>%
  pivot_rows(status) %>%
  pivot_columns(order_date) %>%
  pivot_values(sales_total) %>%
  pivot_drill(order_date)
#>             2003                                                                                                                              2004                                                                                                                                 2005                                                   
#>             1         2          3         4          5          6          7          8         9          10         11          12         1          2          3          4          5          6          7          8          9          10         11          12         1          2          3          4          5          
#> Cancelled                                                                                                           0                                                                             0          0                                                                                                                            
#> Disputed                                                                                                                                                                                                                                                                                                                    0          0  
#> In Process                                                                                                                                                                                                                                                                                                                     144729.96  
#> On Hold                                                                                                                                                                                                                                                              0                                                      0          0  
#> Resolved                                                                                                            0                                                                                                                                                0                     0                     0                        
#> Shipped     129753.6  140836.19  174504.9  201609.55  192673.11  168082.56  187731.88  197809.3  263973.36  491029.46  1029837.66  261876.46  316577.42  311419.53  205733.73  206148.12  228080.73  186255.32  327144.09  461501.27  320750.91  552924.25  1038709.19  372802.66  295270.06  358186.18  320447.04  131218.33  218614.22
```

## Database, Spark and `data.table` connections

Because `pivotable` uses `dplyr` commands to create the aggregations.
This allows `pivotable` to take advantage of the same integration that
`dplyr` has, such as Spark, databases and `data.table`.

``` r
library(DBI)
library(RSQLite)

con <- dbConnect(SQLite(), ":memory:")

tbl_sales <- copy_to(con, retail_orders)

tbl_sales %>%
  pivot_columns(status) %>%
  pivot_rows(country) %>%
  pivot_values(sum(sales, na.rm = TRUE))
#>              Cancelled  Disputed  In Process  On Hold    Resolved  Shipped     
#> Australia               14378.09    43971.43                        572273.58  
#> Austria                                                  28550.59   173511.94  
#> Belgium                              8411.95                        100000.67  
#> Canada                                                              224078.56  
#> Denmark                 26012.87                         24078.61   195545.67  
#> Finland                                                             329581.91  
#> France                              43784.69                       1067131.83  
#> Germany                                                             220472.09  
#> Ireland                                                              57756.43  
#> Italy                                                               374674.31  
#> Japan                                                               188167.81  
#> Norway                                                               307463.7  
#> Philippines                                                          94015.73  
#> Singapore                                                           288488.41  
#> Spain         50010.65   31821.9    35133.34             53815.72  1044905.31  
#> Sweden        48710.92                         26260.21             135043.08  
#> Switzerland                                                         117713.56  
#> UK            50408.25                                              428472.21  
#> USA           45357.66              13428.55  152718.98  44273.36  3372204.28
```

### Measures and dimensions

It is also possible create a data definition against a database
connection. The `prep_dimensions()` and `prep_measures()` calculations
will not be send to the database until used in the pivot table.

``` r
orders_db <- tbl_sales %>%
  prep_dimensions(
    status, 
    country
  ) %>%
  prep_measures(
    orders_qty = n(), 
    order_total = sum(sales, na.rm = TRUE),
    sales_qty = sum(ifelse(status %in% c("In Process", "Shipped"), 1, 0), na.rm = TRUE),
    sales_total = sum(ifelse(status %in% c("In Process", "Shipped"), sales, 0), na.rm = TRUE)
    )
```

``` r
orders_db %>%
  pivot_columns(status) %>%
  pivot_values(sales_total)
#>   Cancelled  Disputed  In Process  On Hold  Resolved  Shipped     
#>           0         0   144729.96        0         0  9291501.08
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
  pivot_rows(order_date) %>%
  pivot_values(orders_qty) %>%
  to_pivottabler()

pt$asMatrix(repeatHeaders = TRUE, includeHeaders = TRUE)
#>      [,1]   [,2]        
#> [1,] ""     "orders_qty"
#> [2,] "2003" "104"       
#> [3,] "2004" "144"       
#> [4,] "2005" "59"
```
