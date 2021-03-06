# https://github.com/jennybc/repurrrsive#readme
library(purrr)
library(repurrrsive)

# basic usage -------------------------------------------------------------
a <- 1:5
l_a <- as.list(a)

## square each element of the list
map(l_a, ~.x^2)



# extraction --------------------------------------------------------------
## Find as many ways to extract "name" element from a list
got_chars

map(got_chars, "name")
map(got_chars, 3)
map(got_chars, ~.x[["name"]])


# extraction 2 ------------------------------------------------------------
## Extract "name", "culture", "gender", "born" elements from a list
x <- map(got_chars, `[`, c("name", "culture", "gender", "born"))
x <- map(got_chars, magrittr::extract, c("name", "culture", "gender", "born"))


# extraction 3 ------------------------------------------------------------
## Extract "name", "culture", "gender", "born" elements from a list
## and put it into the dataframe
map_dfr(got_chars, magrittr::extract, c("name", "culture", "gender", "born"))


# extraction 4 ------------------------------------------------------------
## Do the same, but for each element separately.
## Think about why would that be preferable?
library(tibble)
got_chars %>% {
  tibble(
    name = map_chr(., "name"),
    culture = map_chr(., "culture"),
    gender = map_chr(., "gender"),
    born = map_chr(., "born")
  )
}


# extraction 5 ------------------------------------------------------------
## Take a look at `got_chars` closely and find 4 parts in each element of the
## list that correspond to 4 atomic vectors in R. Extract them.
got_chars %>% {
  tibble(
    name = map_chr(., "name"),
    alive = map_lgl(., "alive"),
    id = map_int(., "id"),
    id_dbl = map_dbl(., "id")
  )
}


# typed mapping ------------------------------------------------------------
## For each element of the `got_chars`, find out how many films each character
## has been in
map_int(got_chars, ~length(.x[["povBooks"]]))


# Using functions ---------------------------------------------------------
## For each character, create a string showing his/her aliases.
## There are at least 4 ways to do it. Can you think of them? Which one do you
## like best?
aliases <- set_names(map(got_chars, "aliases"), map_chr(got_chars, "name"))

my_fun <- function(x) paste(x, collapse = " | ")
map(aliases, my_fun)

map(aliases, function(x) paste(x, collapse = " | "))
map(aliases, paste, collapse = " | ")
map(aliases, ~ paste(.x, collapse = " | "))


# map2 --------------------------------------------------------------------
## Using vectors provided, create a string for each character indicating the
## year they were born
nms <- got_chars %>%
  map_chr("name")
birth <- got_chars %>%
  map_chr("born")

map2_chr(nms, birth, ~ paste(.x, "was born", .y)) %>% tail()
map2_chr(nms, birth, ~ glue::glue("{.x} was born {.y}")) %>% tail()


# map2 --------------------------------------------------------------------
## For each element of the `got_chars`, find out how many films AND how many
## series each character has been in.
map2_int(got_chars, got_chars, ~length(.x[["povBooks"]]) + length(.y[["tvSeries"]]))

