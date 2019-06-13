library(dplyr)

# variants -----------------------------------------------------------------

## Create as many ways to apply the same function to columns
mtcars <- tibble::as_tibble(mtcars)

# function: mean(x, na.rm = TRUE, trim = 0.4)

mtcars %>%
  summarize_at(vars(cyl), mean, na.rm = TRUE, trim = 0.4)

mtcars %>%
  summarize_at(vars(cyl), ~ mean(., na.rm = TRUE, trim = 0.4))

mtcars %>%
  summarize_at(vars(cyl), list(mean), na.rm = TRUE, trim = 0.4)

mtcars %>%
  summarize_at(vars(cyl), list(~mean(., na.rm = TRUE, trim = 0.4)))


# _at ---------------------------------------------------------------------
## Find mean of height, mass and birth year in starwars dataset
starwars %>%
  summarise_at(vars(height, mass, birth_year), mean, na.rm = TRUE)

## Do the same, but change how you reference variables
## (bare variables -> strings, strings -> bare variables)
starwars %>%
  summarise_at(vars("height", "mass", "birth_year"), mean, na.rm = TRUE)

## Find mean of third and sixth columns in mtcars
mtcars %>%
  summarise_at(vars(3, 6), mean, na.rm = TRUE)

# _if ----------------------------------------------------------------------
## Find means of all columns in `mtcars` where at least 3 elements are 0
is_zero <- function(x) {
  sum(x == 0, na.rm = TRUE) >= 3
}

mtcars %>%
  summarize_if(is_zero, mean)

## Group iris by all factor variables
group_by_if(iris, is.factor)


# _all --------------------------------------------------------------------
## Find 90% quantile of all columns in iris for each species
iris %>%
  group_by(Species) %>%
  summarize_all(list(quantile), probs = 0.9)

## What would you change to make sure that columns are named appropriately?
iris %>%
  group_by(Species) %>%
  summarize_all(list(q90 = quantile), probs = 0.9)


# all_vars and any_vars ---------------------------------------------------
mtcars
## Filter all rows using columns that start with c, provided that at least any
## of them can be divided by 4 without a remainder
filter_at(mtcars, vars(starts_with("c")), any_vars((. %% 4) == 0))

## Find all rows where all columns starting with c are below 6
filter_at(mtcars, vars(starts_with("c")), all_vars(. <= 6))

# tidyr -------------------------------------------------------------------
## Take `gather_summarize_acts` function and change `gather` to appropriate pivot
gather_summarize_acts <- function(.data, ...){
  transmute(.data, ...) %>%
    gather("Variable", "Value", -one_of(group_vars(.))) %>%
    group_by_at(vars(c(group_vars(.), Variable))) %>%
    summarize_at(vars("Value"), summary_functions)
}
