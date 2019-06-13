library(tidyr)


# pivot_longer ------------------------------------------------------------

## Basic usage
relig_income %>%
  pivot_longer(-religion, names_to = "income", values_to = "count")

## Numeric data in column names
billboard %>%
  pivot_longer(
    cols = starts_with("wk"),
    names_to = "week",
    values_to = "rank",
    values_drop_na = TRUE
  )

billboard %>%
  pivot_longer(
    cols = starts_with("wk"),
    names_to = "week",
    names_prefix = "wk",
    names_ptypes = list(week = integer()),
    values_to = "rank",
    values_drop_na = TRUE,
  )

## Many variables in column names
who

who %>% pivot_longer(
  cols = new_sp_m014:newrel_f65,
  names_to = c("diagnosis", "gender", "age"),
  names_pattern = "new_?(.*)_(.)(.*)",
  values_to = "count"
)

who %>% pivot_longer(
  cols = new_sp_m014:newrel_f65,
  names_to = c("diagnosis", "gender", "age"),
  names_pattern = "new_?(.*)_(.)(.*)",
  names_ptypes = list(
    gender = factor(levels = c("f", "m")),
    age = factor(
      levels = c("014", "1524", "2534", "3544", "4554", "5564", "65"),
      ordered = TRUE
    )
  ),
  values_to = "count"
)

## Multiple observations per row
library(dplyr)
family <- tribble(
  ~family,  ~dob_child1,  ~dob_child2, ~gender_child1, ~gender_child2,
  1L, "1998-11-26", "2000-01-29",             1L,             2L,
  2L, "1996-06-22",           NA,             2L,             NA,
  3L, "2002-07-11", "2004-04-05",             2L,             2L,
  4L, "2004-10-10", "2009-08-27",             1L,             1L,
  5L, "2000-12-05", "2005-02-28",             2L,             1L,
)
family <- family %>% mutate_at(vars(starts_with("dob")), readr::parse_date)
family

# this is not possible with `gather`
family %>%
  pivot_longer(
    -family,
    names_to = c(".value", "child"),
    names_sep = "_",
    values_drop_na = TRUE
  )


# pivot_wider -------------------------------------------------------------

## Basic use
fish_encounters %>% pivot_wider(names_from = station, values_from = seen)

fish_encounters %>% pivot_wider(
  names_from = station,
  values_from = seen,
  values_fill = list(seen = 0)
)

## Aggregation
warpbreaks <- warpbreaks %>%
  as_tibble() %>%
  select(wool, tension, breaks)
warpbreaks

warpbreaks %>% count(wool, tension)

warpbreaks %>% pivot_wider(names_from = wool, values_from = breaks)

warpbreaks %>%
  pivot_wider(
    names_from = wool,
    values_from = breaks,
    values_fn = list(breaks = mean)
  )

## Generate column name from multiple variables
## http://stackoverflow.com/questions/24929954
production <- expand_grid(
  product = c("A", "B"),
  country = c("AI", "EI"),
  year = 2000:2014
) %>%
  filter((product == "A" & country == "AI") | product == "B") %>%
  mutate(production = rnorm(nrow(.)))
production

# spread solution
production %>%
  unite(prod_count, product, country) %>%
  spread(prod_count, production)

# pivot_wider solution
production %>% pivot_wider(
  names_from = c(product, country),
  values_from = production
)

## Tidy census
us_rent_income

us_rent_income %>%
  pivot_wider(names_from = variable, values_from = c(estimate, moe))


# Manual specs ------------------------------------------------------------

## Basic usage
spec <- relig_income %>% pivot_longer_spec(
  cols = -religion,
  names_to = "income",
  values_to = "count"
)
relig_income %>%
  pivot_longer(spec = spec)

spec

## Specifying different column names
us_rent_income %>%
  pivot_wider(names_from = variable, values_from = c(estimate, moe))

us_rent_income %>%
  pivot_wider_spec(names_from = variable, values_from = c(estimate, moe))

spec <- us_rent_income %>%
  expand(variable, .value = c("estimate", "moe")) %>%
  mutate(
    .name = paste0(variable, ifelse(.value == "moe", "_moe", ""))
  )
spec

us_rent_income %>% pivot_wider(spec = spec)

## Spec by hand
construction

spec <- tribble(
  ~.name,            ~.value, ~units,  ~region,
  "1 unit",          "n",     "1",     NA,
  "2 to 4 units",    "n",     "2-4",   NA,
  "5 units or more", "n",     "5+",    NA,
  "Northeast",       "n",     NA,      "Northeast",
  "Midwest",         "n",     NA,      "Midwest",
  "South",           "n",     NA,      "South",
  "West",            "n",     NA,      "West",
)

construction %>% pivot_longer(spec = spec)

## pivot_longer and pivot_wider are symmetric
construction %>%
  pivot_longer(spec = spec) %>%
  pivot_wider(spec = spec)


# Rectangling -------------------------------------------------------------
library(repurrrsive)

## GitHub users
users <- tibble(user = gh_users)
users

names(users$user[[1]])

users %>% unnest_wider(user)

users %>% hoist(user,
                followers = "followers",
                login = "login",
                url = "html_url"
)

## GitHub repos
repos <- tibble(repo = gh_repos)
repos

repos <- repos %>% unnest_longer(repo)
repos

repos %>% hoist(repo,
                login = c("owner", "login"), # same interface as with purrr::pluck
                name = "name",
                homepage = "homepage",
                watchers = "watchers_count"
)

# to simplify things a bit
tibble(repo = gh_repos) %>%
  unnest_auto(repo) %>%
  unnest_auto(repo)

## GoT
chars <- tibble(char = got_chars)
chars

chars2 <- chars %>% unnest_wider(char)
chars2 %>% select_if(is.list)

# What you do next will depend on the purposes of the analysis. Maybe you want a row for every book and TV series that the character appears in:
chars2 %>%
  select(name, books, tvSeries) %>%
  pivot_longer(c(books, tvSeries), names_to = "media", values_to = "value") %>%
  unnest_longer(value)

# Or maybe you want to build a table that lets you match title to name
chars2 %>%
  select(name, title = titles) %>%
  unnest_longer(title)

# Can also use `unnest_auto`
tibble(char = got_chars) %>%
  unnest_auto(char) %>%
  select(name, title = titles) %>%
  unnest_auto(title)

