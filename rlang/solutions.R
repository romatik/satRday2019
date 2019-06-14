# proportion --------------------------------------------------------------
prop <- function(.data, x = n) {
  x <- enquo(x)
  .data %>% mutate(prop = !!x / sum(!!x))
}

## Desired result
iris %>%
  dplyr::count(Species) %>%
  prop(n)
# # A tibble: 3 x 3
# Species         n    prop
# <fct>          <int> <dbl>
# 1 setosa        50   0.333
# 2 versicolor    50   0.333
# 3 virginica     50   0.333

# unselect ----------------------------------------------------------------
## Write a function similar to `select`, but which will drop all specified columns
unselect <- function(.data, ...){
  dots <- rlang::enquos(...) %>%
    purrr::map(function(variable){
      rlang::quo(-!!variable)
    })
  .data %>%
    dplyr::select(!!!dots)
}

## example of usage
unselect(tibble::as_tibble(mtcars), mpg:disp, qsec)


# histogram ---------------------------------------------------------------
## Create a function that plots arbitrary field as a histogram using ggplot
myhist <- function(.data, field, binwidth = 10) {
  ggplot(.data, aes(!!enquo(field))) +
    geom_histogram(binwidth = binwidth)
}

# Example of usage
myhist(iris, Petal.Length, 10)
myhist(iris, Petal.Length * 2, 10)


# grouped_mean ------------------------------------------------------------
## Given a following function:
grouped_mean2 <- function(.data, .summary_var, ...) {
  summary_var <- enquo(.summary_var)
  group_vars <- enquos(..., .named = TRUE)

  summary_nm <- as_name(summary_var)
  summary_nm <- paste0("avg_", summary_nm)
  names(group_vars) <- paste0("groups_", names(group_vars))

  .data %>%
    group_by(!!!group_vars) %>%
    summarise(!!summary_nm := mean(!!summary_var))
}
## How would you change it to take an arbitrary functions (instead of `mean`)?
## Make sure to find a way to change a name of the `summary_nm`
grouped_mean2 <- function(.data, .summary_var, ..., .f) {
  summary_var <- enquo(.summary_var)
  group_vars <- enquos(..., .named = TRUE)
  summary_nm <- as_name(summary_var)
  summary_nm <- paste0(as.character(substitute(.f)), "_", summary_nm)
  names(group_vars) <- paste0("groups_", names(group_vars))

  .data %>%
    group_by(!!!group_vars) %>%
    summarise(!!summary_nm := .f(!!summary_var))
}

grouped_mean2(mtcars, cyl, am, .f = sum)

# lagging -----------------------------------------------------------------
## Create a function to calculate arbitrary number of lags of a column
mult_lag <- function(data, variable, n = 10){
  variable <- rlang::enquo(variable)

  indices <- seq_len(n)
  quos <- purrr::map(indices, ~rlang::quo(dplyr::lag(!!variable, !!.x)) ) %>%
    purrr::set_names(glue::glue("lag_{indices}"))

  dplyr::mutate(data, !!!quos)
}

# example of usage
mult_lag(mtcars, cyl, n = 3)


# lagging 2 ---------------------------------------------------------------
## How would you change function above to take arbitrary number of columns?
## Hint: you might need `purrr::flatten`
mult_lag2 <- function(data, ..., n = 10){
  vars <- data %>% dplyr::select(...) %>% names()

  indices <- seq_len(n)
  quos <- purrr::map(vars, function(var){
    purrr::map(indices, ~rlang::quo(dplyr::lag(!!rlang::sym(var), !!.x))) %>%
      purrr::set_names(glue::glue("lag_{var}_{indices}"))
  }) %>%
    purrr::flatten()

  dplyr::mutate(data, !!!quos)
}

# example of usage
mult_lag2(mtcars, cyl:mpg, n = 3)

# linear -------------------------------------------------------------------
## Given following inputs:
intercept <- 10
coefs <- c(x1 = 5, x2 = -4)
## We want to generate following output:
# 10 + (5 * x1) + (-4 * x2)
## Hint: you'll need purrr::reduce and one more mapping function from `purrr`

linear <- function(intercept, coefs) {
  summands <- purrr::imap(coefs, ~ expr((!!.x * !!rlang::sym(.y))))
  summands <- c(intercept, summands)

  purrr::reduce(summands, ~ expr(!!.x + !!.y))
}

# Example of usage
linear(intercept, coefs)

