library(dplyr)

# variants -----------------------------------------------------------------

## Create as many ways to apply the same function to columns
mtcars <- tibble::as_tibble(mtcars)

# function: mean(x, na.rm = TRUE, trim = 0.4)

# _at ---------------------------------------------------------------------
## Find mean of height, mass and birth year in starwars dataset

## Do the same, but change how you reference variables
## (bare variables -> strings, strings -> bare variables)

## Find mean of third and sixth columns in mtcars

# _if ----------------------------------------------------------------------
## Find means of all columns in `mtcars` where at least 3 elements are 0

## Group iris by all factor variables


# _all --------------------------------------------------------------------
## Find 90% quantile of all columns in iris for each species

## What would you change to make sure that columns are named appropriately?

# all_vars and any_vars ---------------------------------------------------
mtcars

## Filter all rows using columns that start with c, provided that at least any
## of them can be divided by 4 without a remainder

## Find all rows where all columns starting with c are below 6

# tidyr -------------------------------------------------------------------
## Take `gather_summarize_acts` function and change `gather` to appropriate pivot
gather_summarize_acts <- function(.data, ...){
  transmute(.data, ...) %>%
    gather("Variable", "Value", -one_of(group_vars(.))) %>%
    group_by_at(vars(c(group_vars(.), Variable))) %>%
    summarize_at(vars("Value"), summary_functions)
}
