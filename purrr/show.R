library(purrr)
library(repurrrsive)
suppressPackageStartupMessages(library(tidyverse))

# map ---------------------------------------------------------------------
# basic usage of map
1:10 %>%
  map(rnorm, n = 10)

1:10 %>%
  map(function(x) rnorm(10, x))

1:10 %>%
  map(~ rnorm(10, .x))

ex <- list("a" = 3, "b" = 4)

map_at(ex, c("a"), ~.^2)
map_at(ex, 1, ~.^2)

map_if(ex, function(elm) elm == 3, ~.^2)

# got_chars ---------------------------------------------------------------
got_chars <- got_chars %>%
  set_names(map_chr(got_chars, "name"))

# extracting from the list
got_chars %>%
  map("name")

## first element of each list
got_chars %>%
  map(1)

## second book of each list
got_chars %>%
  map(list("books", 2))

# map2 --------------------------------------------------------------------
# from https://jennybc.github.io/purrr-tutorial/ls03_map-function-syntax.html
nms <- got_chars %>%
  map_chr("name")
birth <- got_chars %>%
  map_chr("born")
my_fun <- function(x, y) glue::glue("{x} was born {y}")
map2_chr(nms, birth, my_fun) %>% head()

# pmap --------------------------------------------------------------------
df <- got_chars %>% {
  tibble::tibble(
    name = map_chr(., "name"),
    aliases = map(., "aliases"),
    allegiances = map(., "allegiances")
  )
}
my_fun <- function(name, aliases, allegiances) {
  paste(name, "has", length(aliases), "aliases and",
        length(allegiances), "allegiances")
}
df %>%
  pmap_chr(my_fun) %>%
  tail()

## dealing with more input
df <- got_chars %>% {
  tibble::tibble(
    name = map_chr(., "name"),
    aliases = map(., "aliases"),
    allegiances = map(., "allegiances"),
    url = map_chr(., "url")
  )
}
my_fun <- function(name, aliases, allegiances) {
  paste(name, "has", length(aliases), "aliases and",
        length(allegiances), "allegiances")
}
## fails
df %>%
  pmap_chr(my_fun) %>%
  tail()

## succeeds
my_fun <- function(name, aliases, allegiances, ...) {
  paste(name, "has", length(aliases), "aliases and",
        length(allegiances), "allegiances")
}
df %>%
  pmap_chr(my_fun) %>%
  tail()

# walk --------------------------------------------------------------------
1:10 %>%
  walk(~cat("hello"))

# imap --------------------------------------------------------------------
imap_chr(sample(10), ~ paste0(.y, ": ", .x))

## .x corresponds to value, .y to name/index
my_fun <- function(x, y) glue::glue("{x} was born {y}")
imap_chr(map_chr(got_chars, "born"), my_fun)


# recipe ------------------------------------------------------------------
aliases <- set_names(map(got_chars, "aliases"), map_chr(got_chars, "name"))

## Find out how many things are changing

## Find one representative element
a <- map(got_chars, "aliases")[[19]]
a <- map(got_chars, "aliases")[[16]]

## Find a way to get to result you want
paste(a, sep = " | ")
paste(a, collapse = " | ")

## Try it with couple elements
aliases[15:17] %>%
  map_chr(paste, collapse = " | ")

## Celebrate
