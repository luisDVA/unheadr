
<!-- README.md is generated from README.Rmd. Please edit that file -->

# unheadr <img src="man/figures/logosmall.png" align="right" />

<!-- badges: start -->

[![](https://img.shields.io/badge/doi-10.4404/hystrix--00133--2018-red.svg)](https://doi.org/10.4404/hystrix-00133-2018)
[![](https://www.r-pkg.org/badges/version/unheadr?color=purple)](https://cran.r-project.org/package=unheadr)
[![](http://cranlogs.r-pkg.org/badges/last-month/unheadr?color=orange)](https://cran.r-project.org/package=unheadr)
[![](http://cranlogs.r-pkg.org/badges/grand-total/unheadr?color=blue)](https://cran.r-project.org/package=unheadr)
[![CRAN
checks](https://cranchecks.info/badges/summary/unheadr)](https://cran.r-project.org/web/checks/check_results_unheadr.html)
[![Travis build
status](https://travis-ci.org/luisDVA/unheadr.svg?branch=master)](https://travis-ci.org/luisDVA/unheadr)
[![Codecov test
coverage](https://codecov.io/gh/luisDVA/unheadr/branch/master/graph/badge.svg)](https://codecov.io/gh/luisDVA/unheadr?branch=master)
<!-- badges: end -->

The goal of `unheadr` is to help wrangle data when it has embedded
subheaders, or when values are wrapped across several rows.
<https://unheadr.liomys.mx/>

## Installation

You can install the CRAN release or the development version with:

``` r
# Install unheadr from CRAN:
install.packages("unheadr")

# Or install the development version from GitHub with:
# install.packages("remotes")
remotes::install_github("luisDVA/unheadr")
```

The reasoning behind the package and some of the possible uses of
`unheadr` are described in this publication:

Verde Arregoitia, L. D., Cooper, N., D’Elía, G. (2018). Good practices
for sharing analysis-ready data in mammalogy and biodiversity research.
*Hystrix, the Italian Journal of Mammalogy*, 29(2), 155-161. [Open
Access,
DOI 10.4404/hystrix-00133-2018](https://doi.org/10.4404/hystrix-00133-2018)

## Usage

Load the package first.

``` r
library(unheadr)
```

### Main functions

**`untangle2()`**

`untangle2()` puts embedded subheaders into their own variable, using
regular expressions to identify them.

In the data below (a subset of a bundled dataset which can be loaded
with `data(primates2017)`), there are rows that correspond to values in
grouping variables. These should be in their own column. Instead, they
are embedded within the data rectangle. This is a common practice in
many disciplines. This data presentation looks OK and is easy to read,
but hard to work with (for example: calculating group-wise summaries).

In this example, values for an implicit “geographic region” variable and
an implicit “taxonomic family” variable are embedded in the column that
contains the observational units (the scientific names of various
primates).

| scientific\_name        | common\_name                 | red\_list\_status | mass\_kg |
| :---------------------- | :--------------------------- | :---------------- | -------: |
| Asia                    | NA                           | NA                |       NA |
| CERCOPITHECIDAE         | NA                           | NA                |       NA |
| Trachypithecus obscurus | Dusky Langur                 | NT                |     7.13 |
| Presbytis sumatra       | Black Sumatran Langur        | EN                |     6.00 |
| Rhinopithecus roxellana | Golden Snub-nosed Monkey     | EN                |       NA |
| HYLOBATIDAE             | NA                           | NA                |       NA |
| Hylobates funereus      | East Bornean Gray Gibbon     | EN                |       NA |
| Hylobates klossii       | Kloss’s Gibbon               | EN                |     5.80 |
| Nomascus concolor       | Western Black Crested Gibbon | CR                |     7.71 |

For a tidier structure, the subheaders embedded in the
*scientific\_name* column need to be plucked out and placed in their own
variable. This was initially the main objective of `unheadr` and what
`untangle2()` was made for. The function can be used with `magrittr`
pipes as a `dplyr`-type verb.

If these subheaders can be matched in bulk with a regular expression
because they share a prefix, suffix, or anything in common, we can save
a lot of time. Otherwise, they can be matched by name. For more details,
see the examples and vignette.

The ‘untangled’ version of the data:

| scientific\_name        | common\_name                 | red\_list\_status | mass\_kg | family          | region |
| :---------------------- | :--------------------------- | :---------------- | -------: | :-------------- | :----- |
| Trachypithecus obscurus | Dusky Langur                 | NT                |     7.13 | CERCOPITHECIDAE | Asia   |
| Presbytis sumatra       | Black Sumatran Langur        | EN                |     6.00 | CERCOPITHECIDAE | Asia   |
| Rhinopithecus roxellana | Golden Snub-nosed Monkey     | EN                |       NA | CERCOPITHECIDAE | Asia   |
| Hylobates funereus      | East Bornean Gray Gibbon     | EN                |       NA | HYLOBATIDAE     | Asia   |
| Hylobates klossii       | Kloss’s Gibbon               | EN                |     5.80 | HYLOBATIDAE     | Asia   |
| Nomascus concolor       | Western Black Crested Gibbon | CR                |     7.71 | HYLOBATIDAE     | Asia   |

Now we can easily perform grouping operations and summarize the data
(e.g. calculating average body mass by Family).

**`unbreak_vals()`**

This function uses regex to fix values that are broken across two rows.
This usually happens when we are formatting a table and we need to fit
it on a page.

``` r
# Set up a toy dataset
dogsDesc <-
  data.frame(
    stringsAsFactors = FALSE,
    dogs = c(
      "Retriever", "(Golden)",
      "Retriever", "(Labrador)", "Bulldog", "(French)"
    ),
    coat = c("long", NA, "short", NA, "short", NA)
  )

dogsDesc
#>         dogs  coat
#> 1  Retriever  long
#> 2   (Golden)  <NA>
#> 3  Retriever short
#> 4 (Labrador)  <NA>
#> 5    Bulldog short
#> 6   (French)  <NA>
```

We can match the opening brackets with regex.

``` r
unbreak_vals(df = dogsDesc, regex = "^\\(", ogcol = dogs, newcol = dogs_unbroken)
#>          dogs_unbroken  coat
#> 1   Retriever (Golden)  long
#> 2 Retriever (Labrador) short
#> 3     Bulldog (French) short
```

**`unwrap_cols()`**

Use this function to unwrap and glue values that have been wrapped
across multiple rows for presentation purposes, with an inconsistent
number of empty or `NA` values padding out the columns.

``` r
# Set up the data
nyk <-
  data.frame(
    stringsAsFactors = FALSE,
    player = c(
      "Marcus Camby", NA, NA,
      NA, NA, NA, NA, "Allan Houston", NA,
      "Latrell Sprewell", NA, NA
    ),
    listed_height_m. = c(
      2.11, NA, NA, NA, NA, NA,
      NA, 1.98, NA, 1.96, NA, NA
    ),
    teams_chronological = c(
      "Raptors", "Knicks",
      "Nuggets", "Clippers", "Trail Blazers",
      "Rockets", "Knicks", "Pistons",
      "Knicks", "Warriors", "Knicks",
      "Timberwolves"
    ),
    position = c(
      "Power forward", "Center",
      NA, NA, NA, NA, NA,
      "Shooting guard", NA, "Small forward", NA, NA
    )
  )
nyk
#>              player listed_height_m. teams_chronological       position
#> 1      Marcus Camby             2.11             Raptors  Power forward
#> 2              <NA>               NA              Knicks         Center
#> 3              <NA>               NA             Nuggets           <NA>
#> 4              <NA>               NA            Clippers           <NA>
#> 5              <NA>               NA       Trail Blazers           <NA>
#> 6              <NA>               NA             Rockets           <NA>
#> 7              <NA>               NA              Knicks           <NA>
#> 8     Allan Houston             1.98             Pistons Shooting guard
#> 9              <NA>               NA              Knicks           <NA>
#> 10 Latrell Sprewell             1.96            Warriors  Small forward
#> 11             <NA>               NA              Knicks           <NA>
#> 12             <NA>               NA        Timberwolves           <NA>
```

Unwrap the elements in the variable that defines the groups, separating
with commas.

``` r
unwrap_cols(nyk, groupingVar = player, separator = ", ")
#> # A tibble: 3 x 4
#>   player     listed_height_m. teams_chronological                  position     
#>   <chr>      <chr>            <chr>                                <chr>        
#> 1 Marcus Ca… 2.11             Raptors, Knicks, Nuggets, Clippers,… Power forwar…
#> 2 Allan Hou… 1.98             Pistons, Knicks                      Shooting gua…
#> 3 Latrell S… 1.96             Warriors, Knicks, Timberwolves       Small forward
```

**`unbreak_rows()`**

This function merges sets of two contiguous rows upwards by pasting the
values of the lagging row to the values of the leading row (identified
using regular expressions).

The following table of basketball records has two sets of header rows
with values broken across two contiguous rows.

``` r
bball <- data.frame(
  stringsAsFactors = FALSE,
  v1 = c(
    "Player", NA, "Sleve McDichael", "Dean Wesrey",
    "Karl Dandleton", "Player",
    NA,
    "Mike Sernandez",
    "Glenallen Mixon",
    "Rey McSriff"
  ),
  v2 = c(
    "Most points", "in a game", "55", "43", "41", "Most varsity",
    "games played", "111", "109",
    "104"
  ),
  v3 = c(
    "Season", "(year ending)", "2001", "2000", "2010", "Season",
    "(year ending)", "2005",
    "2004", "2002"
  )
)
```

`unbreak_rows()` merges these rows if we can match them with a common
pattern.

``` r
# Match with regex on variable v2
unbreak_rows(bball, regex = "^Most", ogcol = v2)
#> 2 matches
#>                v1                        v2                   v3
#> 1          Player     Most points in a game Season (year ending)
#> 2 Sleve McDichael                        55                 2001
#> 3     Dean Wesrey                        43                 2000
#> 4  Karl Dandleton                        41                 2010
#> 5          Player Most varsity games played Season (year ending)
#> 6  Mike Sernandez                       111                 2005
#> 7 Glenallen Mixon                       109                 2004
#> 8     Rey McSriff                       104                 2002
```

**`mash_colnames()`**

When column names are broken up across the top *n* rows of a data frame
or tibble, `mash_colnames()` makes many header rows into column names.
Existing names can be kept or ignored.

``` r
# Data with broken headers
babies <-
  data.frame(
    stringsAsFactors = FALSE,
    Baby = c(NA, NA, "Angie", "Yean", "Pierre"),
    Age = c("in", "months", "11", "9", "7"),
    Weight = c("kg", NA, "2", "3", "4"),
    Ward = c(NA, NA, "A", "B", "C")
  )

babies
#>     Baby    Age Weight Ward
#> 1   <NA>     in     kg <NA>
#> 2   <NA> months   <NA> <NA>
#> 3  Angie     11      2    A
#> 4   Yean      9      3    B
#> 5 Pierre      7      4    C
```

``` r
# Mash, including the object names
mash_colnames(babies, n_name_rows = 2, keep_names = TRUE)
#>     Baby Age_in_months Weight_kg Ward
#> 3  Angie            11         2    A
#> 4   Yean             9         3    B
#> 5 Pierre             7         4    C
```

For inputs with ragged column names (NA values in the first row), the
first row can be filled row-wise before mashing.

``` r
# Data with ragged headers
survey <-
  data.frame(
    stringsAsFactors = FALSE,
    X1 = c("Participant", NA, "12", "34", "45", "123"),
    X2 = c(
      "How did you hear about us?",
      "TV", "TRUE", "FALSE", "FALSE", "FALSE"
    ),
    X3 = c(NA, "Social Media", "FALSE", "TRUE", "FALSE", "FALSE"),
    X4 = c(NA, "Radio", "FALSE", "TRUE", "FALSE", "TRUE"),
    X5 = c(NA, "Flyer", "FALSE", "FALSE", "FALSE", "FALSE"),
    X6 = c("Age", NA, "31", "23", "19", "24")
  )
survey
#>            X1                         X2           X3    X4    X5   X6
#> 1 Participant How did you hear about us?         <NA>  <NA>  <NA>  Age
#> 2        <NA>                         TV Social Media Radio Flyer <NA>
#> 3          12                       TRUE        FALSE FALSE FALSE   31
#> 4          34                      FALSE         TRUE  TRUE FALSE   23
#> 5          45                      FALSE        FALSE FALSE FALSE   19
#> 6         123                      FALSE        FALSE  TRUE FALSE   24
```

``` r
# Ignoring names and using sliding headers
mash_colnames(survey,2,keep_names = FALSE,sliding_headers = TRUE, sep = "_")
#>   Participant How did you hear about us?_TV
#> 3          12                          TRUE
#> 4          34                         FALSE
#> 5          45                         FALSE
#> 6         123                         FALSE
#>   How did you hear about us?_Social Media How did you hear about us?_Radio
#> 3                                   FALSE                            FALSE
#> 4                                    TRUE                             TRUE
#> 5                                   FALSE                            FALSE
#> 6                                   FALSE                             TRUE
#>   How did you hear about us?_Flyer Age
#> 3                            FALSE  31
#> 4                            FALSE  23
#> 5                            FALSE  19
#> 6                            FALSE  24
```

**`annotate_mf()` and `annotate_mf_all()`**

Sometimes embedded subheaders can’t be matched by content or context,
but they share the same formatting in a spreadsheet file.

`annotate_mf()` flattens four common approaches to confer meaningful
formatting to cells and adds this as a character string to the target
variable.

``` r
example_spreadsheet <- system.file("extdata/dog_test.xlsx", package = "unheadr")
annotate_mf(example_spreadsheet,orig = Task, new=Task_annotated)
```

`annotate_mf_all()` applies the same approach to all values in the
dataset.

``` r
example_spreadsheet_all <- system.file("extdata/boutiques.xlsx", package = "unheadr")
annotate_mf(example_spreadsheet_all)
```

Lastly, `regex_valign()` can adjust the whitespace (padding) within a
character vector with one element per line, for easier parsing with
`readr`.

``` r
guests <- 
  unlist(strsplit(c("6     COAHUILA        20/03/2020
712        COAHUILA             20/03/2020"),"\n"))
guests
#> [1] "6     COAHUILA        20/03/2020"          
#> [2] "712        COAHUILA             20/03/2020"
regex_valign(guests, "\\b(?=[A-Z])")
#> [1] "6          COAHUILA        20/03/2020"     
#> [2] "712        COAHUILA             20/03/2020"
```

The inconsistent whitespace between the elements in each line can be
adjusted after matching a position of interest through regular
expressions.
