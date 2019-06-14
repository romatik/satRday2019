# https://github.com/jennybc/repurrrsive#readme
library(purrr)
library(repurrrsive)

# basic usage -------------------------------------------------------------
a <- 1:5
l_a <- as.list(a)

## square each element of the list

# extraction --------------------------------------------------------------
## Find as many ways to extract "name" element from a list
got_chars

# extraction 2 ------------------------------------------------------------
## Extract "name", "culture", "gender", "born" elements from a list


# extraction 3 ------------------------------------------------------------
## Extract "name", "culture", "gender", "born" elements from a list
## and put it into the dataframe


# extraction 4 ------------------------------------------------------------
## Do the same, but for each element separately.
## Think about why would that be preferable?


# extraction 5 ------------------------------------------------------------
## Take a look at `got_chars` closely and find 4 parts in each element of the
## list that correspond to 4 atomic vectors in R. Extract them.


# typed mapping ------------------------------------------------------------
## For each element of the `got_chars`, find out how many films each character
## has been in


# Using functions ---------------------------------------------------------
## For each character, create a string showing his/her aliases.
## There are at least 4 ways to do it. Can you think of them? Which one do you
## like best?
aliases <- set_names(map(got_chars, "aliases"), map_chr(got_chars, "name"))

# map2 --------------------------------------------------------------------
## Using vectors provided, create a string for each character indicating the
## year they were born
nms <- got_chars %>%
  map_chr("name")
birth <- got_chars %>%
  map_chr("born")


# map2 --------------------------------------------------------------------
## For each element of the `got_chars`, find out how many films AND how many
## series each character has been in.

